package view.modals.upload {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.login.AccountLogin;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PickAccount extends WizardWindow {

		private static var _page		:Sprite;
		private static var _choose		:ChooseAccountMC = new ChooseAccountMC();
		private static var _login		:AccountLogin;
		private static var _service		:String;

		public function PickAccount()
		{
			super.addBackButton();
			super.addButtons([_choose.linkThis, _choose.linkDiff]);
			_choose.linkDiff.addEventListener(MouseEvent.CLICK, showLoginWindow);
			_choose.linkThis.addEventListener(MouseEvent.CLICK, super.dispatchNext);
		}

		public function set service(s:String):void { _service = s; }
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_service == HostingAccount.GITHUB){
				Hosts.github.loggedIn ? showChooser() : showLoginWindow(e);
			}	else if (_service == HostingAccount.BEANSTALK){
				Hosts.beanstalk.loggedIn ? showChooser() : showLoginWindow(e);
			}
		}
		
		private function set page(w:Sprite):void
		{
			if (_page) removeChild(_page);
			_page = w; addChild(_page);
			if (_page == _choose){
				super.backBtnX = 484;
			}	else if (_page is AccountLogin){
				super.backBtnX = 380;
			}
		}
		
		private function showChooser():void
		{
			var m:String;
			if (_service == HostingAccount.GITHUB){
				m = 'You are currently logged into GitHub as "'+Hosts.github.loggedIn.acct+'".';
			}	else if (_service == HostingAccount.BEANSTALK){
				m = 'You are currently logged into the Beanstalk account "'+Hosts.beanstalk.loggedIn.acct+'".';
			}
			m+='\nWhat would you like to do?';
			super.setHeading(_choose, m);
			this.page = _choose;
		}
		
		private function showLoginWindow(e:Event):void
		{
			_login = new AccountLogin(_service);
			_login.y = 70;
			_login.baseline = 280;
			_login.heading = 'Please login to your '+_service+' account';	
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, super.dispatchNext);
			this.page = _login;
		}
		
	}
	
}
