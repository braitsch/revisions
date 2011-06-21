package model.vo {

	import model.proxies.StatusProxy;
	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		public static const	DETACH	:String = '(no branch)';
		
		private var _name			:String;
		private var _history		:Vector.<Commit>;
		private var _status			:Array = [[], [], [], []];
		private var _modified		:uint;
		private var _lastCommit		:Commit;
		private var _totalCommits	:uint = 0;

		public function Branch(n:String) 
		{
			_name = n;
		}
		
		public function get name():String { return _name; }
		
		public function set history(v:Vector.<Commit>):void { _history = v; }
		public function get history():Vector.<Commit> { return _history; }
		
		public function set lastCommit(c:Commit):void { _lastCommit = c; }
		public function get lastCommit():Commit { return _lastCommit; }
		
		public function set totalCommits(n:uint):void { _totalCommits = n; }
		public function get totalCommits():uint { return _totalCommits; }
		
		public function get modified():uint { return _modified; }
//		public function get untracked():uint { return _status[StatusProxy.U].length; }
				
		public function set status(a:Array):void 
		{ 
			_status = a; 
			_modified = _status[StatusProxy.M].length;
		}
		public function set modified(n:uint):void 
		{ 
			_modified = n;
		}
		
		public function addCommit(c:Commit):void
		{
			_lastCommit = c;
			_history.unshift(c);
			_totalCommits += 1;
			_status	= [[], [], [], []];				
		}
	
	}
	
}
