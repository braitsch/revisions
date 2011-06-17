package view.bookmarks {
	import flash.display.Sprite;
	import model.vo.Branch;

	public class BranchListItem extends Sprite {

		private var _branch	:Branch;
		private var _view	:BookmarkItemBranchMC = new BookmarkItemBranchMC();

		public function BranchListItem(b:Branch)
		{
			_branch = b;
			_view.mouseEnabled = false;			_view.mouseChildren = false;
			_view.label_txt.autoSize = 'right';
			_view.label_txt.text = _branch.name;
			_view.graphics.beginFill(0xff0000, .2);
			_view.graphics.drawRect(-190, 0, 190, _view.height);
			addChild(_view);
		}
		
		public function get branch():Branch
		{
			return _branch;
		}
		
	}
	
}
