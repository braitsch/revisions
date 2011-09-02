package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.modals.base.ModalWindow;

	public class AccountHome extends ModalWindow {

		private var _view			:*;
		private var _pages			:Vector.<Sprite>;
		private var _maxPerPage		:uint = 5;
		private var _pageIndex		:uint = 0;
		private var _cloneURL		:String;
		private var _savePath		:String;
		private var _activePage		:Sprite;
		private var _model			:HostingAccount;

		public function AccountHome(v:*)
		{
			_view = v;
			addChild(_view);
			super.addButtons([_view.logOut]);
			addEventListener(UIEvent.LOGGED_IN_CLONE, onCloneClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
			AppModel.engine.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
		}

		public function set model(r:HostingAccount):void
		{
			_model = r;
			resetAccount();
			attachAvatar();
			attachRepositories();
			_view.badgeUser.user_txt.text = _model.fullName ? _model.fullName : '';
			if (_model.fullName && _model.location) _view.badgeUser.user_txt.appendText(' - '+_model.location);
		}
		
		public function addRepository(o:Object):void
		{
			_model.repositories.push(o);
			resetAccount();
			attachRepositories();
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
			if (_pages.length) showPage(0);
			positionURLAndNav();
			super.addCloseButton(590);
			super.drawBackground(590, _view.height + 15);
			if (stage) super.resize(stage.stageWidth, stage.stageHeight);
		}

		private function showPage(n:uint):void
		{
			if (_activePage) _view.removeChild(_activePage);
			_pageIndex = n;
			_activePage = _pages[_pageIndex];
			_activePage.x = 10;
			_activePage.y = 90;
			_view.nav.pageCounter_txt.text = (_pageIndex+1)+' / '+_pages.length;			
			_pageIndex==0 ? enableNavButton(_view.nav.prev_btn, false) : enableNavButton(_view.nav.prev_btn, true);
			_pageIndex==_pages.length-1 ? enableNavButton(_view.nav.next_btn, false) : enableNavButton(_view.nav.next_btn, true);
			_view.addChild(_activePage);
		}

		private function positionURLAndNav():void
		{
			_view.nav.visible = _pages.length > 1;
			_view.logOut.y = (_activePage) ? _activePage.y + _activePage.height + 30 : 90;
		}		
		
		private function enableNavButton(btn:Sprite, b:Boolean):void
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
		
		private function onBrowserSelection(e:UIEvent):void
		{
			_savePath = File(e.data).nativePath;
			AppModel.proxies.remote.clone(_cloneURL, _savePath);
			AppModel.engine.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}
		
		protected function onLogOutClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'You Have Successfully Logged Out.'));
		}			

	}
	
}
