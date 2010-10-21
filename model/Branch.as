package model {
	import events.RepositoryEvent;

	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		private var _name		:String;
		private var _history	:Array;
		private var _modified	:uint;

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
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_HISTORY));
		}
		
		public function get history():Array
		{
			return _history;
		}		
		
		public function set modified(n:uint):void
		{
			_modified = n;
		}
		
		public function get modified():uint
		{
			return _modified;
		}
		
	}
	
}