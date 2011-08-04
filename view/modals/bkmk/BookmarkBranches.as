package view.modals.bkmk {

	import model.vo.Bookmark;
	import view.modals.ModalWindowBasic;

	public class BookmarkBranches extends ModalWindowBasic {

		private static var _view		:BookmarkBranchesMC = new BookmarkBranchesMC();
		private static var _bookmark	:Bookmark;
		
		public function BookmarkBranches()
		{
			addChild(_view);
			super.drawBackground(550, 273);
		//	super.addInputs(Vector.<TLFTextField>([_view.name_txt]));
		//	super.addButtons([_view.delete_btn, _view.ok_btn]);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
		}			
		
	}
	
}
