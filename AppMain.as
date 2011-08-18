package {

	import events.AppEvent;
	import events.DataBaseEvent;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.InvokeEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import system.AirContextMenu;
	import system.AirNativeMenu;
	import system.AppSettings;
	import system.LicenseManager;

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
			AppModel.settings.addEventListener(AppEvent.APP_SETTINGS, onAppSettings);
			AppModel.settings.initialize(stage);
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}

		private function onAppSettings(e:AppEvent):void
		{
			stage.nativeWindow.visible = true;
			AppModel.settings.removeEventListener(AppEvent.APP_SETTINGS, onAppSettings);
			NativeApplication.nativeApplication.startAtLogin = AppSettings.getSetting(AppSettings.START_AT_LOGIN);
			checkExpiredAndUpdates();
		}
		
		private function checkExpiredAndUpdates():void
		{
			if (LicenseManager.checkExpired()){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.APP_EXPIRED));
			}	else{
				AppModel.updater.addEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);
				AppModel.updater.addEventListener(AppEvent.APP_UPDATE_FAILURE, onAppUpToDate);
				AppModel.updater.addEventListener(AppEvent.APP_UPDATE_IGNORED, onAppUpToDate);
				AppModel.updater.checkForUpdate();
			}
		}

		private function onAppUpToDate(e:AppEvent):void
		{
			AppModel.updater.removeEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);
			AppModel.updater.removeEventListener(AppEvent.APP_UPDATE_FAILURE, onAppUpToDate);
			AppModel.updater.removeEventListener(AppEvent.APP_UPDATE_IGNORED, onAppUpToDate);			
			AppModel.proxies.config.detectGit();
			AppModel.proxies.config.addEventListener(AppEvent.GIT_SETTINGS, onGitReady);
		}

		private function onGitReady(e:AppEvent):void
		{
			AirNativeMenu.initialize(stage);
			AirContextMenu.initialize(stage);
			AppModel.proxies.sshKeyGen.detectApplicationKey();
			AppModel.proxies.sshKeyGen.addEventListener(AppEvent.SSH_KEY_READY, onSSHKeyReady);
			AppModel.proxies.config.removeEventListener(AppEvent.GIT_SETTINGS, onGitReady);
		}
		
		private function onSSHKeyReady(e:AppEvent):void
		{
			AppModel.database.initialize();
			AppModel.database.addEventListener(DataBaseEvent.DATABASE_READ, onDatabaseRead);
			AppModel.proxies.sshKeyGen.removeEventListener(AppEvent.SSH_KEY_READY, onSSHKeyReady);
		}
		
		private function onDatabaseRead(e:DataBaseEvent):void
		{
			Hosts.initialize(e.data.accounts as Array);
			AppModel.engine.initialize(e.data.bookmarks as Array);
			AppModel.database.removeEventListener(DataBaseEvent.DATABASE_READ, onDatabaseRead);
		}
		
	}
	
}
