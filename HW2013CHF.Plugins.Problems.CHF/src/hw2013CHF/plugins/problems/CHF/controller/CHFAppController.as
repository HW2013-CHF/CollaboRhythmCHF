package hw2013CHF.plugins.problems.CHF.controller
{
	import collaboRhythm.shared.collaboration.model.CollaborationLobbyNetConnectionServiceProxy;
	import collaboRhythm.shared.collaboration.model.SynchronizationService;
	import collaboRhythm.shared.controller.apps.AppControllerBase;
	import collaboRhythm.shared.controller.apps.AppControllerConstructorParams;

	import hw2013CHF.plugins.problems.CHF.model.CHFModel;

	import hw2013CHF.plugins.problems.CHF.view.CHFButtonWidgetView;
	import hw2013CHF.plugins.problems.CHF.view.CHFView;

	import mx.core.UIComponent;

	public class CHFAppController extends AppControllerBase
	{
		public static const DEFAULT_NAME:String = "CHF";

		private var _widgetView:CHFButtonWidgetView;

		private var _model:CHFModel;
		private var _collaborationLobbyNetConnectionServiceProxyLocal:CollaborationLobbyNetConnectionServiceProxy;
		private var _synchronizationService:SynchronizationService;

		public function CHFAppController(constructorParams:AppControllerConstructorParams)
		{
			super(constructorParams);

			_collaborationLobbyNetConnectionServiceProxyLocal = _collaborationLobbyNetConnectionServiceProxy as
					CollaborationLobbyNetConnectionServiceProxy;
			_synchronizationService = new SynchronizationService(this,
					_collaborationLobbyNetConnectionServiceProxyLocal);
		}

		override protected function createWidgetView():UIComponent
		{
			_widgetView = new CHFButtonWidgetView();
			return _widgetView;
		}

		override public function reloadUserData():void
		{
			removeUserData();

			super.reloadUserData();
		}

		override protected function updateWidgetViewModel():void
		{
			super.updateWidgetViewModel();

			if (_widgetView && _activeRecordAccount)
			{
				_widgetView.init(this, _model);
			}
		}

		public override function get defaultName():String
		{
			return DEFAULT_NAME;
		}

		override public function get widgetView():UIComponent
		{
			return _widgetView;
		}

		override public function set widgetView(value:UIComponent):void
		{
			_widgetView = value as CHFButtonWidgetView;
		}

		override public function get isFullViewSupported():Boolean
		{
			return false;
		}

		override protected function get shouldShowFullViewOnWidgetClick():Boolean
		{
			return false;
		}

		protected override function removeUserData():void
		{
			_model = null;
			// unregister any components in the _componentContainer here, such as:
			// _componentContainer.unregisterServiceType(IIndividualMessageHealthRecordService);
		}

		public function showCHFView():void
		{
			if (_synchronizationService.synchronize("showCHFView"))
			{
				return;
			}

			_viewNavigator.pushView(CHFView, this);
		}

		override public function close():void
		{
			if (_synchronizationService)
			{
				_synchronizationService.removeEventListener(this);
				_synchronizationService = null;
			}

			super.close();
		}

		public function get model():CHFModel
		{
			return _model;
		}
	}
}
