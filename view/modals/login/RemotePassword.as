package view.modals.login {

	import events.UIEvent;
	import model.proxies.remote.base.GitProxy;
	import flash.events.MouseEvent;

	public class RemotePassword extends BaseNameAndPass {

		private static var _view	:RemotePasswordMC = new RemotePasswordMC();
		private static var _target	:GitProxy;

		public function RemotePassword()
		{
			super(_view);
			super.setTitle(_view, 'Credentials');
			super.drawBackground(550, 240);
			super.addButtons([_view.skip_btn]);
			super.defaultButton = _view.ok_btn;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.skip_btn.addEventListener(MouseEvent.CLICK, onSkipButton);
		}
		
		public function set target(gp:GitProxy):void
		{
			_target = gp;
		}
		
		public function set account(s:String):void
		{
			_view.name_txt.text = s;
		}

		public function set message(s:String):void
		{
			super.setHeading(_view, s);
		}
		
		override public function onEnterKey():void { onOkButton(); }
		private function onOkButton(e:MouseEvent = null):void
		{
			if (super.validate()) {
				_target.onNewUserCredentials(super.name, super.pass);
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}
		
		private function onSkipButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
