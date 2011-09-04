package view.modals.bkmk {

	import model.vo.Bookmark;
	import view.modals.base.ModalWindowBasic;
	import flash.display.Sprite;

	public class BookmarkAccounts extends ModalWindowBasic {

		private static var _view		:BookmarkAccountsMC = new BookmarkAccountsMC();
		private static var _bookmark	:Bookmark;
		private static var _remotes		:Sprite = new Sprite();

		public function BookmarkAccounts()
		{
			addChild(_view); 
			addChild(_remotes);
			super.setHeading(_view, 'This bookmark is linked to the following accounts: (features coming soon)');
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			attachRemotes();
		}

		private function attachRemotes():void
		{
			while(_remotes.numChildren) _remotes.removeChildAt(0);
			for (var i:int = 0; i < _bookmark.remotes.length; i++) {
				var ri:RemoteItem = new RemoteItem(_bookmark.remotes[i]);
					ri.y = 44 * i;
				_remotes.addChild(ri);
			}
			_remotes.x = 10; _remotes.y = 100;
		}
		
	}
	
}
