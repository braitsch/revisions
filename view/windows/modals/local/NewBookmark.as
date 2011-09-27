package view.windows.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.remote.Hosts;
	import system.FileUtils;
	import view.ui.DrawButton;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Message;

	public class NewBookmark extends ParentWindow {

		private static var _view		:NewBookmarkMC = new NewBookmarkMC();
		private static var _cloneURL	:String;
		private static var _savePath	:String;
		private static var _allowClone	:Boolean;
		
		private static var _file		:DrawButton = new DrawButton(250, 36, 'Track A File', 12);
		private static var _folder		:DrawButton = new DrawButton(250, 36, 'Track A Folder', 12);
		private static var _github		:DrawButton = new DrawButton(250, 36, 'Hello', 12);
		private static var _beanstalk	:DrawButton = new DrawButton(250, 36, 'Hello', 12);				

		public function NewBookmark()
		{
			addChild(_view);
			setupButtons();
			super.addCloseButton();
			super.drawBackground(600, 330);
			super.title = 'New Bookmark';
			super.addButtons([_view.custom.clone_btn]);
			addEventListener(MouseEvent.CLICK, onButtonClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
			_view.custom.url_txt.getChildAt(1).addEventListener(KeyboardEvent.KEY_UP, onKeyUp);	
		}

		private function setupButtons():void
		{
			_file.addIcon(new FileIcon());
			_folder.addIcon(new FolderIcon());
			_github.addIcon(new GitHub26());
			_beanstalk.addIcon(new Beanstalk26());
			_file.y = _folder.y = 90;
			_github.y = _beanstalk.y = 170;
			_file.x = _github.x = 35;
			_folder.x = _beanstalk.x = 315;
			addChild(_file); addChild(_folder);
			addChild(_github); addChild(_beanstalk);
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch(e.target){
				case _file :
					super.browseForFile('Select a file to track');
				break;	
				case _folder :
					super.browseForDirectory('Select a folder to track');
				break;	
				case _github :
					if (Hosts.github.loggedIn){
						dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
					}	else{
						dispatchEvent(new UIEvent(UIEvent.GITHUB_LOGIN, UIEvent.GITHUB_HOME));
					}
				break;
				case _beanstalk :
					if (Hosts.beanstalk.loggedIn){
						dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
					}	else{
						dispatchEvent(new UIEvent(UIEvent.BEANSTALK_LOGIN, UIEvent.BEANSTALK_HOME));
					}
				break;	
			}
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			_cloneURL = null;
			enableCloneButton(false);
			_github.label = Hosts.github.loggedIn ? 'View My GitHub' : 'Login To GitHub';
			_beanstalk.label = Hosts.beanstalk.loggedIn ? 'View My Beanstalk' : 'Login To Beanstalk';
		}

		private function onKeyUp(e:KeyboardEvent):void
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
				_view.custom.url_txt.text = 'git@github.com:user-name/repository-name.git';
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
			if (_cloneURL != null) {
				onCloneAttempt(e.data as File);
			}	else{
				dispatchEvent(new UIEvent(UIEvent.DRAG_AND_DROP, e.data as File));
			}
		}
		
		private function onCloneAttempt(f:File):void
		{
			if (FileUtils.dirIsEmpty(f) == false){
				dispatchFailure('The target directory you are attempting to clone to must be empty.');
			}	else {
				_savePath = f.nativePath;
				AppModel.proxies.remote.clone(_cloneURL, _savePath);
				AppModel.engine.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);				
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
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
		}

	}
	
}
