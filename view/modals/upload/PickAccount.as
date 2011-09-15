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
		private static var _pick		:PickAccountMC = new PickAccountMC();
		private static var _login		:AccountLogin;

		public function PickAccount()
		{
			super.addHeading();
			super.addBackButton();
			super.addButtons([_pick.linkThis, _pick.linkDiff]);
			_pick.linkDiff.addEventListener(MouseEvent.CLICK, showLoginWindow);
			_pick.linkThis.addEventListener(MouseEvent.CLICK, super.dispatchNext);
		}

		override protected function onAddedToStage(e:Event):void
		{
			if (super.service == HostingAccount.GITHUB){
				Hosts.github.loggedIn ? showChooser() : showLoginWindow(e);
			}	else if (super.service == HostingAccount.BEANSTALK){
				Hosts.beanstalk.loggedIn ? showChooser() : showLoginWindow(e);
			}
		}
		
		private function set page(w:Sprite):void
		{
			if (_page) removeChild(_page);
			_page = w; addChild(_page);
			if (_page == _pick){
				super.backBtnX = 484;
			}	else if (_page is AccountLogin){
				super.backBtnX = 380;
			}
		}
		
		private function showChooser():void
		{
			var m:String;
			if (super.service == HostingAccount.GITHUB){
				m = 'You are currently logged into GitHub as "'+Hosts.github.loggedIn.acct+'".';
			}	else if (super.service == HostingAccount.BEANSTALK){
				m = 'You are currently logged into the Beanstalk account "'+Hosts.beanstalk.loggedIn.acct+'".';
			}
			m+='\nWhat would you like to do?';
			super.heading = m;
			this.page = _pick;
		}
		
		private function showLoginWindow(e:Event):void
		{
			_login = new AccountLogin(super.service);
			_login.y = 70;
			_login.baseline = 280;
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, super.dispatchNext);
			this.page = _login;
			super.heading =  'Please login to your '+super.service+' account';
		}
		
	}
	
}
