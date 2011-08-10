package model.proxies {

	import model.proxies.local.CheckoutProxy;
	import model.proxies.local.ConfigProxy;
	import model.proxies.local.EditorProxy;
	import model.proxies.local.RepoReader;
	import model.proxies.local.SSHProxy;
	import model.proxies.local.UpdateProxy;
	import model.proxies.remote.LoginProxy;
	import model.proxies.remote.RemoteProxy;
	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 	= new ConfigProxy();
		private static var _reader		:RepoReader 	= new RepoReader();
		private static var _update		:UpdateProxy 	= new UpdateProxy();
		private static var _editor		:EditorProxy 	= new EditorProxy();
		private static var _checkout	:CheckoutProxy 	= new CheckoutProxy();

		private static var _ssh			:SSHProxy 		= new SSHProxy();
		private static var _ghLogin		:LoginProxy 	= new LoginProxy();
		private static var _bsLogin		:LoginProxy 	= new LoginProxy();
		private static var _ghRemote	:RemoteProxy 	= new RemoteProxy();

	// public getters //	

		public function get config():ConfigProxy
		{
			return _config;
		}
		
		public function get editor():EditorProxy
		{
			return _editor;
		}
		
		public function get reader():RepoReader
		{
			return _reader;
		}
		
		public function get update():UpdateProxy
		{
			return _update;
		}		
		
		public function get checkout():CheckoutProxy
		{
			return _checkout;
		}

		public function get ssh():SSHProxy
		{
			return _ssh;
		}
		
	// remote proxies //	

		public function get ghLogin():LoginProxy
		{
			return _ghLogin;
		}
		
		public function get bsLogin():LoginProxy
		{
			return _bsLogin;
		}
		
		public function get ghRemote():RemoteProxy
		{
			return _ghRemote;
		}			

	}
	
}
