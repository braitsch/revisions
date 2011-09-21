package view.modals.bkmk {

	import model.vo.Avatar;
	import model.vo.Branch;
	import view.ui.BasicButton;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;

	public class BranchItem extends Sprite {

		private var _view		:BranchItemMC = new BranchItemMC();
		private var _branch		:Branch;

		public function BranchItem(b:Branch)
		{
			_branch = b;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = _branch.name;
			_view.desc_txt.text = _branch.lastCommit.note;
			_view.desc_txt.mouseEnabled = _view.desc_txt.mouseChildren = false;
			new BasicButton(_view.checkout);
			attachAvatar();
			addChild(_view);
		}

		private function attachAvatar():void
		{
			var a:Avatar = new Avatar(_branch.lastCommit.email);
				a.y = a.x = 5; 
			_view.addChild(a);
		}
		
	}
	
}
