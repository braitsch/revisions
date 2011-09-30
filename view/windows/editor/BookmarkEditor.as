package view.windows.editor {

	import view.windows.base.ParentWindow;

	public class BookmarkEditor extends ParentWindow {

		private static var _general		:BookmarkGeneral = new BookmarkGeneral();
		private static var _accounts	:BookmarkAccounts = new BookmarkAccounts();		

		public function BookmarkEditor()
		{
			super.addCloseButton();
			super.drawBackground(600, 400);
			super.title = 'Bookmark Settings';
			_accounts.y = 130;
			addChild(_general);
			addChild(_accounts);
		}
		
		override public function get height():Number
		{
		// adding the scrolling accts blows out the height ...	
			return 400;
		}
		
	}
	
}
