package view.modals {

	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.SystemRules;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	public class GitWindow extends ModalWindow {

		private static var _view			:GitWindowMC = new GitWindowMC();

		public function GitWindow()
		{
			addChild(_view);
			super.addButtons([_view.cancel_btn, _view.ok_btn]);
		}
		
		public function promptToInstall():void
		{
			attachBadge(new GitInstallBadge());
			_view.message_txt.text = 'Revisions requires the Git library to run correctly.\n';	
			_view.message_txt.text+= 'It only takes a second to install. Okay if I add that for you?';	
			setButtonsToInstall();
		}
		
		public function promptToUpgrade():void
		{
			attachBadge(new GitUpdateBadge());
			_view.message_txt.text = getUpgradePrompt();	
		}
		
		private function getUpgradePrompt():String
		{
			var m:String;
			var n:String;
			var v:String = AppModel.proxies.config.gitVersion;
			var p:String = AppModel.proxies.config.gitLocation;
			if (p == SystemRules.MACPORTS){
				n = 'Macports'; 
			}	else if (p == SystemRules.HOMEBREW){
				n = 'Homebrew';
			}
			if (n){
				setButtonsToClose();
				m = 'It looks like you installed Git via '+n+' but are running version '+v+'. ';
				m+= 'Please update Git to version '+SystemRules.MIN_GIT_VERSION+' and then restart Revisions.';				
			}	else{
				setButtonsToInstall();
				m = 'I need to update your Git version of '+v+' to '+SystemRules.MIN_GIT_VERSION+'\nIs that OK?';				
			}
			return m;
		}
		
		private function setButtonsToInstall():void
		{
			_view.ok_btn.addEventListener(MouseEvent.CLICK, installAndUpdate);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, quitApplication);			
		}
		
		private function setButtonsToClose():void
		{
			_view.cancel_btn.visible = false;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, quitApplication);
		}
		
		private function attachBadge(bmd:BitmapData):void
		{
			var b:Bitmap = new Bitmap(bmd);
				b.x = 3; b.y = -1;	
			_view.addChild(b);						
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
			_view.message_txt.text = AppModel.proxies.config.gitVersion ? 'Updating' : 'Installing';
			_view.message_txt.text+= ' Git - This will take a few seconds..';
			AppModel.proxies.config.installGit();
			AppModel.proxies.config.addEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
		}		

		private function onInstallComplete(e:InstallEvent):void 
		{
			super.enableButton(_view.ok_btn, true);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, closeWindow);
			_view.message_txt.text = "You're All Set - ";
			_view.message_txt.text+= AppModel.proxies.config.gitVersion ? 'Update' : 'Install';
			_view.message_txt.text+= ' Complete!!';
		// read and update the gui with newly installed git version //	
			AppModel.proxies.config.checkIfGitIsInstalled();
			AppModel.proxies.config.removeEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
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
