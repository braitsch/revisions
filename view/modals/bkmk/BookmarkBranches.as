package view.modals.bkmk {

	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Branch;
	import view.modals.base.ModalWindowBasic;
	import com.greensock.TweenLite;
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
			addEventListener(UIEvent.CHANGE_BRANCH, onChangeBranch);
		//	AppModel.proxies.editor.addEventListener(BookmarkEvent.BRANCH_CHANGED, onBranchChanged);
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
			for (var i:int = 0; i < _branches.numChildren; i++) {
				var b:BranchItem = _branches.getChildAt(i) as BranchItem;
				b.y = 44 * i; b.checkIfActive();
			}
			super.setHeading(_view, 'These are your branches, you are currently on branch "'+_bookmark.branch.name+'"');
		}
		
		private function onChangeBranch(e:UIEvent):void
		{
			TweenLite.to(e.target, .3, {alpha:0, onComplete:collapseLayout, onCompleteParams:[e.target]});
			AppModel.proxies.editor.changeBranch(e.data as Branch);
		}
		
		private function collapseLayout(k:BranchItem):void
		{
			_branches.setChildIndex(k, 0);	
			layoutBranches();
			TweenLite.to(k, .3, {alpha:1, delay:.2});
		}
		
	}
	
}
