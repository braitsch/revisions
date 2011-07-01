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
	
	private static var _initialized:Boolean = false;
	
		public function AppMain()
		{	
			new AppModel();
			addChild(new AppView());
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}
		
		public static function get initialized():Boolean { return _initialized; }
		
		private function onInvokeEvent(e:InvokeEvent):void
		{
			trace("AppMain.onInvokeEvent(e)");
			stage.nativeWindow.visible = false;
			AppModel.settings.addEventListener(InstallEvent.APP_SETTINGS, onAppSettings);
			AppModel.settings.initialize(stage);
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvokeEvent);
		}

		private function onAppSettings(e:InstallEvent):void
		{
			trace("AppMain.onAppSettings(e)");
			stage.nativeWindow.visible = true;
			AppModel.settings.removeEventListener(InstallEvent.APP_SETTINGS, onAppSettings);
			checkExpiredAndUpdates();
		}
		
		private function checkExpiredAndUpdates():void
		{
			trace("AppMain.checkExpiredAndUpdates()");
			if (LicenseManager.checkExpired()){
				stage.dispatchEvent(new InstallEvent(InstallEvent.APP_EXPIRED));
			}	else{
				AppModel.updater.checkForUpdate();				
				AppModel.updater.addEventListener(InstallEvent.APP_UP_TO_DATE, onAppUpToDate);
				AppModel.updater.addEventListener(InstallEvent.UPDATE_FAILURE, onAppUpToDate);
			}
		}

		private function onAppUpToDate(e:InstallEvent):void
		{
			trace("AppMain.onAppUpToDate(e)");
			AppModel.updater.removeEventListener(InstallEvent.APP_UP_TO_DATE, onAppUpToDate);
			AppModel.proxies.config.detectGit();
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_SETTINGS, onGitReady);
		}

		private function onGitReady(e:InstallEvent):void
		{
			trace("AppMain.onGitReady(e)");
			AppModel.database.init();
			AirNativeMenu.initialize(stage);
			AirContextMenu.initialize(stage);
			AppModel.proxies.config.removeEventListener(InstallEvent.GIT_SETTINGS, onGitReady);
			_initialized = true;
		}
		
	}
	
}
