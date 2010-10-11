package view.bookmarks {
	import events.RepositoryEvent;

	import model.AppModel;

	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		private var _name		:String;
		private var _history	:Array;
		private var _modified	:uint;

		public function Branch($n:String) 
		{
			_name = $n;
		}
		
		public function get name():String
		{
			return _name;
		}		
				
		public function set history($a:Array):void
		{
			_history = $a;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_HISTORY));
		}
		
		public function get history():Array
		{
			return _history;
		}
		
		public function set modified($n:uint):void
		{
			_modified = $n;
			if (history==null) {
				AppModel.history.getHistoryOfBranch(this);
			}	else{				dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_MODIFIED));
			}
		}
		
		public function get modified():uint
		{
			return _modified;
		}
		
	}
	
}
