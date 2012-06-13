package {

	import events.AppEvent;
	import events.DataBaseEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.remote.Hosts;
	import system.AirContextMenu;
	import system.AirNativeMenu;
	import system.AppSettings;
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
			AppModel.engine.addEventListener(AppEvent.APP_SETTINGS, onAppSettings);
			AppModel.settings.initialize(stage);
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}

		private function onAppSettings(e:AppEvent):void
		{
			stage.nativeWindow.visible = true;
			AppModel.engine.removeEventListener(AppEvent.APP_SETTINGS, onAppSettings);
			NativeApplication.nativeApplication.startAtLogin = AppSettings.getSetting(AppSettings.START_AT_LOGIN);
			checkExpiredAndUpdates();
		}
		
		private function checkExpiredAndUpdates():void
		{
			if (LicenseManager.checkExpired()){
				AppModel.dispatch(AppEvent.APP_EXPIRED);
			}	else{
				AppModel.engine.addEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);
				AppModel.engine.addEventListener(AppEvent.APP_UPDATE_FAILURE, onAppUpToDate);
				AppModel.engine.addEventListener(AppEvent.APP_UPDATE_IGNORED, onAppUpToDate);
				AppModel.updater.checkForUpdate();
			}
		}

		private function onAppUpToDate(e:AppEvent):void
		{
			AppModel.engine.removeEventListener(AppEvent.APP_UP_TO_DATE, onAppUpToDate);
			AppModel.engine.removeEventListener(AppEvent.APP_UPDATE_FAILURE, onAppUpToDate);
			AppModel.engine.removeEventListener(AppEvent.APP_UPDATE_IGNORED, onAppUpToDate);			
			AppProxies.config.detectGit();
			AppModel.engine.addEventListener(AppEvent.GIT_SETTINGS, onGitReady);
		}

		private function onGitReady(e:AppEvent):void
		{
			AirNativeMenu.initialize(stage);
			AirContextMenu.initialize(stage);
			AppProxies.sshKeyGen.initialize();
			AppModel.engine.addEventListener(AppEvent.SSH_KEY_READY, onSSHKeyReady);
			AppModel.engine.removeEventListener(AppEvent.GIT_SETTINGS, onGitReady);
		}
		
		private function onSSHKeyReady(e:AppEvent):void
		{
			AppModel.database.initialize();
			AppModel.database.addEventListener(DataBaseEvent.DATABASE_READ, onDatabaseRead);
			AppModel.engine.removeEventListener(AppEvent.SSH_KEY_READY, onSSHKeyReady);
		}
		
		private function onDatabaseRead(e:DataBaseEvent):void
		{
			Hosts.initialize(e.data.accounts as Array);
			AppModel.engine.initialize(e.data.bookmarks as Array);
			AppModel.database.removeEventListener(DataBaseEvent.DATABASE_READ, onDatabaseRead);
		}
		
	}
	
}
