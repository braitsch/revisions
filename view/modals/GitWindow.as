package view.modals {

	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.SystemRules;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GitWindow extends ModalWindow {

		private var _view			:*;

		public function GitWindow(v:Sprite)
		{
			_view = v;
			addChild(_view);
			super.addButtons([_view.cancel_btn, _view.ok_btn]);	
			_view.ok_btn.addEventListener(MouseEvent.CLICK, installAndUpdate);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, quitApplication);
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
		
		private function disableButtons():void
		{
			super.enableButton(_view.ok_btn, false);
			super.enableButton(_view.cancel_btn, false);
			_view.ok_btn.removeEventListener(MouseEvent.CLICK, installAndUpdate);
			_view.cancel_btn.removeEventListener(MouseEvent.CLICK, quitApplication);
		}
		
		private function installAndUpdate(e:MouseEvent):void
		{
			disableButtons();
			_view.message_txt.text = getInstallMessage();
			if (checkForPackageInstaller() == ''){
				AppModel.proxies.config.installGit();
			}	else{
				AppModel.proxies.config.updatePackageManager();
			}
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
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

		private function onInstallComplete(e:InstallEvent):void 
		{
			super.enableButton(_view.ok_btn, true);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, closeWindow);
			_view.message_txt.text = "You're All Set - ";
			_view.message_txt.text+= AppModel.proxies.config.gitVersion ? 'Update' : 'Install';
			_view.message_txt.text+= ' Complete!!';
			AppModel.proxies.config.removeEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
		// read and update the gui with newly installed git version //	
			AppModel.proxies.config.detectGit();			
		}
		
		private function quitApplication(e:MouseEvent):void 
		{
			NativeApplication.nativeApplication.exit();
		}			
		
		private function closeWindow(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}		
		
	}
	
}
