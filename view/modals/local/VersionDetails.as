package view.modals.local {

	import events.UIEvent;
	import model.vo.Commit;
	import view.modals.base.ModalWindow;
	import view.ui.Form;
	import flash.events.Event;

	public class VersionDetails extends ModalWindow {

		private static var _form		:Form = new Form(530);
		private static var _view		:VersionDetailsMC = new VersionDetailsMC();
		private static var _fields		:Array = [	{label:'Date', enabled:false}, {label:'Author', enabled:false}, 
													{label:'Commit', enabled:false}, {label:'Details', enabled:false}];

		public function VersionDetails()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 275);
			super.defaultButton = _view.ok_btn;
			super.setTitle(_view, 'Version Details');
			_form.y = 70; _view.addChildAt(_form, 0);
			_form.fields = _fields;
			_view.ok_btn.x = 491;
			_view.ok_btn.y = 240;
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
