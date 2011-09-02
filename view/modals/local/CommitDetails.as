package view.modals.local {

	import events.UIEvent;
	import model.vo.Commit;
	import view.modals.base.ModalWindow;
	import view.ui.Form;
	import flash.events.MouseEvent;

	public class CommitDetails extends ModalWindow {

		private static var _form		:Form = new Form(new Form4());
		private static var _view		:CommitDetailsMC = new CommitDetailsMC();

		public function CommitDetails()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 260);
			super.defaultButton = _view.ok_btn;
			super.setTitle(_view, 'Version Details');
			_form.y = 70; _view.addChildAt(_form, 0);
			_form.labels = ['Date', 'Author', 'Commit', 'Details'];
			_form.deactivateFields(['field1', 'field2', 'field3', 'field4']);
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
