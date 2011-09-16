package view.modals.account {

	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.base.ModalWindowBasic;

	public class AccountView extends ModalWindowBasic {

		private static var _proxy			:ApiProxy;
		private static var _account			:HostingAccount;

		public static function set account(a:HostingAccount):void	
		{
			_account = a; 
			if (_account.type == HostingAccount.GITHUB){
				_proxy = Hosts.github.api;
			}	else if (_account.type == HostingAccount.BEANSTALK){
				_proxy = Hosts.beanstalk.api;
			}
		}
		
	// instance getters //	
		
		public function get account():HostingAccount
		{
			return _account;
		}

		public function get proxy():ApiProxy
		{
			return _proxy;
		}

	}
	
}
