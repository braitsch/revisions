package view.windows.modals.system {

	import model.AppModel;
	import model.vo.Bookmark;
	import view.ui.ModalCheckbox;
	import flash.events.Event;

	public class Delete extends Alert {

		private var _bookmark	:Bookmark;
		private var _view		:DeleteBookmarkMC = new DeleteBookmarkMC();
		private var _trashGit	:ModalCheckbox = new ModalCheckbox(false);
		private var _trashFiles	:ModalCheckbox = new ModalCheckbox(false);

		public function Delete(b:Bookmark)
		{
			addChild(_view);
			setBookmark(b);
			attachOptions();
			super.drawBackground(550, 230);
			super.setTitle(_view, 'Delete Bookmark');
			super.okButton = _view.delete_btn;
		}				
		private function setBookmark(b:Bookmark):void
		{
			_bookmark = b;
			_trashGit.selected = _trashFiles.selected = false;
			_view.textArea.message_txt.text = 'Are you sure you want to delete the bookmark "'+_bookmark.label+'"?';
		// disable options if the filepath to the bookmark is broken //	
			_trashGit.visible = _trashFiles.visible = _bookmark.exists;
		}
		
		private function attachOptions():void
		{
			_trashFiles.y = 175; 
			_trashFiles.label = 'Also Move Files to Trash';
			_trashGit.y = 195;
			_trashGit.label = 'Destroy History (please note this cannot be undone)';					
			addChild(_trashGit);
			addChild(_trashFiles);
		}
		
		override protected function onOkButton(e:Event):void
		{
			super.onOkButton(e);
			AppModel.engine.deleteBookmark(_bookmark, _trashGit.selected, _trashFiles.selected);
		}
		
	}
	
}
