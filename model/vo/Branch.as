package model.vo {

	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		private var _name			:String;
		private var _history		:Vector.<Commit>;
		private var _modified		:Array = [];
		private var _untracked		:Array = [];
		private var _remoteStatus	:int; // ahead or behind remote tracking branch //

		public function Branch(n:String)  
		{
			_name = n;
		}
		
		public function set name(s:String):void 			{	_name = s;				}
		public function get name():String 					{ return _name; 			}
		
		
		public function set remoteStatus(n:int):void		{ _remoteStatus = n;		}
		public function get remoteStatus():int 				{ return _remoteStatus;		}
	
		
		public function set modified(a:Array):void
		{
			_modified = a;
		}
		
		public function set untracked(a:Array):void
		{
			_untracked = a;
		}
		
		public function set history(v:Vector.<Commit>):void 
		{ 
			if (_history == null) {
				_history = v;
			}	else if (v.length > _history.length){
				_history = v;
			}
		}
		
		public function get history():Vector.<Commit>
		{ 
			return _history; 			
		}
		
		public function get isModified():Boolean
		{
			return (_modified.length > 0 || _untracked.length > 0);
		}
		
		public function get lastCommit():Commit 			
		{ 
			return _history[_history.length - 1]; 		
		}
		
		public function get totalCommits():uint 			
		{ 
			return _history.length;
		}	

	}
	
}
