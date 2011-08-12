package model.vo {

	import flash.events.EventDispatcher;
	import model.proxies.local.StatusProxy;

	public class Branch extends EventDispatcher{

		public static const	DETACH	:String = '(no branch)';
		
		private var _name			:String;
		private var _history		:Vector.<Commit>;
		private var _status			:Array = [[], [], [], []];
		private var _lastCommit		:Commit;

		public function Branch(n:String) 
		{
			_name = n;
		}
		
		public function set status(a:Array)					:void {  _status = a; }
		public function get name()							:String { return _name; }
		
		public function get history()						:Vector.<Commit> { return _history; }
		
		public function set lastCommit(c:Commit)			:void { _lastCommit = c; }
		public function get lastCommit()					:Commit { return _lastCommit; }
		
		public function get totalCommits()					:uint { return _lastCommit.index; }

		public function set history(v:Vector.<Commit>):void
		{ 
			_history = v;
			_lastCommit = v[v.length -1];
		}
		
		public function set modified(a:Array):void
		{
			_status[StatusProxy.M] = a[0];
			_status[StatusProxy.U] = a[1];
		}
		
		public function get isModified():Boolean
		{
			return (_status[StatusProxy.M].length || _status[StatusProxy.U].length);
		}

	}
	
}
