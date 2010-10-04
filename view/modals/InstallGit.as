package view.modals {
	import commands.UICommand;

	import events.InstallEvent;

	import model.AppModel;
	import model.SystemRules;
	import model.git.GitInstaller;

	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;

	public class InstallGit extends ModelWindow {

		private static var _view		:InstallGitMC = new InstallGitMC();
		private static var _installer	:GitInstaller = AppModel.core;
		private static var _installed	:Boolean;

		public function InstallGit()
		{
			addChild(_view);
			super.addButtons([_view.ok_btn, _view.quit_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onButtonOK);			_view.quit_btn.addEventListener(MouseEvent.CLICK, onButtonQuit);
			_installer.addEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);				
		}

		public function set version(s:String):void
		{
			_installed = false;
			if (s=='0'){
				_view.message_txt.htmlText = 'To2 start using GitMe,<br>I need to first install the underlying Git program on this computer.';	
			} else{
				_view.message_txt.htmlText = 'I need to update your Git version of '+s+' to '+SystemRules.MIN_GIT_VERSION+'<br>Is that OK?';
			}
		}

		private function onButtonOK(e:MouseEvent):void 
		{
			if (!_installed){
				_view.message_txt.text = 'Installing Git - This will take a few seconds..';
				_view.ok_btn.visible = false;
				_view.quit_btn.visible = false;				AppModel.core.install();
			}	else{	
				dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));
			}
		}
		private function onButtonQuit(e:MouseEvent):void 
		{
			NativeApplication.nativeApplication.exit();
		}

		private function onInstallComplete(e:InstallEvent):void 
		{
			_installed = true;
			_view.ok_btn.visible = true;
			_view.message_txt.text = "You're All Set - Install Complete!!";	
		}		
		
	}
	
}
