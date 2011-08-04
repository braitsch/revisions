package view.modals.bkmk {

	import model.vo.Bookmark;
	import view.modals.ModalWindowBasic;
	import flash.display.Sprite;

	public class BookmarkBranches extends ModalWindowBasic {

		private static var _view		:BookmarkBranchesMC = new BookmarkBranchesMC();
		private static var _bookmark	:Bookmark;
		private static var _branches	:Sprite = new Sprite();
		
		public function BookmarkBranches()
		{
			addChild(_view);
			addChild(_branches);
			super.drawBackground(550, 273);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			attachBranches();
		}

		private function attachBranches():void
		{
			for (var i:int = 0; i < _bookmark.branches.length; i++) {
				var bi:BranchItem = new BranchItem(_bookmark.branches[i]);
				bi.y = 40*i;
				_branches.addChild(bi);
			}
			_branches.x = 10; _branches.y = 90;
			super.drawBackground(550, _branches.y + _branches.height + 20);				
		}
		
	}
	
}
