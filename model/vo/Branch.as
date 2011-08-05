package model.vo {

	import model.proxies.StatusProxy;
	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		public static const	DETACH	:String = '(no branch)';
		
		private var _name			:String;
		private var _history		:Vector.<Commit>;
		private var _status			:Array = [[], [], [], []];
		private var _lastCommit		:Commit;
		private var _totalCommits	:uint = 0;

		public function Branch(n:String) 
		{
			_name = n;
		}
		
		public function get name():String { return _name; }
		public function set status(a:Array):void {  _status = a; }
		
		public function set history(v:Vector.<Commit>):void { _history = v; }
		public function get history():Vector.<Commit> { return _history; }
		
		public function get lastCommit():Commit { return _lastCommit; }
		public function get totalCommits():uint { return _totalCommits; }
				
		
		public function set modified(b:Boolean):void
		{
			if (b == false){
				_status[StatusProxy.M] = [];
				_status[StatusProxy.U] = [];
			}
		}
		
		public function get modified():Boolean
		{
			return (_status[StatusProxy.M].length || _status[StatusProxy.U].length);
		}
		
		public function setSummary(lc:Commit, tc:uint, mod:Array):void
		{
 			_lastCommit = lc;
			_totalCommits = tc;
			_status[StatusProxy.M] = mod;
		}

	}
	
}
