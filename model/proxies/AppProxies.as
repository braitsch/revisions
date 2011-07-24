package model.proxies {

	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 	= new ConfigProxy();
		private static var _branch		:BranchProxy 	= new BranchProxy();
		private static var _status 		:StatusProxy 	= new StatusProxy();
		private static var _history		:HistoryProxy 	= new HistoryProxy();	
		private static var _editor		:EditorProxy 	= new EditorProxy();
		private static var _checkout	:CheckoutProxy 	= new CheckoutProxy();

		private static var _ssh			:SSHProxy 		= new SSHProxy();
		private static var _github		:GithubProxy 	= new GithubProxy();
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

		public function get branch():BranchProxy
		{
			return _branch;
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

		public function get github():GithubProxy
		{
			return _github;
		}

		public function get beanstalk():BeanstalkProxy
		{
			return _beanstalk;
		}

	}
	
}
