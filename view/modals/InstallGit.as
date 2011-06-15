package view.modals {

	import events.InstallEvent;
	import events.UIEvent;
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.proxies.InstallProxy;
	import system.SystemRules;

	public class InstallGit extends ModalWindow {

		private static var _view		:InstallGitMC = new InstallGitMC();
		private static var _installed	:Boolean;
		private static var _installer	:InstallProxy;		

		public function InstallGit()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn, _view.quit_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onButtonOK);			_view.quit_btn.addEventListener(MouseEvent.CLICK, onButtonQuit);
		}

		public function set version(s:String):void
		{
			_installed = false;
			if (s=='0'){
				_view.message_txt.htmlText = 'To start using GitMe,<br>I need to first install the underlying Git program on this computer.';	
			} else{
				_view.message_txt.htmlText = 'I need to update your Git version of '+s+' to '+SystemRules.MIN_GIT_VERSION+'<br>Is that OK?';
			}
		}
		
	// button clicks //	

		private function onButtonOK(e:MouseEvent):void 
		{
			if (!_installed){
				onInstallStart();
			}	else{	
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
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
			_installer = new InstallProxy();
			_installer.addEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);				
		}		

		private function onInstallComplete(e:InstallEvent):void 
		{
			_installed = true;
			_view.ok_btn.visible = true;
			_view.message_txt.text = "You're All Set - Install Complete!!";	
		// read and update the gui with newly installed git version //	
			AppModel.proxies.config.loadUserSettings();
		}		
		
	}
	
}
