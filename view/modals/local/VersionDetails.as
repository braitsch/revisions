package view.modals.local {

	import events.UIEvent;
	import model.vo.Commit;
	import view.modals.base.ModalWindow;
	import view.ui.Form;
	import flash.events.Event;

	public class VersionDetails extends ModalWindow {

		private static var _form		:Form = new Form(new Form4());
		private static var _view		:VersionDetailsMC = new VersionDetailsMC();

		public function VersionDetails()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 260);
			super.defaultButton = _view.ok_btn;
			super.setTitle(_view, 'Version Details');
			_form.y = 70; _view.addChildAt(_form, 0);
			_form.labels = ['Date', 'Author', 'Commit', 'Details'];
			_form.enabled = [];
			addEventListener(UIEvent.ENTER_KEY, onClose);
		}

		public function set commit(cmt:Commit):void
		{
			_form.setField(0, cmt.date);
			_form.setField(1, cmt.author);
			_form.setField(2, cmt.sha1);
			_form.setField(3, cmt.note);
		}
		
		private function onClose(e:Event):void 
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}		
		
	}
	
}
