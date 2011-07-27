package view.modals.local {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import model.vo.Commit;
	import view.modals.ModalWindow;

	public class CommitDetails extends ModalWindow {

		private static var _view:CommitDetailsMC = new CommitDetailsMC();

		public function CommitDetails()
		{
			addChild(_view);
			super.addCloseButton();
			super.addButtons([_view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onClose);
		}

		public function set commit(cmt:Commit):void
		{
			_view.date_txt.text = cmt.date;
			_view.author_txt.text = cmt.author;
			_view.commit_txt.text = cmt.sha1;
			_view.details_txt.text = cmt.note;
		}
		
		override public function onEnterKey():void { onClose(); }		
		private function onClose(e:MouseEvent = null):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}		
		
	}
	
}
