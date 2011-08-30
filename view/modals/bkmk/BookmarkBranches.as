package view.modals.bkmk {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import view.modals.base.ModalWindowBasic;

	public class BookmarkBranches extends ModalWindowBasic {

		private static var _view		:BookmarkBranchesMC = new BookmarkBranchesMC();
		private static var _bookmark	:Bookmark;
		private static var _branches	:Sprite = new Sprite();
		
		public function BookmarkBranches()
		{
			addChild(_view);
			addChild(_branches);
			super.drawBackground(550, 273);
			super.setHeading(_view, "These are your branches, aren't they schnazzy?");
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
			for (var i:int = 0; i < _bookmark.branches.length; i++) {
				var br:Branch = _bookmark.branches[i];
				var bi:BranchItem = new BranchItem(br);
					bi.y = 40*i;
					bi.selected = br == _bookmark.branch;
				_branches.addChild(bi);
				_branches.addEventListener(MouseEvent.CLICK, onBranchClick);
			}
			_branches.x = 10; _branches.y = 90;
			super.drawBackground(550, _branches.y + _branches.height + 20);		
		}
		
		private function onBranchClick(e:MouseEvent):void
		{
			if (e.target is BranchItem){
				if (e.target.branch != _bookmark.branch) checkoutBranch(e.target.branch);
			}	else if (e.target is BranchItemDelete){
				dispatchEvent(new UIEvent(UIEvent.DELETE_BRANCH, e.target.parent.branch));
			}
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
				var k:BranchItem = _branches.getChildAt(i) as BranchItem;
				k.selected = k.branch == _bookmark.branch;
			}
			trace("BookmarkBranches.onBranchChanged(e) -- now on branch ", _bookmark.branch.name);
		}
		
		private function validate():Boolean
		{
			if (_bookmark.branch.isModified){
				var m:String = 'Please save your changes before moving to a new branch.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			}	else{
				return true;
			}
		}		

	}
	
}
