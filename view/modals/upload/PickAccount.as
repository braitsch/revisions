package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.base.ModalWindowBasic;
	import view.modals.login.AccountLogin;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PickAccount extends ModalWindowBasic {

		private static var _choose		:ChooseAccountMC = new ChooseAccountMC();
		private static var _login		:AccountLogin;
		private static var _service		:String;
		private static var _page		:Sprite;
		private static var _backBtn		:BackButton = new BackButton();

		public function PickAccount()
		{
			addChild(_backBtn);
			super.addButtons([_backBtn, _choose.linkThis, _choose.linkDiff]);
			_backBtn.y = 280 - 35; // 280 window height //
			_backBtn.addEventListener(MouseEvent.CLICK, onBackButton);
			_choose.linkThis.addEventListener(MouseEvent.CLICK, dispatchNext);
			_choose.linkDiff.addEventListener(MouseEvent.CLICK, showLoginWindow);
		}

		public function set service(s:String):void { _service = s; }
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_service == HostingAccount.GITHUB){
				Hosts.github.loggedIn ? showChooser() : showLoginWindow();
			}	else if (_service == HostingAccount.BEANSTALK){
				Hosts.beanstalk.loggedIn ? showChooser() : showLoginWindow();
			}
		}
		
		private function set page(w:Sprite):void
		{
			if (_page) removeChild(_page);
			_page = w; addChild(_page);
			if (_page == _choose){
				_backBtn.x = 484;
			}	else if (_page is AccountLogin){
				_backBtn.x = 380;
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
			this.page = _choose;
			super.setHeading(_choose, m);
		}
		
		private function showLoginWindow(e:MouseEvent = null):void
		{
			_login = new AccountLogin(_service);
			_login.y = 70;
			_login.baseline = 280;
			_login.heading = 'Please login to your '+_service+' account';	
			_login.addEventListener(AppEvent.LOGIN_SUCCESS, dispatchNext);
			this.page = _login;
		}
		
		private function dispatchNext(e:Event):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
		}
		
		private function onBackButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}
		
	}
	
}
