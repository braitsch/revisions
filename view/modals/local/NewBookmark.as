package view.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.remote.Hosts;
	import system.FileUtils;
	import view.modals.base.ModalWindow;

	public class NewBookmark extends ModalWindow {

		private static var _view		:NewBookmarkMC = new NewBookmarkMC();
		private static var _cloneURL	:String;
		private static var _savePath	:String;
		private static var _allowClone	:Boolean;

		public function NewBookmark()
		{
			addChild(_view);
			super.addCloseButton(600);
			super.drawBackground(600, 330);
			super.setTitle(_view, 'New Bookmark');
			super.addButtons([_view.trackFile, _view.trackFolder, _view.loginGithub]);			
			super.addButtons([_view.loginBeanstalk, _view.viewGithub, _view.viewBeanstalk, _view.custom.clone_btn]);			
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
			_view.addEventListener(MouseEvent.CLICK, onButtonClick);
			_view.custom.url_txt.getChildAt(1).addEventListener(KeyboardEvent.KEY_UP, onKeyUp);	
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch(e.target){
				case _view.trackFile :
					super.browseForFile('Select a file to track');
				break;	
				case _view.trackFolder :
					super.browseForDirectory('Select a folder to track');
				break;	
				case _view.viewGithub :
					dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
				break;
				case _view.loginGithub :
					dispatchEvent(new UIEvent(UIEvent.GITHUB_LOGIN, UIEvent.GITHUB_HOME));
				break;
				case _view.viewBeanstalk :
					dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
				break;
				case _view.loginBeanstalk :
					dispatchEvent(new UIEvent(UIEvent.BEANSTALK_LOGIN, UIEvent.BEANSTALK_HOME));
				break;
			}
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			_cloneURL = null;
			enableCloneButton(false);
			_view.loginGithub.visible = Hosts.github.loggedIn == false;
		}

		override protected function onKeyUp(e:KeyboardEvent):void
		{
			if (!_allowClone) enableCloneButton(true);
			if (this.stage && e.keyCode == 13 && e.keyCode != 15 && _allowClone) onCloneClick();				
		}
		
		private function onURLTextFieldClick(e:MouseEvent):void
		{
			if (!_allowClone) enableCloneButton(true);
		}
		
		private function enableCloneButton(b:Boolean):void
		{
			if (b){
				_allowClone = true;
				super.enableButton(_view.custom.clone_btn, true);
				_view.custom.url_txt.removeEventListener(MouseEvent.CLICK, onURLTextFieldClick);
				_view.custom.clone_btn.addEventListener(MouseEvent.CLICK, onCloneClick);
			}	else{
				_allowClone = false;
				super.enableButton(_view.custom.clone_btn, false);
				_view.custom.url_txt.text = 'git@braitsch.beanstalkapp.com:/stephen.git';
			//	_view.custom.url_txt.text = 'git@github.com:user-name/repository-name.git';
				_view.custom.url_txt.setSelection(0, _view.custom.url_txt.length);
				_view.custom.url_txt.textFlow.interactionManager.setFocus();			
				_view.custom.url_txt.addEventListener(MouseEvent.CLICK, onURLTextFieldClick);
				_view.custom.clone_btn.removeEventListener(MouseEvent.CLICK, onCloneClick);				
			}
		}
		
		private function onCloneClick(e:MouseEvent = null):void
		{
			if (!validate()) return;
			_cloneURL = _view.custom.url_txt.text;
			super.browseForDirectory('Select a location to clone to');
		}		
		
		private function onBrowserSelection(e:UIEvent):void
		{
			if (FileUtils.dirIsEmpty(e.data as File) == false){
				dispatchFailure('The target directory you are attempting to clone to must be empty.');
			}	else{
				if (_cloneURL == null) {
					dispatchEvent(new UIEvent(UIEvent.DRAG_AND_DROP, e.data as File));
				}	else{
					_savePath = File(e.data).nativePath;
					AppModel.proxies.remote.clone(_cloneURL, _savePath);
					AppModel.engine.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);				
				}				
			}
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
		}
		
		private function validate():Boolean
		{
			var url:String = _view.custom.url_txt.text;
			if (!hasString(url, 'git@') && !hasString(url, 'git://') && !hasString(url, 'https://')){
				dispatchFailure("Invalid URL : URL's should start with 'git@', 'git://', or 'https://'");
				return false;
			}	else if (url.indexOf('.git') != url.length - 4){
				dispatchFailure("Invalid URL : URL's must end with '.git'");
				return false;
			}	else if (!hasString(url, '.com') && !hasString(url, '.org')){
				dispatchFailure("Invalid URL : Please make sure your hostname ends with a valid extension");
				return false;
			}	else if (hasString(url, 'user-name')){
				dispatchFailure("Invalid URL : Please enter a valid target account name");
				return false;				
			}
			return true;
		}
		
		private function hasString(s1:String, s2:String):Boolean { return s1.indexOf(s2) != -1; }		
		
		private function dispatchFailure(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}

	}
	
}
