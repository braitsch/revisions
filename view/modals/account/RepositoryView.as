package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Repository;
	import view.modals.base.ModalWindowBasic;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class RepositoryView extends ModalWindowBasic {
	
		private var _view			:RepositoryViewMC = new RepositoryViewMC();
		private var _pages			:Vector.<Sprite>; 
		private var _maxPerPage		:uint = 5;
		private var _pageIndex		:uint = 0;
		private var _cloneURL		:String;
		private var _savePath		:String;
		private var _activePage		:Sprite;		

		public function RepositoryView() 
		{
			addChild(_view);
			addEventListener(UIEvent.LOGGED_IN_CLONE, onCloneClick);
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
			AppModel.engine.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);	
		}
		
		public function attachRepositories(m:Vector.<Repository>):void
		{
			resetAccount();
			var k:Array = [];
			var a:Vector.<Repository> = Vector.<Repository>(sortOn(m));
			_pages = new Vector.<Sprite>();
			for (var i:int = 0; i < a.length; i++) {
				k.push(a[i]);
				if (k.length == _maxPerPage) {
					_pages.push(buildPage(k)); k = [];
				}
			}
			if (k.length > 0) _pages.push(buildPage(k));
			onRepositoriesReady();
		}
		
		private function resetAccount():void
		{
			_pageIndex = 0;
			if (_activePage){ removeChild(_activePage); _activePage = null; }
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
		
		private function onRepositoriesReady():void
		{
			if (_pages.length) showPage(0);
			_view.nav.visible = _pages.length > 1;
		}				
		
	}
	
}
