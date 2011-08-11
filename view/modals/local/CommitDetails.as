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
			super.drawBackground(550, 260);
			super.defaultButton = _view.ok_btn;
			super.setTitle(_view, 'Version Details');
			_view.form.label1.text = 'Date';
			_view.form.label2.text = 'Author';
			_view.form.label3.text = 'Commit';
			_view.form.label4.text = 'Details';
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
