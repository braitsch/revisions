package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import view.modals.ModalWindow;
	public class AnonymousClone extends ModalWindow {

		private static var _view		:AnonymousCloneMC = new AnonymousCloneMC();
		private static var _cloneURL	:String;

		public function AnonymousClone()
		{
			addChild(_view);
			super.addCloseButton(540);
			super.drawBackground(540, 196);
			super.addButtons([_view.clone_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.url_txt]));			
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
			RemoteClone.getFromGitHub(_cloneURL, File(e.data).nativePath);			
			AppModel.proxies.githubApi.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
			AppModel.proxies.githubApi.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}	
		
		private function dispatchAlert():void
		{
			var m:String = 'Anonymous cloning is only supported over the git protocol right now. ';
				m+='Please enter a URL that begins with git://';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));				
		}
		
	}
	
}
