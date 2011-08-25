package view.modals.login {

	import model.remote.Hosts;
	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.vo.BookmarkRemote;
	import flash.events.MouseEvent;

	public class PermissionsFailure extends BaseNameAndPass {

		private static var _view		:PermissionsFailureMC = new PermissionsFailureMC();
		private static var _request		:String;
		private static var _acctType	:String;
		private static var _acctName	:String;
		private static var _repoName	:String;

		public function PermissionsFailure()
		{
			super(_view);
			super.setTitle(_view, 'Credentials');
			super.drawBackground(550, 260);
			super.addButtons([_view.cancel_btn]);
			super.defaultButton = _view.ok_btn;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancelButton);
		}
		
		public function set request(u:String):void
		{
			_request = u;
			var o:Object = BookmarkRemote.inspectURL(_request);
			_acctType = o.acctType;
			_acctName = o.acctName;
			_repoName = o.repoName;
			var m:String = 'I\'m sorry, '+_acctType+' denied us access to the account named "'+_acctName+'".\n';
				m+='Please enter your username & password to try again :';
			super.setHeading(_view, m);
		}
		
		override public function onEnterKey():void { onOkButton(); }
		private function onOkButton(e:MouseEvent = null):void
		{
			if (super.validate()) {
				if (_acctType == HostingAccount.GITHUB){
					retryRequestOverHttps();
				}	else if (_acctType == HostingAccount.BEANSTALK){
					addKeyToBeanstalkAcct();
				}
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}

		private function addKeyToBeanstalkAcct():void
		{
			Hosts.beanstalk.key.addKeyToAccount(super.name, super.pass, _acctName);
			Hosts.beanstalk.key.addEventListener(AppEvent.SSH_KEY_READY, onKeyAddedToBeanstalk);
		}

		private function onKeyAddedToBeanstalk(e:AppEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, _request));
		}

		private function retryRequestOverHttps():void
		{
			var s:String = 'https://' + super.name + ':' + super.pass + '@github.com/' + _acctName +'/'+ _repoName;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, s));			
		}
		
		private function onCancelButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
