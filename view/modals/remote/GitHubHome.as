package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import view.modals.ModalWindow;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class GitHubHome extends ModalWindow {

		private static var _view		:GitHubMC = new GitHubMC();
		private static var _pages		:Vector.<Sprite>;
		private static var _maxPerPage	:uint = 5;
		private static var _pageIndex	:uint = 0;
		private static var _model		:RemoteAccount;
		private static var _cloneURL	:String;
		private static var _activePage	:Sprite;

		public function GitHubHome()
		{
			addChild(_view);
			super.addButtons([_view.logOut, _view.custom.clone_btn]);
			_view.badgePage.label_txt.text = 'My Github';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
			_view.custom.clone_btn.addEventListener(MouseEvent.CLICK, onCustomClick);			
			addEventListener(UIEvent.LOGGED_IN_CLONE, onCloneClick);		
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
			AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onAccountReady);
		}

		private function onAccountReady(e:AppEvent):void
		{
			_model = AccountManager.github;
			resetAccount();
			attachAvatar();
			attachRepositories();
			if (_model.name) _view.badgeUser.user_txt.text = _model.name;
			if (_model.name && _model.location) _view.badgeUser.user_txt.appendText(' - '+_model.location);
		}
		
		private function resetAccount():void
		{
			_pageIndex = 0;
			_view.badgeUser.user_txt.text = '';
			if (_activePage){
				 _view.removeChild(_activePage); _activePage = null;
			}
		}		

		private function attachAvatar():void
		{
			_model.avatar.y = 7;
			_model.avatar.x = -190;
			_view.badgeUser.addChild(_model.avatar);
		}

		private function attachRepositories():void
		{
			var k:Array = [];
			var a:Array = _model.repositories;
			a.sortOn('name', Array.CASEINSENSITIVE);
			_pages = new <Sprite>[];
			for (var i:int = 0; i < a.length; i++) {
				k.push(a[i]);
				if (k.length == _maxPerPage) {
					_pages.push(buildPage(k)); k = [];
				}
			}
			if (k.length > 0) _pages.push(buildPage(k));
			onRepositoriesReady();
		}
		
		private function buildPage(a:Array):Sprite
		{
			var p:Sprite = new Sprite();
			for (var i:int = 0; i < a.length; i++) {
				var rp:RepositoryItem = new RepositoryItem(a[i]);
				rp.y = 53 * i;
				p.addChild(rp);
			}
			return p;	
		}
		
		private function onRepositoriesReady():void
		{
			showPage(0);
			resetURLField();
			positionURLAndNav();
			super.addCloseButton(590);
			super.drawBackground(590, _view.height + 15);
		}

		private function showPage(n:uint):void
		{
			if (_activePage) _view.removeChild(_activePage);
			_pageIndex = n;
			_activePage = _pages[_pageIndex];
			_activePage.x = 10;
			_activePage.y = 90;
			_view.nav.pageCounter_txt.text = (_pageIndex+1)+' / '+_pages.length;			
			_pageIndex==0 ? enableButton(_view.nav.prev_btn, false) : enableButton(_view.nav.prev_btn, true);
			_pageIndex==_pages.length-1 ? enableButton(_view.nav.next_btn, false) : enableButton(_view.nav.next_btn, true);
			_view.addChild(_activePage);
		}

		private function positionURLAndNav():void
		{
			_view.nav.visible = _pages.length > 1;
			_view.custom.y = _activePage.y + _activePage.height + 10;
			_view.logOut.y = _view.custom.y + 96;
		}		
		
		override protected function enableButton(btn:Sprite, b:Boolean):void
		{
			if (b){
				btn.alpha = 1;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, onNavClick);
			}	else{
				btn.alpha = .5;
				btn.buttonMode = false;
				btn.removeEventListener(MouseEvent.CLICK, onNavClick);				
			}
		}
		
		private function onNavClick(e:MouseEvent):void
		{
			if (e.target.name == 'next_btn'){
				showPage(++_pageIndex);
			}	else if (e.target.name == 'prev_btn'){
				showPage(--_pageIndex);
			}
		}
		
		private function resetURLField():void
		{
			_view.custom.url_txt.addEventListener(MouseEvent.CLICK, onURLTextFieldClick);
			_view.custom.url_txt.text = 'git@github.com:user-name/repository-name.git';
		}

		private function onURLTextFieldClick(e:MouseEvent):void
		{
			_view.custom.url_txt.text = '';	
			_view.custom.url_txt.removeEventListener(MouseEvent.CLICK, onURLTextFieldClick);
		}

		private function onCloneClick(e:UIEvent):void
		{
			_cloneURL = e.data as String;
			showFileBrowser();
		}					
		
		private function onCustomClick(e:MouseEvent):void
		{
			if (!validate()) return;
			_cloneURL = _view.custom.url_txt.text;
			showFileBrowser();
		}
		
		private function onLogOutClick(e:MouseEvent):void
		{
			AppModel.proxies.githubApi.logout();
			AppModel.proxies.githubApi.addEventListener(AppEvent.LOGOUT, onLogout);
		}

		private function validate():Boolean
		{
			var url:String = _view.custom.url_txt.text;
			if (url.indexOf('https://') != -1){
				var m:String = "Cloning over HTTP is not supported, please enter a url that starts with 'git@github.com' or 'git://'";
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			}
			if (url.indexOf('git@github.com') == -1 && url.indexOf('git://') == -1){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, "Invalid URL : URL's should start with 'git@github.com' or 'git://'"));
				return false;				
			}
			return true;
		}

		private function showFileBrowser():void
		{
			super.browseForDirectory('Select a location to clone to');
		}

		private function onBrowserSelection(e:UIEvent):void
		{
			RemoteClone.getFromGitHub(_cloneURL, File(e.data).nativePath);
			AppModel.proxies.githubApi.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}

		private function onCloneComplete(e:AppEvent):void
		{
			resetURLField();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.proxies.githubApi.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}
		
		private function onLogout(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));
		}

	}
	
}
