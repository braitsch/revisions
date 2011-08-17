package view.modals.login {

	import events.UIEvent;
	import model.remote.Accounts;
	import model.vo.Remote;
	import system.StringUtils;
	import flash.events.MouseEvent;

	public class RemotePassword extends BaseNameAndPass {

		private static var _view	:RemotePasswordMC = new RemotePasswordMC();
		private static var _remote	:Remote;

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

		public function set remote(r:Remote):void
		{
			_remote = r;
			_view.name_txt.text = _remote.acctName;
			var t:String = StringUtils.capitalize(r.type);
			super.setHeading(_view, 'Attempt to sync failed, please enter the password for the '+t+' account "'+r.acctName+'"');
		}
		
		override public function onEnterKey():void { onOkButton(); }
		private function onOkButton(e:MouseEvent = null):void
		{
			if (super.validate()) {
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));		
				Accounts.github.proxy.repo.attemptManualHttpsSync(super.name, super.pass);
			}
		}
		
		private function onSkipButton(e:MouseEvent):void
		{
			Accounts.github.proxy.repo.skipRemoteSync();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
