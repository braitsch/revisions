package model {

	import events.BookmarkEvent;
	import utils.StringUtils;
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	public class Bookmark extends EventDispatcher {

		private var _target				:String;
		private var _label				:String;	
		private var _gitdir				:String;			
		private var _worktree			:String;
		private var _active				:Boolean;
		private var _remote				:String;
		
		private var _branch				:Branch;
		private var _branches			:Array = [];
		private var _stash				:Array = [];
		private var _file				:File;
		private var _icon32				:Bitmap;
		private var _icon128			:Bitmap;

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
			getIcons();
		//	trace('New Bookmark Created :: '+_label, 'gitDir = '+_gitdir); 
		}

		public function get branch():Branch { return _branch; }		
		public function set branch(b:Branch):void { _branch = b; }
		public function get remote():String { return _remote; }
		public function set remote(s:String):void { _remote = s;}
		public function get active():Boolean { return _active; }
		public function set active(b:Boolean):void { _active = b; }

		public function get icon32():Bitmap { return _icon32; }
		public function get icon128():Bitmap { return _icon128; }
		public function get target():String { return _target; }
		public function get file():File { return _file; }
		public function get gitdir():String { return _gitdir;}
		public function get worktree():String { return _worktree; }
		public function get branches():Array { return _branches; }
		
		public function get label():String { return _label; }		
		public function set label(s:String):void
		{
			_label = s;
			dispatchEvent(new BookmarkEvent(BookmarkEvent.EDITED));
		}
		
		public function get stash():Array { return _stash; }
		public function set stash(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				var n:String = a[i].replace(/stash@\{[0-9]*}: WIP on /, '');
				_stash.push(n.substring(0, n.indexOf(':')));	
			}
		}
		
		private function getIcons():void
		{
			var icons:Array = _file.icon.bitmaps;
			for (var i:int = 0; i < icons.length; i++) {
				if (icons[i].width == 32) _icon32 = new Bitmap(icons[i]);
				if (icons[i].width == 128) _icon128 = new Bitmap(icons[i]);
			}
		}		
		
	// branches //	
			
		public function addBranch(b:Branch):void
		{
			_branch = b;
			_branches.push(b);
			sortBranches();
		}

		public function getBranchByName(n:String):Branch 
		{
			for (var i:int = 0;i < _branches.length; i++) if (n == _branches[i].name) break;
			return _branches[i];
		}	
		
		public function attachBranches(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				var s:String = a[i];
					s = StringUtils.trim(s);
				if (s.indexOf('*') == 0){
					s = s.substr(2);
					_branch = new Branch(s);
					_branches.push(_branch);
				}	else{
					_branches.push(new Branch(s));
				}
			}
			sortBranches();
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
