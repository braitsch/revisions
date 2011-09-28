package view.windows.modals.login {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Repository;
	import view.type.TextHeading;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import view.windows.base.ParentWindow;
	import flash.events.Event;

	public class PermissionsFailure extends ParentWindow {

		private static var _url			:String;
		private static var _acctType	:String;
		private static var _acctName	:String;
		private static var _repoName	:String;
		private static var _form		:Form = new Form(530);
		private static var _check		:ModalCheckbox = new ModalCheckbox(true);
		private static var _heading		:TextHeading = new TextHeading();	

		public function PermissionsFailure()
		{
			super.title = 'Credentials';
			super.addCloseButton();
			super.drawBackground(550, 260);
		
			_form.fields = [{label:'Username'}, {label:'Password', pass:true}];
			_form.y = 110; 
			addChild(_form);
			
			_check.y = 210;
			_check.label = 'Remember my login for this account';
			addChild(_check);
			addChild(_heading);
			
			addOkButton();
			addNoButton();			
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
			addEventListener(UIEvent.NO_BUTTON, onNoButton);
		}
		
		public function set request(u:String):void
		{
			_url = u;
			_acctType = Repository.getAccountType(u);
			_acctName = Repository.getAccountName(u);
			_repoName = Repository.getRepositoryName(u);
			var m:String = 'I\'m sorry, '+_acctType+' denied us access to the account named "'+_acctName+'".\n';
				m+='Please enter your username & password to try again :';
			_heading.text = m;
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
		
		private function onNoButton(e:UIEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.RETRY_REMOTE_REQUEST, {u:null}));
		}
		
	}
	
}
