package view.modals.account {

	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.HostingProvider;
	import model.remote.Hosts;
	import view.modals.base.ModalWindowBasic;

	public class AccountView extends ModalWindowBasic {

		private static var _account			:HostingAccount;
		private static var _service			:HostingProvider;
		private static var _proxy			:ApiProxy;

		public static function set account(a:HostingAccount):void	
		{
			_account = a; 
			if (_account.type == HostingAccount.GITHUB){
				_service = Hosts.github;
			}	else if (_account.type == HostingAccount.BEANSTALK){
				_service = Hosts.beanstalk;
			}
			_proxy = _service.api;
		}
		
	// instance getters //	
		
		public function get account():HostingAccount
		{
			return _account;
		}

		public function get service():HostingProvider
		{
			return _service;
		}

		public function get proxy():ApiProxy
		{
			return _proxy;
		}

	}
	
}
