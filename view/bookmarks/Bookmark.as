package view.bookmarks {
	import events.RepositoryEvent;
	import utils.StringUtils;

	import view.layout.ListItem;

	import flash.filesystem.File;

	public class Bookmark extends ListItem {

	// branch constants //
		public static const MASTER	:String = 'master';
		public static const DETACH	:String = 'detach';

		private var _label			:String;
		private var _local			:String;		private var _remote			:String;
		private var _master			:Branch;		private var _detach			:Branch = new Branch(DETACH);
		private var _branch			:Branch;
		private var _previous		:Branch;
		private var _branches		:Array = [];
		private var _view			:BookmarkItemMC = new BookmarkItemMC();	

		public function Bookmark($label:String, $local:String, $remote:String, $active:Boolean)
		{
			super(190, $active);
			super.file = new File('file://'+$local);
			
			_label = $label;
			_local = $local;
			_remote = $remote;
			
			_view.label_txt.autoSize = 'left';
			_view.label_txt.text = _label;
			_view.label_txt.selectable = false;
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
			addChild(_view);
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

		public function get previous():Branch
		{
			return _previous;
		}
		
		public function set previous(b:Branch):void
		{
			_previous = b;
		}
		
	// special branches //				
		
		public function get master():Branch
		{
			return _master;
		}
		
		public function get detach():Branch
		{
			return _detach;
		}
		
	// set from AppModel after bookmarks are first created //	

		public function set branches(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				var s:String = a[i];
				if (s.indexOf('*')==0){
					_branch = new Branch(StringUtils.trim(s.substr(1)));
					_branches.push(_branch);
				}	else{
					_branches.push(new Branch(StringUtils.trim(s)));
				}
			}
		}

		public function get branches():Array
		{
			return _branches;
		}
		
	}
	
}
