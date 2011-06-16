package view.modals {

	import events.InstallEvent;
	import model.AppModel;
	import system.SystemRules;
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;

	public class WindowInstallGit extends ModalWindow {

		private static var _view		:InstallGitMC = new InstallGitMC();

		public function WindowInstallGit()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn, _view.quit_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onButtonOK);			_view.quit_btn.addEventListener(MouseEvent.CLICK, onButtonQuit);
		}

		public function set version(n:Number):void
		{
			if (n==0){
				_view.message_txt.htmlText = 'To start using GitMe,<br>I need to first install the underlying Git program on this computer.';	
			} else{
				_view.message_txt.htmlText = 'I need to update your Git version of '+n+' to '+SystemRules.MIN_GIT_VERSION+'<br>Is that OK?';
			}
		}
		
	// button clicks //	

		private function onButtonOK(e:MouseEvent):void 
		{
			onInstallStart();
		}
		
		private function onButtonQuit(e:MouseEvent):void 
		{
			NativeApplication.nativeApplication.exit();
		}
		
	// install //	
		
		private function onInstallStart():void
		{
			_view.ok_btn.visible = false;
			_view.quit_btn.visible = false;
			_view.message_txt.text = 'Installing Git - This will take a few seconds..';
		//	AppModel.proxies.install.installGitLocal();
			AppModel.proxies.install.downloadAndInstallGit();
			AppModel.proxies.install.addEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
		}		

		private function onInstallComplete(e:InstallEvent):void 
		{
			_view.ok_btn.visible = true;
			_view.message_txt.text = "You're All Set - Install Complete!!";	
		// read and update the gui with newly installed git version //	
			AppModel.proxies.config.loadGitSettings();
			AppModel.proxies.install.removeEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
		}		
		
	}
	
}
