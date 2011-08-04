package view.modals.bkmk {

	import model.vo.Branch;
	import flash.display.Sprite;

	public class BranchItem extends Sprite {

		private var _branch	:Branch;
		private var _view	:BranchItemMC = new BranchItemMC();

		public function BranchItem(b:Branch)
		{
			addChild(_view);			
			_branch = b;
			_view.name_txt.text = _branch.name;			
		}
		
	}
	
}
