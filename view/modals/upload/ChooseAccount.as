package view.modals.upload {

	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.base.ModalWindowBasic;

	public class ChooseAccount extends ModalWindowBasic {

		private static var _view	:ChooseAccountMC = new ChooseAccountMC();

		public function ChooseAccount()
		{
			addChild(_view);
			super.addButtons([_view.linkThis, _view.linkDiff]);
		}
		
		public function set service(s:String):void
		{
			var m:String;
			if (s == HostingAccount.GITHUB){
				m = 'You are currently logged into GitHub as "'+Hosts.github.loggedIn.acct+'".';
			}	else if (s == HostingAccount.BEANSTALK){
				m = 'You are currently logged into the Beanstalk account "'+Hosts.beanstalk.loggedIn.acct+'".';
			}
			m+='\nWhat would you like to do?';
			super.setHeading(_view, m);	
		}	
		
	}
	
}
