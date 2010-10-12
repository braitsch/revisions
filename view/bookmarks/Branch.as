package view.bookmarks {
	import events.RepositoryEvent;

	import model.AppModel;
	import model.git.RepositoryStatus;

	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		private var _name		:String;
		private var _status		:Array;
		private var _history	:Array;
		private var _getHistory	:Boolean;

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
		
		public function set status(a:Array):void
		{
			_status = a;			if (_history==null || _getHistory==true) getHistory();				
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_STATUS));
		}
		
		public function get status():Array
		{
			return _status;
		}		
		
		public function get modified():uint
		{
			return _status[RepositoryStatus.M].length;
		}
		
	// methods //
	
		public function getHistory():void
		{
			AppModel.history.getHistoryOfBranch(this);		
		}

		public function getStatus():void 
		{
			AppModel.status.getStatusOfBranch(this);				}
		
		public function getStatusAndHistory():void
		{
			_getHistory = true;
			getStatus();
		}
		
	}
	
}
