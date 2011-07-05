package {

	import events.InstallEvent;
	import model.AppModel;
	import system.AirContextMenu;
	import system.AirNativeMenu;
	import system.LicenseManager;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.InvokeEvent;

	[SWF(backgroundColor="#ffffff", frameRate="31")]

	public class AppMain extends Sprite {
	
		public function AppMain()
		{	
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
				AppModel.engine.dispatchEvent(new InstallEvent(InstallEvent.APP_EXPIRED));
			}	else{
				AppModel.updater.addEventListener(InstallEvent.APP_UP_TO_DATE, onAppUpToDate);
				AppModel.updater.addEventListener(InstallEvent.UPDATE_FAILURE, onAppUpToDate);
				AppModel.updater.addEventListener(InstallEvent.UPDATE_IGNORED, onAppUpToDate);
				AppModel.updater.checkForUpdate();
			}
		}

		private function onAppUpToDate(e:InstallEvent):void
		{
			AppModel.updater.removeEventListener(InstallEvent.APP_UP_TO_DATE, onAppUpToDate);
			AppModel.updater.removeEventListener(InstallEvent.UPDATE_FAILURE, onAppUpToDate);
			AppModel.updater.removeEventListener(InstallEvent.UPDATE_IGNORED, onAppUpToDate);			
			AppModel.proxies.config.detectGit();
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_SETTINGS, onGitReady);
		}

		private function onGitReady(e:InstallEvent):void
		{
			AppModel.database.init();
			AirNativeMenu.initialize(stage);
			AirContextMenu.initialize(stage);
			AppModel.proxies.config.removeEventListener(InstallEvent.GIT_SETTINGS, onGitReady);
		}
		
	}
	
}
