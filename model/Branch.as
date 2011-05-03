package model {
	import model.proxies.StatusProxy;
	import events.BookmarkEvent;

	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		private var _name		:String;
		private var _history	:Array;
		private var _status		:Array;

		public function Branch(n:String) 
		{
			_name = n;
		}
		
		public function get name():String
		{
			return _name;
		}		
				
		public function set history(a:Array):void
		{
			_history = [];
			for (var i:int = 0; i < a.length; i++) _history.push(a[i].split('##'));
			if (_history[0][1] == '0 seconds ago') _history[0][1] = 'Just Now';	
			dispatchEvent(new BookmarkEvent(BookmarkEvent.BRANCH_HISTORY));
		}
		
		public function get history():Array
		{
			return _history;
		}		
		
		public function set status(a:Array):void
		{
			_status = a;
		}
		
		public function get modified():uint
		{
		//TODO bug here, need to not request modified if branch status has not been requested yet/	
			if (!_status) return 0;
			return _status[StatusProxy.M].length;
		}
		
		public function get untracked():uint
		{
			return _status[StatusProxy.U].length;
		}		
		
	}
	
}
