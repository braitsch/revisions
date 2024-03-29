package view.windows.modals.local {

	import events.UIEvent;
	import flash.events.Event;
	import model.vo.Commit;
	import view.ui.Form;
	import view.windows.base.ParentWindow;

	public class VersionDetails extends ParentWindow {

		private static var _form		:Form = new Form(530);
		private static var _fields		:Array = [	{label:'Date', enabled:false}, {label:'Author', enabled:false}, 
													{label:'Commit', enabled:false}, {label:'Details', enabled:false}];

		public function VersionDetails()
		{
			super.title = 'Version Details';
			super.addCloseButton();
			super.drawBackground(550, 275);
			addOkButton();
			_form.fields = _fields;
			_form.y = 70; 
			addChild(_form);
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
