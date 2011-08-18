package model.proxies {

	import flash.events.EventDispatcher;
	import model.proxies.local.CheckoutProxy;
	import model.proxies.local.ConfigProxy;
	import model.proxies.local.InitProxy;
	import model.proxies.local.RepoEditor;
	import model.proxies.local.RepoReader;
	import model.proxies.local.SSHKeyGenerator;
	import model.proxies.local.UpdateProxy;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 		= new ConfigProxy();
		private static var _initP		:InitProxy 			= new InitProxy();
		private static var _reader		:RepoReader 		= new RepoReader();
		private static var _editor		:RepoEditor			= new RepoEditor();
		private static var _update		:UpdateProxy 		= new UpdateProxy();
		private static var _checkout	:CheckoutProxy 		= new CheckoutProxy();
		private static var _sshKeyGen	:SSHKeyGenerator 	= new SSHKeyGenerator();

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
		
		public function get editor():RepoEditor
		{
			return _editor;
		}				
		
		public function get update():UpdateProxy
		{
			return _update;
		}
		
		public function get checkout():CheckoutProxy
		{
			return _checkout;
		}

		public function get sshKeyGen():SSHKeyGenerator
		{
			return _sshKeyGen;
		}
		
	}
	
}
