package view.modals.remote {

	import system.StringUtils;
	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.RemoteAccount;
	import model.vo.Bookmark;
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
		private static var _savePath	:String;
		private static var _activePage	:Sprite;

		public function GitHubHome()
		{
			addChild(_view);
			super.addButtons([_view.logOut]);
			_view.badgePage.label_txt.text = 'My Github';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
			addEventListener(UIEvent.LOGGED_IN_CLONE, onCloneClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
			AppModel.engine.addEventListener(AppEvent.REMOTE_READY, onAccountReady);
			AppModel.proxies.ghLogin.addEventListener(AppEvent.LOGOUT_SUCCESS, onLogout);
			AppModel.proxies.ghRemote.addEventListener(AppEvent.REPOSITORY_CREATED, onNewRepo);
		}

		private function onAccountReady(e:AppEvent):void
		{
			_model = e.data as RemoteAccount;
			resetAccount();
			attachAvatar();
			attachRepositories();
			_view.badgeUser.user_txt.text = _model.name ? _model.name : '';
			if (_model.name && _model.location) _view.badgeUser.user_txt.appendText(' - '+_model.location);
		}
		
		private function resetAccount():void
		{
			_pageIndex = 0;
			if (_activePage){ _view.removeChild(_activePage); _activePage = null; }
		}		

		private function attachAvatar():void
		{
			_model.avatar.y = 7;
			_model.avatar.x = -190;
			_view.badgeUser.addChild(_model.avatar);
		}

		private function onNewRepo(e:AppEvent):void
		{
			_model.repositories.push(e.data);
			resetAccount();
			attachRepositories();
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
			_view.logOut.y = _activePage.y + _activePage.height + 30;
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
		
		private function onCloneClick(e:UIEvent):void
		{
			_cloneURL = e.data as String;
			super.browseForDirectory('Select a location to clone to');
		}					
		
		private function onLogOutClick(e:MouseEvent):void
		{
			AppModel.proxies.ghLogin.logout();
		}

		private function onLogout(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}

		private function onBrowserSelection(e:UIEvent):void
		{
			_savePath = File(e.data).nativePath;
			AppModel.proxies.ghRemote.cloneRemoteRepository(_cloneURL, _savePath);
			AppModel.proxies.ghRemote.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchNewBookmark();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.proxies.ghRemote.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
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
		
	}
	
}
