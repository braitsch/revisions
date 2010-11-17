package model.proxies {
	import model.Bookmark;

	import flash.events.EventDispatcher;

	public class AppProxies extends EventDispatcher {
		
		private static var _install		:InstallProxy	= new InstallProxy();		
		private static var _config		:ConfigProxy 	= new ConfigProxy();
		private static var _branch		:BranchProxy 	= new BranchProxy();
		private static var _status 		:StatusProxy 	= new StatusProxy();
		private static var _history		:HistoryProxy 	= new HistoryProxy();	
		private static var _editor		:EditorProxy 	= new EditorProxy();
		private static var _checkout	:CheckoutProxy 	= new CheckoutProxy();

		public function set bookmark(b:Bookmark):void
		{
			_status.bookmark = _history.bookmark = b;
			_checkout.bookmark = _editor.bookmark = b;			
		}
		
	// public getters //	
		
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
		
		public function get config():ConfigProxy
		{
			return _config;
		}
		
		public function get installer():InstallProxy
		{
			return _install;
		}
		
	}
	
}
