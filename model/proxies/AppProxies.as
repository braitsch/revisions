package model.proxies {

	import flash.events.EventDispatcher;
	import model.proxies.local.ConfigProxy;
	import model.proxies.local.RepoCreator;
	import model.proxies.local.RepoEditor;
	import model.proxies.local.RepoReader;
	import model.proxies.local.SSHKeyGenerator;
	import model.proxies.local.UpdateProxy;
	import model.proxies.remote.repo.RepoRemote;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 		= new ConfigProxy();
		private static var _creator		:RepoCreator 		= new RepoCreator();
		private static var _reader		:RepoReader 		= new RepoReader();
		private static var _editor		:RepoEditor 		= new RepoEditor();
		private static var _remote		:RepoRemote			= new RepoRemote();
		private static var _update		:UpdateProxy 		= new UpdateProxy();
		private static var _sshKeyGen	:SSHKeyGenerator 	= new SSHKeyGenerator();

	// public getters //	

		public function get config():ConfigProxy
		{
			return _config;
		}
		
		public function get creator():RepoCreator
		{
			return _creator;
		}
		
		public function get reader():RepoReader
		{
			return _reader;
		}
		
		public function get editor():RepoEditor
		{
			return _editor;
		}
		
		public function get remote():RepoRemote
		{
			return _remote;
		}				
		
		public function get update():UpdateProxy
		{
			return _update;
		}
		
		public function get sshKeyGen():SSHKeyGenerator
		{
			return _sshKeyGen;
		}
		
	}
	
}
