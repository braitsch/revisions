package view.windows.modals.git {

	import events.AppEvent;
	import events.UIEvent;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import system.SystemRules;
	import view.windows.base.ParentWindow;

	public class GitWindow extends ParentWindow {

		private var _view			:*;

		public function GitWindow(v:Sprite)
		{
			_view = v;
			addChild(_view);
			super.defaultButton = _view.ok_btn;
			super.addButtons([_view.cancel_btn]);
			addEventListener(UIEvent.ENTER_KEY, installAndUpdate);
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
			removeEventListener(UIEvent.ENTER_KEY, installAndUpdate);
			_view.cancel_btn.removeEventListener(MouseEvent.CLICK, quitApplication);
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
			AppModel.proxies.config.addEventListener(AppEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
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
			super.enableButton(_view.ok_btn, true);
			addEventListener(UIEvent.ENTER_KEY, closeWindow);
			_view.textArea.message_txt.text = "You're All Set - ";
			_view.textArea.message_txt.text+= AppModel.proxies.config.gitVersion ? 'Update' : 'Install';
			_view.textArea.message_txt.text+= ' Complete!!';
			AppModel.proxies.config.removeEventListener(AppEvent.GIT_INSTALL_COMPLETE, onInstallComplete);
		// read and update the gui with newly installed git version //	
			AppModel.proxies.config.detectGit();			
		}
		
		private function quitApplication(e:MouseEvent):void 
		{
			NativeApplication.nativeApplication.exit();
		}			
		
		private function closeWindow(e:Event):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}		
		
	}
	
}
