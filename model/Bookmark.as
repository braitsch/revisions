package model {

	import events.BookmarkEvent;
	import utils.StringUtils;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	public class Bookmark extends EventDispatcher {

	// branch constants //
		public static const DETACH		:String = 'detach';

		private var _target				:String;
		private var _label				:String;	
		private var _gitdir				:String;			
		private var _worktree			:String;
		private var _active				:Boolean;
		private var _remote				:String;
		
		private var _branch				:Branch;
		private var _detach				:Branch = new Branch(DETACH);
		private var _branches			:Array = [];
		private var _stash				:Array = [];
		private var _file				:File;

		public function Bookmark(o:Object)
		{
			_label = o.label;
			_target	= o.target;
			_active = o.active;
			_remote = o.remote;
			_file = new File('file://'+_target);
			if (_file.isDirectory){
				_worktree = _gitdir = _target;
			}	else{
				_worktree = _target.substr(0, _target.lastIndexOf('/'));
				_gitdir = File.applicationStorageDirectory.nativePath+'/'+_label.toLowerCase();
			}
			trace('New Bookmark Created :: '+_label, 'gitDir = '+_gitdir); 
		}

//		private function escapeSpaces(s:String):String
//		{
//		//TODO this is right now MAC specific -- need to define global func that is os specific	
//			return s.replace(/\s/g, '\ ');
//		}

		public function get label():String
		{
			return _label;
		}
		
		public function set label(s:String):void
		{
			_label = s;
			dispatchEvent(new BookmarkEvent(BookmarkEvent.EDITED));		}

		public function get remote():String
		{
			return _remote;
		}

		public function set remote(s:String):void
		{
			_remote = s;
		}	
		
		public function get target():String
		{
			return _target;
		}	
		
		public function get file():File
		{
			return _file;
		}
		
		public function get gitdir():String
		{
			return _gitdir;		
		}
		
		public function get worktree():String
		{
			return _worktree;		
		}		
		
		public function get active():Boolean
		{
			return _active;
		}	
		
		public function set active(b:Boolean):void
		{
			_active = b;
		}		
		
		public function get stash():Array
		{
			return _stash;
		}
		
		public function set stash(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				var n:String = a[i].replace(/stash@\{[0-9]*}: WIP on /, '');
				_stash.push(n.substring(0, n.indexOf(':')));	
			}
		}
		
	// branches //	
			
		public function addBranch(b:Branch):void
		{
			_branch = b;
			_branches.push(b);
			sortBranches();
		}
				
		public function get branch():Branch
		{
			return _branch;
		}
		
		public function set branch(b:Branch):void
		{
			_branch = b;
		}
		
		public function get branches():Array
		{
			return _branches;
		}

		public function getBranchByName(n:String):Branch 
		{
			for (var i:int = 0;i < _branches.length; i++) if (n == _branches[i].name) break;
			return _branches[i];
		}	
		
		public function get detach():Branch
		{
			return _detach;
		}
		
		public function attachBranches(a:Array):Boolean
		{
	// new repositories don't return a branch name before first commit //		
			if (a[0] == ''){
				_branch = new Branch('master');
				_branches.push(_branch);
			}	else{				for (var i:int = 0; i < a.length; i++) {
					var s:String = a[i];
					if (s.indexOf('*') == 0){
						s = StringUtils.trim(s.substr(1));
						if (s != '(no branch)') _branch = new Branch(s);
						_branches.push(_branch);
					}	else{
						s = StringUtils.trim(s);
						_branches.push(new Branch(s));
					}
				}
			}
			sortBranches();
			return _branch != null;				
		}
		
		private function sortBranches():void
		{
		// ensure master is always the first in the list //	
			var m:Branch = getBranchByName('master');
			_branches.splice(_branches.indexOf(m), 1);
			_branches.unshift(m);
		}
		
	}
	
}
