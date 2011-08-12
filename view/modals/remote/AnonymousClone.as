package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import view.modals.ModalWindow;
	import flash.events.MouseEvent;
	public class AnonymousClone extends ModalWindow {

		private static var _view		:AnonymousCloneMC = new AnonymousCloneMC();
		private static var _cloneURL	:String;

		public function AnonymousClone()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 200);
			super.defaultButton = _view.clone_btn;
			super.addInputs(Vector.<TLFTextField>([_view.url_txt]));
			super.setTitle(_view, 'Clone Repository');
			super.setHeading(_view, "Please enter the URL of the repository you'd like to clone.");	
			_view.form.label1.text = 'Repository';					
			_view.clone_btn.addEventListener(MouseEvent.CLICK, onCloneClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}

		private function onCloneClick(e:MouseEvent):void
		{
			if (_view.url_txt.text.indexOf('git://') == -1){
				dispatchAlert();
			}	else{
				_cloneURL = _view.url_txt.text;
				super.browseForDirectory('Select a location to clone to');
			}
		}
		
		private function onBrowserSelection(e:UIEvent):void
		{
		//	RemoteClone.getFromGitHub(_cloneURL, File(e.data).nativePath);			
			AppModel.proxies.ghLogin.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
			AppModel.proxies.ghLogin.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}	
		
		private function dispatchAlert():void
		{
			var m:String = 'Anonymous cloning is only supported over the git protocol right now. ';
				m+='Please enter a URL that begins with git://';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));				
		}
		
	}
	
}
