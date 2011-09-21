package view.modals.bkmk {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import view.modals.base.ModalWindowBasic;
	import view.modals.system.Message;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkBranches extends ModalWindowBasic {

		private static var _view		:BookmarkBranchesMC = new BookmarkBranchesMC();
		private static var _bookmark	:Bookmark;
		private static var _branches	:Sprite = new Sprite();
		
		public function BookmarkBranches()
		{
			addChild(_view);
			addChild(_branches);
			_branches.x = 10; _branches.y = 100;
			_branches.addEventListener(MouseEvent.CLICK, onBranchClick);
			super.setHeading(_view, "These are your branches");
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
		}
		
		private function onBranchClick(e:MouseEvent):void
		{
//			if (e.target is BranchItem){
//				if (e.target.branch != _bookmark.branch) checkoutBranch(e.target.branch);
//			}	else if (e.target is BranchItemDelete){
//				dispatchEvent(new UIEvent(UIEvent.DELETE_BRANCH, e.target.parent.branch));
//			}
		}
		
		private function checkoutBranch(b:Branch):void
		{
			if (validate()) {
				AppModel.bookmark.branch = b;
				AppModel.proxies.editor.changeBranch(b.name);
			}
		}

		private function onBranchChanged(e:BookmarkEvent):void
		{
			for (var i:int = 0; i < _bookmark.branches.length; i++) {
			//	var k:BranchItem = _branches.getChildAt(i) as BranchItem;
			//	k.selected = k.branch == _bookmark.branch;
			}
			trace("BookmarkBranches.onBranchChanged(e) -- now on branch ", _bookmark.branch.name);
		}
		
		private function validate():Boolean
		{
			if (_bookmark.branch.isModified){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('Please save your changes before moving to a new branch.')));
				return false;
			}	else{
				return true;
			}
		}		

	}
	
}
