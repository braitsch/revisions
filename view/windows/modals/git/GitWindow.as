package view.windows.modals.git {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.SystemRules;
	import view.windows.base.ParentWindow;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	public class GitWindow extends ParentWindow {

		private var _view			:*;

		public function GitWindow(v:Sprite)
		{
			_view = v;
			addChild(_view);
			addNoButton('Cancel', 285, 180);
			addOkButton('OK', 415, 180);
			addEventListener(UIEvent.NO_BUTTON, quitApplication);
			addEventListener(UIEvent.ENTER_KEY, installAndUpdate);
		}
		
		protected function attachBadge(bmd:BitmapData):void
		{
			var b:Bitmap = new Bitmap(bmd);
				b.x = 3; b.y = -1;	
			_view.addChild(b);					
		}
		
		protected function checkForPackageInstaller():String
		{
			var n:String = AppModel.proxies.config.gitInstall;
			if (n == SystemRules.MACPORTS){
				return 'Macports';
			}	else if (n == SystemRules.HOMEBREW){
				return 'Homebrew';
			}	else{
				return '';
			}
		}
		
		private function installAndUpdate(e:Event):void
		{
			disableButtons();
			_view.textArea.message_txt.text = getInstallMessage();
			if (checkForPackageInstaller() == ''){
				AppModel.proxies.config.installGit();
			}	else{
				AppModel.proxies.config.updatePackageManager();
			}
			AppModel.engine.addEventListener(AppEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
		}
		
		private function getInstallMessage():String
		{
			var m:String = '';
			if (checkForPackageInstaller()){
				m+='Attemping to upgrade via your package installer.\n';
				m+='This could take a few minutes, please be patient...';
			}	else{
			var v:String = AppModel.proxies.config.gitVersion ? 'Updating' : 'Installing';
				m = v+' Git - This will take a few seconds..';
			}
			return m;			
		}

		private function onInstallComplete(e:AppEvent):void 
		{
		// read and update the gui with newly installed git version //	
			AppModel.proxies.config.detectGit();			
			AppModel.engine.removeEventListener(AppEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
		private function disableButtons():void
		{
			super.okButton.enabled = false;
			super.noButton.enabled = false;
			removeEventListener(UIEvent.ENTER_KEY, installAndUpdate);
			removeEventListener(UIEvent.NO_BUTTON, quitApplication);
		}
		
		private function quitApplication(e:UIEvent):void 
		{
			NativeApplication.nativeApplication.exit();
		}			
		
	}
	
}
