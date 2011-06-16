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
			AppModel.settings.addEventListener(InstallEvent.APP_SETTINGS, onAppSettings);
			AppModel.settings.initialize(stage);
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}

		private function onAppSettings(e:InstallEvent):void
		{
			stage.nativeWindow.visible = true;
			AppModel.settings.removeEventListener(InstallEvent.APP_SETTINGS, onAppSettings);
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
			AppModel.proxies.config.loadGitSettings();
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_IS_READY, onGitReady);
		}

		private function onGitReady(e:InstallEvent):void
		{
			AppModel.database.init();
			AirContextMenu.initialize(stage);
		}
		
	}
	
}
