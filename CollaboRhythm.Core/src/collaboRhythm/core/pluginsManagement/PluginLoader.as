package collaboRhythm.core.pluginsManagement
{
	import collaboRhythm.shared.pluginsSupport.IComponentContainer;
	import collaboRhythm.shared.pluginsSupport.IPlugin;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.core.IFlexModuleFactory;
	import mx.events.ModuleEvent;
	import mx.modules.IModule;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleLoader;

	[Event(name="complete", type="flash.events.Event")]
	public class PluginLoader extends EventDispatcher
	{
		private var loadedPlugins:Vector.<IPlugin> = new Vector.<IPlugin>();
		private var moduleLoaders:Vector.<ModuleLoader> = new Vector.<ModuleLoader>();
		private var pendingModuleLoaders:ArrayCollection = new ArrayCollection(); // list of loaders which are in the middle of loading
		private var _applicationPluginsDirectoryPath:String;
		private var _userPluginsDirectoryPath:String;
		private var _componentContainer:IComponentContainer;
		
		private static const PLUGINS_DIRECTORY_NAME:String = "plugins";
		
		public function PluginLoader()
		{
			_applicationPluginsDirectoryPath = File.applicationDirectory.resolvePath(PLUGINS_DIRECTORY_NAME).nativePath;
			_userPluginsDirectoryPath = File.applicationStorageDirectory.resolvePath(PLUGINS_DIRECTORY_NAME).nativePath;

			// Use /data/local instead of /data/data because attempting to write to /data/data fails with the error "failed to copy '<source>' to '<dest>': Permission denied"
			// TODO: figure out how to write to the appropriate /data/data directory using "adb push" and avoid using /data/local
			_userPluginsDirectoryPath = _userPluginsDirectoryPath.replace("/data/data", "/data/local");
		}
		
		public function get componentContainer():IComponentContainer
		{
			return _componentContainer;
		}

		public function set componentContainer(value:IComponentContainer):void
		{
			_componentContainer = value;
		}

		public function get userPluginsDirectoryPath():String
		{
			return _userPluginsDirectoryPath;
		}

		public function get applicationPluginsDirectoryPath():String
		{
			return _applicationPluginsDirectoryPath;
		}

		public function loadPlugins():void
		{
			var files:Array = getPluginFiles(userPluginsDirectoryPath);
			for each (var file:File in files)
			{
				loadPlugin(file);
			}
		}
		
		private function getPluginFiles(directoryPath:String):Array
		{
			var directory:File = new File(directoryPath); 
			if (directory.exists)
				return directory.getDirectoryListing();
			else
				return null;
		}
		
		private function loadPlugin(file:File):void
		{
			var moduleLoader:ModuleLoader = new ModuleLoader();
			moduleLoader.addEventListener(ModuleEvent.READY, moduleLoader_readyHandler);
			moduleLoader.addEventListener(ModuleEvent.ERROR, moduleLoader_errorHandler);

			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var moduleBytes:ByteArray = new ByteArray();
			stream.readBytes(moduleBytes);
			
			moduleLoaders.push(moduleLoader);
			pendingModuleLoaders.addItem(moduleLoader);
			moduleLoader.loadModule(file.nativePath, moduleBytes);
		}
		
		protected function moduleLoader_readyHandler(event:ModuleEvent):void
		{
			var moduleInfo:IModuleInfo = event.module;
			
			var flexModuleFactory:IFlexModuleFactory = moduleInfo.factory; 

			var plugin:IPlugin = flexModuleFactory.create() as IPlugin;
			if (plugin)
			{
				loadedPlugins.push(plugin);
				
				plugin.registerComponents(componentContainer);
			}
			
			var moduleLoader:ModuleLoader = event.target as ModuleLoader;
			if (!moduleLoader)
				throw new Error("event.target was not a ModuleLoader");
			
			var loaderIndex:int = pendingModuleLoaders.getItemIndex(moduleLoader);
			
			if (loaderIndex == -1)
				throw new Error("loader not found in pendingModuleLoaders");
				
			pendingModuleLoaders.removeItemAt(loaderIndex);
			
			if (pendingModuleLoaders.length == 0)
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function moduleLoader_errorHandler(event:ModuleEvent):void
		{
			trace(event.errorText);
		}
		
		public function unloadPlugins():void
		{
			for each (var moduleLoader:ModuleLoader in moduleLoaders)
			{
				moduleLoader.unloadModule();
			}
			moduleLoaders = new Vector.<ModuleLoader>();
			loadedPlugins = new Vector.<IPlugin>();
		}
	}
}