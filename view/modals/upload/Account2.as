package view.modals.upload {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.base.ModalWindowBasic;
	import flash.events.MouseEvent;

	public class Account2 extends ModalWindowBasic {

		private static var _choose		:ChooseAccount = new ChooseAccount();
		private static var _login		:LoginToAccount = new LoginToAccount();
		private static var _service		:String;
		private static var _page		:ModalWindowBasic;
		private static var _backBtn		:BackButton = new BackButton();

		public function Account2()
		{
			addChild(_backBtn);
			super.addButtons([_backBtn]);
			_backBtn.x = 475; _backBtn.y = 260; 
			_choose.addEventListener(MouseEvent.CLICK, onChooseClick);
			_backBtn.addEventListener(MouseEvent.CLICK, onBackButton);
		}

		public function set service(s:String):void
		{
			_service = s;
			if (s == HostingAccount.GITHUB){
				onGitHub();
			}	else if (s == HostingAccount.BEANSTALK){
				onBeanstalk();
			}
		}
		
		private function onChooseClick(e:MouseEvent):void
		{
			if (e.target.name == 'linkDiff'){
				this.page = _login;
				_login.service = _service;
			}	else if (e.target.name == 'linkThis'){
				dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
			}
		}
		
		private function onGitHub():void
		{
			if (Hosts.github.loggedIn){	
				_choose.service = _service;
				this.page = _choose;
			}	else{
				_login.service = _service;
				this.page = _login;
			}
		}
		
		private function onBeanstalk():void
		{
			if (Hosts.beanstalk.loggedIn){	
				_choose.service = _service;
				this.page = _choose;
			}	else{
				_login.service = _service;
				this.page = _login;
			}
		}
		
		private function set page(m:ModalWindowBasic):void
		{
			if (_page) removeChild(_page);
			_page = m; addChild(_page);
		}
		
		private function onBackButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}		
		
	}
	
}
