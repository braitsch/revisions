package {

	import model.AppModel;
	import model.db.AppSettings;
	import view.ui.AirContextMenu;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.InvokeEvent;

	[SWF(backgroundColor="#ffffff", frameRate="31")]

	public class AppMain extends Sprite {
	
		private static var _model		:AppModel = new AppModel();
		private static var _view		:AppView = new AppView();
		
		public function AppMain()
		{	
			addChild(_view);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			AirContextMenu.initialize(stage);
		//TODO temp solution to get around fdt overwriting AIR descriptor file //	
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}

		private function onInvokeEvent(e:InvokeEvent):void
		{
			stage.nativeWindow.visible = false;
			AppModel.settings.initialize(stage);
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}
		
	}
	
}
