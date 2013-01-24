package hw2013CHF.plugins.problems.CHF.controller
{
	import castle.flexbridge.reflection.ReflectionUtils;

	import collaboRhythm.plugins.schedule.shared.model.IHealthActionCreationControllerFactory;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionInputControllerFactory;
	import collaboRhythm.plugins.schedule.shared.model.IHealthActionListViewAdapterFactory;
	import collaboRhythm.shared.controller.apps.AppControllerInfo;
	import collaboRhythm.shared.model.services.IComponentContainer;
	import collaboRhythm.shared.pluginsSupport.IPlugin;
	import collaboRhythm.shared.ui.healthCharts.model.modifiers.IChartModifierFactory;

	import mx.modules.ModuleBase;

	public class CHFPluginModule extends ModuleBase implements IPlugin
	{
		public function CHFPluginModule()
		{
			super();
		}

		public function registerComponents(componentContainer:IComponentContainer):void
		{
			// TODO: each plugin should register one or more of the following components; implement or delete the code below as appropriate; using the CollaboRhythm file templates in IntelliJ IDEA may make this easier
			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(CHFAppController).name,
					AppControllerInfo,
					new AppControllerInfo(CHFAppController));

//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(CHFHealthActionListViewAdapterFactory).name,
//					IHealthActionListViewAdapterFactory,
//					new CHFHealthActionListViewAdapterFactory());
//
//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(CHFHealthActionInputControllerFactory).name,
//					IHealthActionInputControllerFactory,
//					new CHFHealthActionInputControllerFactory());
//
//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(CHFChartModifierFactory).name,
//					IChartModifierFactory,
//					new CHFChartModifierFactory());
//
//			componentContainer.registerComponentInstance(ReflectionUtils.getClassInfo(CHFHealthActionCreationControllerFactory).name,
//					IHealthActionCreationControllerFactory,
//					new CHFHealthActionCreationControllerFactory());
		}
	}
}
