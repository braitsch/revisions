package view.bookmarks {
	import events.RepositoryEvent;

	import utils.StringUtils;

	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	public class Bookmark extends EventDispatcher {

	// branch constants //
		public static const DETACH	:String = 'detach';

		private var _label			:String;
		private var _local			:String;		private var _remote			:String;
		private var _detach			:Branch = new Branch(DETACH);
		private var _branch			:Branch;
		private var _branches		:Array = [];
		private var _active			:Boolean;
		private var _file			:File;

		public function Bookmark($label:String, $local:String, $remote:String, $active:Boolean)
		{
			_label = $label;
			_local = $local;
			_remote = $remote;
			_active = $active;
			_file = new File('file://' + $local);			
		}

		public function get label():String
		{
			return _label;
		}
		
		public function get local():String
		{
			return _local;
		}
		
		public function get remote():String
		{
			return _remote;
		}
		
		public function get active():Boolean
		{
			return _active;
		}	
		
		public function get file():File
		{
			return _file;
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
	
		
	// TODO this maybe should be private called from an event handler	
	// set from RepositoryModel > proxy after bookmarks are first created //	

		public function attachBranches(a:Array):Boolean
		{
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
			return _branch != null;
		}
		
	}
	
}
