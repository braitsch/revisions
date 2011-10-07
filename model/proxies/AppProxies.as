package model.proxies {

	import model.proxies.local.ConfigProxy;
	import model.proxies.local.RepoCreator;
	import model.proxies.local.RepoEditor;
	import model.proxies.local.RepoReader;
	import model.proxies.local.SSHKeyGenerator;
	import model.proxies.remote.repo.CloneProxy;
	import model.proxies.remote.repo.SyncProxy;
	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 		= new ConfigProxy();
		private static var _creator		:RepoCreator 		= new RepoCreator();
		private static var _reader		:RepoReader 		= new RepoReader();
		private static var _editor		:RepoEditor 		= new RepoEditor();
		private static var _status		:StatusManager 		= new StatusManager();
		private static var _sync		:SyncProxy 			= new SyncProxy();
		private static var _clone		:CloneProxy 		= new CloneProxy();		
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
		
		public function get status():StatusManager
		{
			return _status;
		}
		
		public function get sshKeyGen():SSHKeyGenerator
		{
			return _sshKeyGen;
		}

		public function get sync():SyncProxy
		{
			return _sync;
		}

		public function get clone():CloneProxy
		{
			return _clone;
		}
		
	}
	
}
