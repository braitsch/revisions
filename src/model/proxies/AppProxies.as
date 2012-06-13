package model.proxies {

	import model.proxies.local.BkmkCreator;
	import model.proxies.local.BkmkEditor;
	import model.proxies.local.BkmkReader;
	import model.proxies.local.ConfigProxy;
	import model.proxies.local.MergeProxy;
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
		private static var _merge		:MergeProxy			= new MergeProxy();
		private static var _sshKeyGen	:SSHKeyGenerator 	= new SSHKeyGenerator();

	// public getters //	

		static public function get config():ConfigProxy
		{
			return _config;
		}
		
		static public function get creator():BkmkCreator
		{
			return _creator;
		}
		
		static public function get reader():BkmkReader
		{
			return _reader;
		}
		
		static public function get editor():BkmkEditor
		{
			return _editor;
		}
		
		static public function get status():StatusManager
		{
			return _status;
		}
		
		static public function get sshKeyGen():SSHKeyGenerator
		{
			return _sshKeyGen;
		}

		static public function get clone():CloneProxy
		{
			return _clone;
		}

		static public function get sync():SyncProxy
		{
			return _sync;
		}

		static public function get merge():MergeProxy
		{
			return _merge;
		}		
		
	}
	
}
