package {

	import system.MyNativeMenu;
	import events.InstallEvent;
	import model.AppModel;
	import system.AirContextMenu;
	import system.LicenseManager;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.InvokeEvent;

	[SWF(backgroundColor="#ffffff", frameRate="31")]

	public class AppMain extends Sprite {
	
		private static var _menu:MyNativeMenu;
		
		public function AppMain()
		{	
		//	_menu= new MyNativeMenu();
			new AppModel();
			addChild(new AppView());
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}
		
		private function onInvokeEvent(e:InvokeEvent):void
		{
			stage.nativeWindow.visible = false;
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		// start the initialization sequence //	
			checkExpiredAndUpdates();
		}
		
		private function checkExpiredAndUpdates():void
		{
			if (LicenseManager.checkExpired()){
				stage.dispatchEvent(new InstallEvent(InstallEvent.APP_EXPIRED));
			}	else{
				AppModel.updater.checkForUpdate();				
			}
			AppModel.updater.addEventListener(InstallEvent.APP_UP_TO_DATE, onAppUpToDate);
		}			
		
		private function onAppUpToDate(e:InstallEvent):void
		{
			trace("AppMain.onAppUpToDate(e)");
			AppModel.proxies.config.loadGitSettings();
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_IS_READY, onGitReady);
		}

		private function onGitReady(e:InstallEvent):void
		{
			trace("AppMain.onGitReady(e)");
			AppModel.database.init();
			AirContextMenu.initialize(stage);
			AppModel.settings.initialize(stage);
		}
		
		
	}
	
}
