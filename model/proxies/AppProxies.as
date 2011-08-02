package model.proxies {

	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 	= new ConfigProxy();
		private static var _reader		:RepoReader 	= new RepoReader();
		private static var _status 		:StatusProxy 	= new StatusProxy();
		private static var _history		:HistoryProxy 	= new HistoryProxy();	
		private static var _editor		:EditorProxy 	= new EditorProxy();
		private static var _remote		:RemoteProxy 	= new RemoteProxy();
		private static var _checkout	:CheckoutProxy 	= new CheckoutProxy();

		private static var _ssh			:SSHProxy 		= new SSHProxy();
		private static var _githubApi	:GitHubApiProxy = new GitHubApiProxy();
		private static var _githubKey	:GitHubKeyProxy = new GitHubKeyProxy();
		private static var _beanstalk	:BeanstalkProxy = new BeanstalkProxy();

	// public getters //	

		public function get config():ConfigProxy
		{
			return _config;
		}
		
		public function get editor():EditorProxy
		{
			return _editor;
		}
		
		public function get remote():RemoteProxy
		{
			return _remote;
		}		

		public function get reader():RepoReader
		{
			return _reader;
		}
		
		public function get status():StatusProxy
		{
			return _status;
		}
		
		public function get history():HistoryProxy
		{
			return _history;
		}
		
		public function get checkout():CheckoutProxy
		{
			return _checkout;
		}

		public function get ssh():SSHProxy
		{
			return _ssh;
		}

		public function get githubApi():GitHubApiProxy
		{
			return _githubApi;
		}
		
		public function get githubKey():GitHubKeyProxy
		{
			return _githubKey;
		}		

		public function get beanstalk():BeanstalkProxy
		{
			return _beanstalk;
		}

	}
	
}
