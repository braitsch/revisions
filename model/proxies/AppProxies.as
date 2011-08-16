package model.proxies {

	import model.proxies.local.CheckoutProxy;
	import model.proxies.local.ConfigProxy;
	import model.proxies.local.EditorProxy;
	import model.proxies.local.InitProxy;
	import model.proxies.local.RepoReader;
	import model.proxies.local.SSHKeyGenerator;
	import model.proxies.local.UpdateProxy;
	import model.proxies.remote.AccountProxy;
	import model.proxies.remote.RepositoryProxy;
	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 	= new ConfigProxy();
		private static var _reader		:RepoReader 	= new RepoReader();
		private static var _update		:UpdateProxy 	= new UpdateProxy();
		private static var _initP		:InitProxy 		= new InitProxy();
		private static var _editor		:EditorProxy	= new EditorProxy();
		private static var _checkout	:CheckoutProxy 	= new CheckoutProxy();
		private static var _sshKeyGen	:SSHKeyGenerator = new SSHKeyGenerator();

		private static var _bsLogin		:AccountProxy 	= new AccountProxy();
		private static var _ghRemote	:RepositoryProxy 	= new RepositoryProxy();

	// public getters //	

		public function get config():ConfigProxy
		{
			return _config;
		}
		
		public function get init():InitProxy
		{
			return _initP;
		}
		
		public function get reader():RepoReader
		{
			return _reader;
		}
		
		public function get update():UpdateProxy
		{
			return _update;
		}

		public function get editor():EditorProxy
		{
			return _editor;
		}				
		
		public function get checkout():CheckoutProxy
		{
			return _checkout;
		}

		public function get sshKeyGen():SSHKeyGenerator
		{
			return _sshKeyGen;
		}
		
	// remote proxies //	

		public function get bsLogin():AccountProxy
		{
			return _bsLogin;
		}
		
		public function get ghRemote():RepositoryProxy
		{
			return _ghRemote;
		}


	}
	
}
