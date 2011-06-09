package model {

	import model.proxies.StatusProxy;
	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		public static const	DETACH	:String = '(no branch)';
		
		private var _name			:String;
		private var _status			:Array = [[], [], [], []];
		private var _history		:Array;

		public function Branch(n:String) 
		{
			_name = n;
		}
		
		public function get name():String { return _name; }
		public function get history():Array { return _history; }
		public function get modified():uint { return _status[StatusProxy.M].length; }
		public function get untracked():uint { return _status[StatusProxy.U].length; }
				
		public function set status(a:Array):void { _status = a; }
		
		public function set history(a:Array):void
		{
			_history = [];
			for (var i:int = 0; i < a.length; i++) _history.push(a[i].split('##'));
			if (_history[0][1] == '0 seconds ago') _history[0][1] = 'Just Now';
		}
		
	}
	
}
