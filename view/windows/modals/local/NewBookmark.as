package view.windows.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.remote.Hosts;
	import view.btns.ButtonIcon;
	import view.btns.DrawButton;
	import view.btns.FormButton;
	import view.type.TextHeading;
	import view.ui.Form;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Message;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class NewBookmark extends ParentWindow {

		private static var _cloneURL	:String;
		private static var _customURL	:Form = new Form(580);
		
		private static var _tf1			:TextHeading = new TextHeading();
		private static var _tf2			:TextHeading = new TextHeading();
		private static var _tf3			:TextHeading = new TextHeading();
		
		private static var _file		:DrawButton = new DrawButton(250, 36, 'Track A File', 12);
		private static var _folder		:DrawButton = new DrawButton(250, 36, 'Track A Folder', 12);
		private static var _github		:DrawButton = new DrawButton(250, 36, 'Hello', 12);
		private static var _beanstalk	:DrawButton = new DrawButton(250, 36, 'Hello', 12);				
		private static var _customBtn	:FormButton = new FormButton('Download');

		public function NewBookmark()
		{
			setupButtons();
			addTextHeadings();
			super.addCloseButton();
			super.drawBackground(600, 330);
			super.title = 'New Bookmark';
			addCustomURLField();
			addEventListener(UIEvent.ENTER_KEY, onEnterKey);
			addEventListener(MouseEvent.CLICK, onButtonClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}

		private function addTextHeadings():void
		{
			_tf1.text = 'Start working with files on this computer :';
			_tf2.text = 'Download a repository from an online account :';
			_tf3.text = 'Or enter a repository URL to download from :';
			_tf1.y = 70; _tf2.y = 150; _tf3.y = 230;
			addChild(_tf1); addChild(_tf2); addChild(_tf3);
		}

		private function addCustomURLField():void
		{
			_customURL.y = 255;
			_customURL.labelWidth = 45;
			_customURL.fields = [{label:'URL'}];
			_customURL.getInput(0).width = 500;
			_customURL.getInput(0).addEventListener(MouseEvent.CLICK, onTextFieldClick);
			_customBtn.y = _customURL.y + 4; _customBtn.x = 464; 
			_customBtn.addEventListener(MouseEvent.CLICK, onCustomCloneClick);
			addChild(_customURL); addChild(_customBtn);
		}
		private function onTextFieldClick(e:MouseEvent):void 
		{
			if (_customURL.getField(0) == 'git@github.com:user-name/repository-name.git') _customURL.setField(0, '');	
		}

		private function setupButtons():void
		{
			_file.icon = new ButtonIcon(new FileIcon());
			_folder.icon = new ButtonIcon(new FolderIcon());
			_github.icon = new ButtonIcon(new GitHubIcon(), false);
			_beanstalk.icon = new ButtonIcon(new BeanstalkIcon(), false);
			
			_file.y = _folder.y = 95;
			_github.y = _beanstalk.y = 175;
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
			_cloneURL = null;
			_customURL.setField(0, 'git@github.com:user-name/repository-name.git');
			_github.label = Hosts.github.loggedIn ? 'View My GitHub' : 'Login To GitHub';
			_beanstalk.label = Hosts.beanstalk.loggedIn ? 'View My Beanstalk' : 'Login To Beanstalk';
			super.onAddedToStage(e);
		}
		
		private function onEnterKey(e:UIEvent):void
		{
			onCustomCloneClick(e);
		}		

		private function onCustomCloneClick(e:Event):void
		{
			if (!validate()) return;
			_cloneURL = _customURL.getField(0);
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
			AppProxies.clone.clone(_cloneURL, f);
			AppModel.engine.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
		}
		
		private function validate():Boolean
		{
			var url:String = _customURL.getField(0);
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
			AppModel.alert(new Message(m));
		}

	}
	
}
