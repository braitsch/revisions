package view.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Repository;
	import view.modals.base.ModalWindow;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PermissionsFailure extends ModalWindow {

		private static var _view		:PermissionsFailureMC = new PermissionsFailureMC();
		private static var _url			:String;
		private static var _acctType	:String;
		private static var _acctName	:String;
		private static var _repoName	:String;
		private static var _form		:Form = new Form(new Form2());
		private static var _check		:ModalCheckbox = new ModalCheckbox(true);

		public function PermissionsFailure()
		{
			addChild(_view);
			addChild(_check);
			super.setTitle(_view, 'Credentials');
			super.addCloseButton();
			super.drawBackground(550, 260);
			super.addButtons([_view.cancel_btn]);
			super.defaultButton = _view.ok_btn;
			
			_form.labels = ['Username', 'Password'];
			_form.y = 110; _view.addChildAt(_form, 0);			
			
			_check.y = 210;
			_check.label = 'Remember my login for this account';			
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancelButton);
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
		}
		
		public function set request(u:String):void
		{
			_url = u;
			_acctType = Repository.getAccountType(u);
			_acctName = Repository.getAccountName(u);
			_repoName = Repository.getRepositoryName(u);
			var m:String = 'I\'m sorry, '+_acctType+' denied us access to the account named "'+_acctName+'".\n';
				m+='Please enter your username & password to try again :';
			super.setHeading(_view, m);
		}
		
		private function onOkButton(e:Event):void
		{
			if (_form.validate()) {
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
			_url = Repository.buildHttpsURL(_form.getField(0), _form.getField(1) , _acctName , _repoName);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, {u:_url, a:ha}));
		}
		
		private function makeAcctObj(t:String):HostingAccount
		{
			return new HostingAccount({type:t, acct:_acctName, user:_form.getField(0), pass:_form.getField(1)});			
		}
		
		private function onCancelButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, {u:null}));
		}
		
	}
	
}
