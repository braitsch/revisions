package view.modals.bkmk {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindowBasic;
	import flash.display.Sprite;

	public class BookmarkBranches extends ModalWindowBasic {

		private static var _view		:BookmarkBranchesMC = new BookmarkBranchesMC();
		private static var _bookmark	:Bookmark;
		private static var _branches	:Sprite = new Sprite();
		
		public function BookmarkBranches()
		{
			addChild(_view);
			addChild(_branches);
			_branches.x = 10; _branches.y = 100;
			AppModel.proxies.editor.addEventListener(BookmarkEvent.BRANCH_CHANGED, onBranchChanged);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			attachBranches();
		}

		private function attachBranches():void
		{
			while(_branches.numChildren) _branches.removeChildAt(0);
			for (var i:int = 0; i < _bookmark.branches.length; i++) _branches.addChild(new BranchItem(_bookmark.branches[i]));
			layoutBranches();	
		}
		
		private function layoutBranches():void
		{
			for (var i:int = 0; i < _branches.numChildren; i++) _branches.getChildAt(i).y = 44 * i;
			super.setHeading(_view, 'These are your branches, you are currently on branch "'+_bookmark.branch.name+'"');
		}
		
		private function onBranchChanged(e:BookmarkEvent):void
		{
			layoutBranches();
		}
		
	}
	
}
