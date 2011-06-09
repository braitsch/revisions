package view.modals {

	import events.UIEvent;
	import model.AppModel;
	import model.Bookmark;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class DeleteBookmark extends ModalWindow {

		private static var _check1		:Sprite;
		private static var _check2		:Sprite;
		private static var _view		:DeleteBookmarkMC = new DeleteBookmarkMC();
		private static var _bookmark	:Bookmark;

		public function DeleteBookmark()
		{
			addChild(_view);
			_check1 = _view.check1.cross;
			_check2 = _view.check2.cross;
			super.addButtons([_view.delete_btn]);
			super.addCheckboxes([_view.check1, _view.check2]);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}				
		public function set bookmark($b:Bookmark):void
		{
			_bookmark = $b;
			_view.message_txt.text = 'Are you sure you want to deal the bookmark "'+_bookmark.label+'"?';
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			switch(e.target.name){
				case 'check1' : _check1.visible = !_check1.visible;	break;
				case 'check2' : _check2.visible = !_check2.visible;	break;
				case 'delete_btn' : 
					AppModel.engine.deleteBookmark(_bookmark, {trash:_check1.visible, killGit:_check2.visible});			
					dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
				break;
			}
		}
		
	}
	
}
