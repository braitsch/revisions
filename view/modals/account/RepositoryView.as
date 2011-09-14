package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Repository;
	import view.modals.system.Message;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class RepositoryView extends AccountView {
	
		private var _view			:RepositoryViewMC = new RepositoryViewMC();
		private var _pages			:Vector.<Sprite>; 
		private var _maxPerPage		:uint = 5;
		private var _pageIndex		:uint = 0;
		private var _activePage		:Sprite;
		private var _cloneURL		:String;
		private var _savePath		:String;
		private var _logOut			:LogOutBtn = new LogOutBtn();			

		public function RepositoryView() 
		{
			addChild(_view);
			addLogOut();
			addEventListener(UIEvent.LOGGED_IN_CLONE, onCloneClick);
			addEventListener(UIEvent.GET_COLLABORATORS, onCollabClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
		}
		
		public function reset():void
		{
			resetAccount();
			attachRepositories();
			onRepositoriesReady();
		}
		
		private function resetAccount():void
		{
			_pageIndex = 0;
			if (_activePage){ removeChild(_activePage); _activePage = null; }
		}			
		
		private function attachRepositories():void
		{
			var k:Array = [];
			var a:Vector.<Repository> = Vector.<Repository>(sortOn(super.account.repositories));
			_pages = new Vector.<Sprite>();
			for (var i:int = 0; i < a.length; i++) {
				k.push(a[i]);
				if (k.length == _maxPerPage) {
					_pages.push(buildPage(k)); k = [];
				}
			}
			if (k.length > 0) _pages.push(buildPage(k));
		}
		
		private function onRepositoriesReady():void
		{
			if (_pages.length) showPage(0);
			_view.nav.visible = _pages.length > 1;
		}			
		
		private function sortOn(v:*):Array
		{
			var a:Array = [];
			for (var i:int = 0; i < v.length; i++) a[i] = v[i];
				a.sortOn('repoName', Array.CASEINSENSITIVE);
			return a;
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
		
	// repository page navigation //	
		
		private function showPage(n:uint):void
		{
			if (_activePage) removeChild(_activePage);
			_pageIndex = n;
			_activePage = _pages[_pageIndex];
			_view.nav.pageCounter_txt.text = (_pageIndex+1)+' / '+_pages.length;			
			_pageIndex==0 ? enableNavButton(_view.nav.prev_btn, false) : enableNavButton(_view.nav.prev_btn, true);
			_pageIndex==_pages.length-1 ? enableNavButton(_view.nav.next_btn, false) : enableNavButton(_view.nav.next_btn, true);
			_activePage.y = 22;
			addChild(_activePage);
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
		
	// collaborators //
	
		private function onCollabClick(e:UIEvent):void
		{
			if (super.repository.collaborators.length == 0){
				requestCollaborators();
			}	else{
				dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT, super.repository));
			}
		}

		private function requestCollaborators():void
		{
			super.proxy.getCollaborators(super.repository);
			super.proxy.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorsReceived);
		}
	
		private function onCollaboratorsReceived(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT, super.repository));
			super.proxy.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorsReceived);
		}		
		
	// cloning // 	
		
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
		
	// logout //	
		
		private function addLogOut():void
		{
			_logOut.x = 516; _logOut.y = 312; addChild(_logOut);
			_logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);					
			super.addButtons([_logOut]);
		}
		
		private function onLogOutClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			super.service.logOut();
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('You Have Successfully Logged Out.')));
		}					
		
	}
	
}
