package view.windows.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.type.TextHeading;
	import view.ui.Form;
	import view.windows.base.ParentWindow;
	import flash.events.Event;

	public class PermissionsFailure extends ParentWindow {

		private static var _form		:Form = new Form(530);
		private static var _heading		:TextHeading = new TextHeading();	

		public function PermissionsFailure()
		{
			super.title = 'Credentials';
			super.addCloseButton();
			super.drawBackground(550, 260);
		
			_form.fields = [{label:'Username'}, {label:'Password', pass:true}];
			_form.y = 110; 
			addChild(_form);
			addChild(_heading);
			
			addOkButton();
			addNoButton();			
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
			addEventListener(UIEvent.NO_BUTTON, onNoButton);
		}
		
		public function set request(m:String):void
		{
			_heading.text = m;
		}

		private function onOkButton(e:Event):void
		{
			if (_form.validate()) {
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				AppModel.dispatch(AppEvent.RETRY_REMOTE_REQUEST, {user:_form.getField(0), pass:_form.getField(1)});
			}
		}

		private function onNoButton(e:UIEvent):void
		{
			AppModel.dispatch(AppEvent.RETRY_REMOTE_REQUEST);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
