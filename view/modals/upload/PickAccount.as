package view.modals.upload {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.login.AccountLogin;
	import view.ui.DrawButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class PickAccount extends WizardWindow {

		private static var _page		:Sprite;
		private static var _pick		:Sprite;
		private static var _login		:AccountLogin;
		private static var _service		:String;
		
		private static var _thisAcct	:DrawButton = new DrawButton(250, 36, 'Link To This Account', 12);
		private static var _diffAcct	:DrawButton = new DrawButton(250, 36, 'Link To A Different Account', 12);		

		public function PickAccount()
		{
			setButtons();			
			super.addHeading();
			super.addBackButton();
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
		
		private function setButtons():void
		{
			_pick = new Sprite();
			_thisAcct.x = _diffAcct.x = 150;
			_thisAcct.y = 110; _diffAcct.y = 170;
			_pick.addChild(_thisAcct); _pick.addChild(_diffAcct);
			addEventListener(MouseEvent.CLICK, onButtonClick);
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
		
		private function onButtonClick(e:MouseEvent):void
		{
			if (e.target == _diffAcct){
				showLoginWindow();
			}	else if (e.target == _thisAcct){
				super.dispatchNext();
			}
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
