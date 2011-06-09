package view.modals {

	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class DeleteBookmark extends ModalWindow {

		private static var _view		:DeleteBookmarkMC = new DeleteBookmarkMC();
		private static var _trashGit	:Sprite;
		private static var _trashFiles	:Sprite;
		private static var _bookmark	:Bookmark;

		public function DeleteBookmark()
		{
			addChild(_view);
			_trashGit = _view.check2.cross;
			_trashFiles = _view.check1.cross;
			super.addButtons([_view.delete_btn]);
			super.addCheckboxes([_view.check1, _view.check2]);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}				
		public function set bookmark($b:Bookmark):void
		{
			_bookmark = $b;
			_view.check1.cross.visible = _view.check2.cross.visible = false;
			_view.message_txt.text = 'Are you sure you want to deal the bookmark "'+_bookmark.label+'"?';
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			switch(e.target.name){
				case 'check2' : _trashGit.visible = !_trashGit.visible;	break;
				case 'check1' : _trashFiles.visible = !_trashFiles.visible;	break;
				case 'delete_btn' : 
					AppModel.engine.deleteBookmark(_bookmark, _trashGit.visible, _trashFiles.visible);			
					dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				break;
			}
		}
		
	}
	
}
