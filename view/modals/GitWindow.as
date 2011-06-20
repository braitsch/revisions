package view.modals {

	import events.InstallEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.SystemRules;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class GitWindow extends ModalWindow {

		private static var _view		:GitWindowMC = new GitWindowMC();
		private static var _version		:String;
		private static var _installed	:Boolean = true;

		public function GitWindow()
		{
			addChild(_view);
			super.addButtons([_view.cancel_btn, _view.ok_btn]);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, quitApplication);			_view.ok_btn.addEventListener(MouseEvent.CLICK, installAndUpdate);
		}
		
		public function get installed():Boolean { return _installed; }

		public function set version(n:String):void
		{
			_version = n;
			var b:Bitmap;
			if (n == '0'){
				b = new Bitmap(new GitInstallBadge());
				_view.message_txt.text = 'Revisions requires the Git library to run correctly.\n';	
				_view.message_txt.text+= 'It only takes a second to install. Okay if I add that for you?';	
			}	else{
				b= new Bitmap(new GitUpdateBadge());
				_view.message_txt.text = 'I need to update your Git version of '+n+' to '+SystemRules.MIN_GIT_VERSION+'\nIs that OK?';
			}
			b.x = 3; b.y = -1;
			_view.addChild(b);
			_installed = false;
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
			_view.message_txt.text = _version == '0' ? 'Installing' : 'Updating';
			_view.message_txt.text+= ' Git - This will take a few seconds..';
			AppModel.proxies.install.installGitLocal();
			AppModel.proxies.install.addEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
		}		

		private function onInstallComplete(e:InstallEvent):void 
		{
			_installed = true;			
			super.enableButton(_view.ok_btn, true);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, closeWindow);
			_view.message_txt.text = "You're All Set - ";
			_view.message_txt.text+= _version == '0' ? 'Install' : 'Update';
			_view.message_txt.text+= ' Complete!!';
		// read and update the gui with newly installed git version //	
			AppModel.proxies.config.getGitVersion();
			AppModel.proxies.install.removeEventListener(InstallEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
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
