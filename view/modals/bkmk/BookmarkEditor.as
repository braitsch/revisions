package view.modals.bkmk {

	import model.vo.Bookmark;
	import view.modals.ModalWindow;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkEditor extends ModalWindow {

		private static var _view		:BookmarkEditorMC = new BookmarkEditorMC();
		private static var _home		:BookmarkHome = new BookmarkHome();
		private static var _branches	:BookmarkBranches = new BookmarkBranches();
		private static var _remotes		:BookmarkRemotes = new BookmarkRemotes();
		private static var _tabLabels	:Array = ['General', 'Branches', 'Remotes'];

		public function BookmarkEditor()
		{
			addChild(_view);
			initializeTabs();
			super.addCloseButton(550);
			_view.pageBadge.label_txt.text = 'Bookmark Editor';
			_view.tabs.addEventListener(MouseEvent.CLICK, onTabSelection);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_home.bookmark = _remotes.bookmark = _branches.bookmark = b;
		}			
		
		private function initializeTabs():void
		{
			var tabs:Array = [_view.tabs.tab1, _view.tabs.tab2, _view.tabs.tab3];
			for (var i:int = 0; i < 3; i++) tabs[i].label_txt.text = _tabLabels[i];
			attachTab(_home);
			super.addButtons(tabs);
		}

		private function onTabSelection(e:MouseEvent):void
		{
			switch(e.target){
				case _view.tabs.tab1 : attachTab(_home); 	break;
				case _view.tabs.tab2 : attachTab(_branches);break;
				case _view.tabs.tab3 : attachTab(_remotes); break;
			}
		}
		
		private function attachTab(s:Sprite):void
		{
			if (numChildren > 1) removeChildAt(0); addChildAt(s, 0);
		}

	}
	
}
