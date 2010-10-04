package view.modals {
	import commands.UICommand;

	import model.AppModel;

	import view.bookmarks.Bookmark;
	import view.ui.SimpleCheckBox;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class RemoveBookmark extends ModelWindow {

		private static var _view		:RemoveBookmarkMC = new RemoveBookmarkMC();
		private static var _check1		:SimpleCheckBox;		private static var _check2		:SimpleCheckBox = new SimpleCheckBox();

		public function RemoveBookmark()
		{
			addChild(_view);
			super.cancel = _view.cancel_btn;	
			super.addInputs(Vector.<TextField>([_view.name_txt, _view.local_txt]));
			super.addButtons([_view.delete_btn, _view.cancel_btn]);
		
			_check1 = new SimpleCheckBox(false, 'Destroy Repository History - WARNING THIS CANNOT BE UNDONE');
			_check1.y = 114;			_check2 = new SimpleCheckBox(false, 'Move Local Files To Trash');			_check2.y = 134;
			_check1.x = _check2.x = 24;
			addChild(_check1);			addChild(_check2);
		
			_view.name_txt.selectable = false;			_view.local_txt.selectable = false;
			_view.delete_btn.addEventListener(MouseEvent.CLICK, onDelete);
		}				
		public function set bookmark($b:Bookmark):void
		{
			_view.name_txt.text = $b.label;
			_view.local_txt.text = $b.local;			
		}
		
		private function onDelete(e:MouseEvent):void 
		{
			var o:Object = {label:_view.name_txt.text, local:_view.local_txt.text, killGit:_check1.selected, trash:_check2.selected};		
			AppModel.editor.deleteRepository(o);			
			AppModel.database.deleteRepository(_view.name_txt.text);			
			dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));			
		}
		
	}
	
}
