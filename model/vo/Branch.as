package model.vo {

	import flash.events.EventDispatcher;

	public class Branch extends EventDispatcher{

		private var _name			:String;
		private var _history		:Vector.<Commit>;
		private var _modified		:Array = [];
		private var _untracked		:Array = [];
		private var _lastCommit		:Commit;
		private var _remoteStatus	:Number; // ahead or behind remote tracking branch //

		public function Branch(n:String)  
		{
			_name = n;
		}
		
		public function set name(s:String):void 			{	_name = s;				}
		public function get name():String 					{ return _name; 			}
		
		public function get history():Vector.<Commit> 		{ return _history; 			}
		
		public function set lastCommit(c:Commit):void 		{ _lastCommit = c; 			}
		public function get lastCommit():Commit 			{ return _lastCommit; 		}
		public function get totalCommits():uint 			{ return _lastCommit.index; }
		public function set remoteStatus(n:Number):void		{ _remoteStatus = n;
			trace('_remoteStatus: ' + (_remoteStatus));
		}
		public function get remoteStatus():Number 			{ return _remoteStatus;		}
	
		public function set history(v:Vector.<Commit>):void
		{ 
			_history = v;
		}
		
		public function set modified(a:Array):void
		{
			_modified = a;
		}
		
		public function set untracked(a:Array):void
		{
			_untracked = a;
		}
		
		public function get isModified():Boolean
		{
			return (_modified.length > 0 || _untracked.length > 0);
		}

	}
	
}
