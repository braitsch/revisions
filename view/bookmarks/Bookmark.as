package view.bookmarks {
	import events.RepositoryEvent;

	import utils.StringUtils;

	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	public class Bookmark extends EventDispatcher {

	// branch constants //
		public static const DETACH	:String = 'detach';

		private var _label			:String;
		private var _local			:String;
		private var _active			:Boolean;
		private var _remote			:String;
		
		private var _branch			:Branch;
		private var _detach			:Branch = new Branch(DETACH);
		private var _branches		:Array = [];
		private var _stash			:Array = [];
		private var _file			:File;
		private var _initialized	:Boolean = false;

		public function Bookmark($label:String, $local:String, $active:Boolean, $remote:String = '')
		{
			_label = $label;
			_local = $local;
			_active = $active;
			_remote = $remote;
			_file = new File('file://' + $local);			
		}

		public function get label():String
		{
			return _label;
		}
		
		public function set label(s:String):void
		{
			_label = s;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_EDITED));		}

		public function get local():String
		{
			return _local;
		}
		
		public function get remote():String
		{
			return _remote;
		}

		public function set remote(s:String):void
		{
			_remote = s;
		}	
		
		public function get file():File
		{
			return _file;
		}		
		
		public function get active():Boolean
		{
			return _active;
		}	
		
		public function set active(b:Boolean):void
		{
			_active = b;
		}		
		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		public function set initialized(n:Boolean):void
		{
			_initialized = n;
		}			
		
	// branches //	
				
		public function get branch():Branch
		{
			return _branch;
		}
		
		public function set branch(b:Branch):void
		{
			_branch = b;
			dispatchEvent(new RepositoryEvent(RepositoryEvent.BRANCH_SET));
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
				_initialized = false;
				_branch = new Branch('master');
				_branches.push(_branch);
			}	else{				_initialized = true;
				for (var i:int = 0; i < a.length; i++) {
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
			return _branch != null;				
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
				trace('xxxxxx _stash', i, ' ='+_stash[i]+'=');
			}
		}
		
	}
	
}
