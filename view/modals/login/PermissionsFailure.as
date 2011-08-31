package view.modals.login {

	import view.ui.ModalCheckbox;
	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.BookmarkRemote;
	import view.modals.base.ModalWindowForm;

	public class PermissionsFailure extends ModalWindowForm {

		private static var _view		:PermissionsFailureMC = new PermissionsFailureMC();
		private static var _url			:String;
		private static var _acctType	:String;
		private static var _acctName	:String;
		private static var _repoName	:String;
		private static var _check		:ModalCheckbox = new ModalCheckbox(_view.check, true);

		public function PermissionsFailure()
		{
			super(_view);
			super.setTitle(_view, 'Credentials');
			super.drawBackground(550, 260);
			super.addButtons([_view.cancel_btn]);
			super.defaultButton = _view.ok_btn;
			super.labels = ['Username', 'Password'];
			super.inputs = [_view.name_txt, _view.pass_txt];
			_check.label = 'Remember my login for this account';			
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancelButton);
		}
		
		public function set request(u:String):void
		{
			_url = u;
			_acctType = BookmarkRemote.getAccountType(u);
			_acctName = BookmarkRemote.getAccountName(u);
			_repoName = BookmarkRemote.getRepositoryName(u);
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
			var ha:HostingAccount = makeAcctObj(HostingAccount.BEANSTALK);
			Hosts.beanstalk.addKeyToAccount(ha, _check.selected);
			Hosts.beanstalk.key.addEventListener(AppEvent.REMOTE_KEY_READY, onKeyAddedToBeanstalk);
		}

		private function onKeyAddedToBeanstalk(e:AppEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, {u:_url}));
			Hosts.beanstalk.key.removeEventListener(AppEvent.REMOTE_KEY_READY, onKeyAddedToBeanstalk);
		}

		private function retryRequestOverHttps():void
		{
			var ha:HostingAccount = _check.selected ? makeAcctObj(HostingAccount.GITHUB) : null;
			_url = BookmarkRemote.buildHttpsURL(super.fields[0], super.fields[1] , _acctName , _repoName);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, {u:_url, a:ha}));
		}
		
		private function makeAcctObj(t:String):HostingAccount
		{
			return new HostingAccount({type:t, acct:_acctName, user:super.fields[0], pass:super.fields[1]});			
		}
		
		private function onCancelButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, {u:null}));
		}
		
	}
	
}
