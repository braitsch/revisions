package view.modals.upload {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.login.AccountLogin;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class PickAccount extends WizardWindow {

		private static var _page		:Sprite;
		private static var _pick		:PickAccountMC = new PickAccountMC();
		private static var _login		:AccountLogin;
		private static var _service		:String;

		public function PickAccount()
		{
			super.addHeading();
			super.addBackButton();
			super.addButtons([_pick.linkThis, _pick.linkDiff]);
			_pick.linkDiff.addEventListener(MouseEvent.CLICK, onLinkDiff);
			_pick.linkThis.addEventListener(MouseEvent.CLICK, onLinkThis);
		}

		public function set service(s:String):void
		{
			_service = s;
			if (s == HostingAccount.GITHUB){
				Hosts.github.loggedIn ? showChooser(Hosts.github.loggedIn) : showLoginWindow();
			}	else if (s == HostingAccount.BEANSTALK){
				Hosts.beanstalk.loggedIn ? showChooser(Hosts.beanstalk.loggedIn) : showLoginWindow();
			}
		}

		private function set page(w:Sprite):void
		{
			if (_page) removeChild(_page);
			_page = w; addChild(_page);
			if (_page == _pick){
				super.backBtnX = 491;
			}	else if (_page is AccountLogin){
				super.backBtnX = 390;
			}
		}
		
		private function onLinkDiff(e:MouseEvent):void
		{
			showLoginWindow();
		}		
		
		private function onLinkThis(e:MouseEvent):void
		{
			super.dispatchNext();
		}		
		
		private function showChooser(a:HostingAccount):void
		{
			super.account = a;
			super.heading = 'You are currently logged into the '+a.type+' account "'+a.acctName+'".\nWhat would you like to do?';
			this.page = _pick;
		}
		
		private function showLoginWindow():void
		{
			_login = new AccountLogin(_service);
			_login.y = 70;
			_login.baseline = 300;
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);
			this.page = _login;
			super.heading =  'Please login to your '+_service+' account';
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			if (_service == HostingAccount.GITHUB){
				super.account = Hosts.github.loggedIn;
			}	else if (_service == HostingAccount.BEANSTALK){
				super.account = Hosts.beanstalk.loggedIn;
			}
			super.dispatchNext();	
		}
		
	}
	
}
