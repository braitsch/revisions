package view.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.remote.Account;
	import model.vo.Bookmark;
	import system.StringUtils;
	import view.modals.ModalWindow;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

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
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
					dispatchEvent(new UIEvent(UIEvent.REMOTE_LOGIN, {type:Account.GITHUB, event:UIEvent.GITHUB_HOME}));
				break;	
				case _view.viewBeanstalk :
					dispatchAlert('Beanstalk support is coming very soon.');
				break;	
				case _view.loginBeanstalk :
					dispatchAlert('Beanstalk support is coming very soon.');
				break;					
			}
		}
		
		private function onAddedToStage(e:Event):void
		{
			_cloneURL = null;
			enableCloneButton(false);
			_view.loginGithub.visible = Hosts.github.loggedIn == false;
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			if (!_allowClone) enableCloneButton(true);
			if (this.stage && e.keyCode == 13 && e.keyCode != 15 && _allowClone) onEnterKey();				
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
		
		override public function onEnterKey():void { onCloneClick(); }
		private function onCloneClick(e:MouseEvent = null):void
		{
			if (!validate()) return;
			_cloneURL = _view.custom.url_txt.text;
			super.browseForDirectory('Select a location to clone to');
		}		
		
		private function validate():Boolean
		{
			var url:String = _view.custom.url_txt.text;
			if (url.indexOf('git') == -1 && url.indexOf('https://') == -1){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, "Invalid URL : URL's should start with 'git' or 'https://'"));
				return false;				
			}
			return true;
		}		
		
		private function onBrowserSelection(e:UIEvent):void
		{
			if (_cloneURL == null) {
				dispatchEvent(new UIEvent(UIEvent.DRAG_AND_DROP, e.data as File));
			}	else{
				_savePath = File(e.data).nativePath;
				AppModel.proxies.editor.clone(_cloneURL, _savePath);
				AppModel.proxies.editor.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
			}
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchNewBookmark();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.proxies.editor.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}

		private function dispatchNewBookmark():void
		{
			var n:String = _savePath.substr(_savePath.lastIndexOf('/') + 1);
			var o:Object = {
				label		:	StringUtils.capitalize(n),
				type		: 	Bookmark.FOLDER,
				path		:	_savePath,
				active 		:	1,
				autosave	:	60 
			};	
			AppModel.engine.addBookmark(new Bookmark(o));
		}
		
		private function dispatchAlert(m:String):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
		}	
		
	}
	
}
