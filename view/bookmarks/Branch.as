package view.bookmarks {
	import events.RepositoryEvent;

	import model.AppModel;

	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		private var _name		:String;
		private var _history	:Array;
		private var _modified	:Boolean;

		public function Branch($n:String) 
		{
			_name = $n;
		}
		
		public function get name():String
		{
			return _name;
		}		
		
		public function get history():Array
		{
			return _history;
		}
		
		public function set history($a:Array):void
		{
			_history = $a;
			trace("Branch.history($a) SET on ", this.name);
					// always force a status refresh when we get a branch's history //	
		//TODO still need a better place to call this..
			AppModel.status.getStatusOfBranch(this);			
		}
		
		public function get modified():Boolean
		{
			return _modified;
		}
		
		public function set modified($m:Boolean):void
		{
			_modified = $m;
			trace("Branch.modified($m) SET on ", this.name);
			if (history!=null) dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_UPDATED));
		}
	}
	
}
