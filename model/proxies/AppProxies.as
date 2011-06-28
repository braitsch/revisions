package model.proxies {

	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _config		:ConfigProxy 	= new ConfigProxy();
//		private static var _install		:InstallProxy	= new InstallProxy();
		private static var _branch		:BranchProxy 	= new BranchProxy();
		private static var _status 		:StatusProxy 	= new StatusProxy();
		private static var _history		:HistoryProxy 	= new HistoryProxy();	
		private static var _editor		:EditorProxy 	= new EditorProxy();
		private static var _checkout	:CheckoutProxy 	= new CheckoutProxy();

	// public getters //	

		public function get config():ConfigProxy
		{
			return _config;
		}
		
//		public function get install():InstallProxy
//		{
//			return _install;
//		}					
		
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

	}
	
}
