package model.proxies {

	import model.proxies.local.BkmkCreator;
	import model.proxies.local.BkmkEditor;
	import model.proxies.local.BkmkReader;
	import model.proxies.local.ConfigProxy;
	import model.proxies.local.SSHKeyGenerator;
	import model.proxies.remote.repo.CloneProxy;
	import model.proxies.remote.repo.SyncProxy;
	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 		= new ConfigProxy();
		private static var _creator		:BkmkCreator 		= new BkmkCreator();
		private static var _reader		:BkmkReader 		= new BkmkReader();
		private static var _editor		:BkmkEditor 		= new BkmkEditor();
		private static var _status		:StatusManager 		= new StatusManager();
		private static var _clone		:CloneProxy 		= new CloneProxy();		
		private static var _sync		:SyncProxy 			= new SyncProxy();
		private static var _sshKeyGen	:SSHKeyGenerator 	= new SSHKeyGenerator();

	// public getters //	

		public function get config():ConfigProxy
		{
			return _config;
		}
		
		public function get creator():BkmkCreator
		{
			return _creator;
		}
		
		public function get reader():BkmkReader
		{
			return _reader;
		}
		
		public function get editor():BkmkEditor
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

		public function get clone():CloneProxy
		{
			return _clone;
		}

		public function get sync():SyncProxy
		{
			return _sync;
		}		
		
	}
	
}
