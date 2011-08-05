package view.modals.bkmk {

	import events.BookmarkEvent;
	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import view.modals.ModalWindowBasic;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkBranches extends ModalWindowBasic {

		private static var _view		:BookmarkBranchesMC = new BookmarkBranchesMC();
		private static var _bookmark	:Bookmark;
		private static var _branch		:Branch;
		private static var _branches	:Sprite = new Sprite();
		
		public function BookmarkBranches()
		{
			addChild(_view);
			addChild(_branches);
			super.drawBackground(550, 273);
			AppModel.proxies.checkout.addEventListener(BookmarkEvent.BRANCH_CHANGED, onBranchChanged);
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
			_branch = _bookmark.branch;
			_branches.x = 10; _branches.y = 90;
			super.drawBackground(550, _branches.y + _branches.height + 20);		
		}
		
		
		private function onBranchClick(e:MouseEvent):void
		{
			if (e.target is BranchItem){
				if (e.target.branch == _branch) return;
				_branch = e.target.branch;
				checkoutBranch();
			}	else if (e.target is BranchItemDelete){
				_branch = e.target.parent.branch;
				dispatchEvent(new UIEvent(UIEvent.DELETE_BRANCH, _branch));
			}
		}
		
		private function checkoutBranch():void
		{
			if (validate()) AppModel.proxies.checkout.changeBranch(_branch.name);
		}

		private function onBranchChanged(e:BookmarkEvent):void
		{
			_bookmark.branch = _branch;
			for (var i:int = 0; i < _bookmark.branches.length; i++) {
				var k:BranchItem = _branches.getChildAt(i) as BranchItem;
				k.selected = k.branch == _bookmark.branch;
			}
			trace("BookmarkBranches.onBranchChanged(e) -- now on branch ", _bookmark.branch.name);
		}
		
		private function validate():Boolean
		{
			if (AppModel.branch.modified){
				var m:String = 'Please save your changes before moving to a new branch.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			}	else{
				return true;
			}
		}		

	}
	
}
