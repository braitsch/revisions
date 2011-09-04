package view.modals.bkmk {

	import view.modals.base.ModalWindowBasic;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindow;

	public class BookmarkEditor extends ModalWindow {

		private static var _view		:BookmarkEditorMC = new BookmarkEditorMC();
		private static var _home		:BookmarkHome = new BookmarkHome();
		private static var _branches	:BookmarkBranches = new BookmarkBranches();
		private static var _accounts	:BookmarkAccounts = new BookmarkAccounts();
		private static var _activeTab	:Sprite;
		private static var _activePage	:ModalWindowBasic;
		private static var _tabMap		:Array = [	{tab:_home, 	btn:_view.tabs.tab1, lbl:'General'},
													{tab:_branches, btn:_view.tabs.tab2, lbl:'Branches'},
													{tab:_accounts, btn:_view.tabs.tab3, lbl:'Accounts'}];

		public function BookmarkEditor()
		{
			addChild(_view);
			initializeTabs();
			super.addCloseButton(550);
			super.drawBackground(550, 260);
			super.setTitle(_view, 'Bookmark Editor');
			_view.tabs.addEventListener(MouseEvent.CLICK, onTabSelection);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_home.bookmark = _accounts.bookmark = _branches.bookmark = b;
		}			
		
		private function initializeTabs():void
		{
			for (var i:int = 0; i < 3; i++) {
				_tabMap[i].btn.buttonMode = true;				
				_tabMap[i].btn.mouseChildren = false;
				_tabMap[i].btn.label_txt.text = _tabMap[i].lbl;
				_tabMap[i].btn.addEventListener(MouseEvent.ROLL_OUT, onTabRollOut);
				_tabMap[i].btn.addEventListener(MouseEvent.ROLL_OVER, onTabRollOver);
			}
			tabOut(_tabMap[1].btn);
			tabOut(_tabMap[2].btn);
			setTab(_tabMap[0].btn, _tabMap[0].tab);
		}
		
		private function onTabRollOver(e:MouseEvent):void
		{
			if (e.target != _activeTab) tabOver(e.target as Sprite);
		}
		
		 private function onTabRollOut(e:MouseEvent):void
		{
			if (e.target != _activeTab) tabOut(e.target as Sprite);
		}

		private function onTabSelection(e:MouseEvent):void
		{
			if (e.target == _activeTab) return;
			for (var i:int = 0; i < 3; i++) {
				if (e.target != _tabMap[i].btn) {
					tabOut(_tabMap[i].btn);
				}	else{
					setTab(_tabMap[i].btn, _tabMap[i].tab);
				}
			}				
		}
		
		private function tabOver(s:Sprite):void
		{
			TweenLite.to(s['grey'], .3, {alpha:1});
		}
		
		private function tabOut(s:Sprite):void
		{
			TweenLite.to(s['blue'], .3, {alpha:0});	
			TweenLite.to(s['grey'], .3, {alpha:.5});
		}
		
		private function setTab(btn:Sprite, tab:ModalWindowBasic):void
		{
			if (_activePage) removeChild(_activePage);
			_activeTab = btn; _activePage = tab; addChild(_activePage);	
			TweenLite.to(_activeTab['blue'], .3, {alpha:1});		
		}
		
	}
	
}
