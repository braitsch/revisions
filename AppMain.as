package {

	import model.AppModel;
	import system.AirContextMenu;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.InvokeEvent;

	[SWF(backgroundColor="#ffffff", frameRate="31")]

	public class AppMain extends Sprite {
	
		private static var _view		:AppView;
		private static var _model		:AppModel;
		
		public function AppMain()
		{	
			_view = new AppView();
			_model = new AppModel();
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
