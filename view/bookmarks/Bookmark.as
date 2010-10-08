package view.bookmarks {
	import view.layout.ListItem;

	import flash.filesystem.File;

	public class Bookmark extends ListItem {

	// branch constants //
		public static const MASTER	:String = 'master';
		public static const DETACH	:String = 'detach';

		private var _label			:String;
		private var _local			:String;		private var _remote			:String;
		private var _detach			:Branch;
		private var _branch			:Branch;
		private var _branches		:Array = [];
		private var _view			:BookmarkItemMC = new BookmarkItemMC();

		public function Bookmark($label:String, $local:String, $remote:String, $active:uint)
		{
			super(190, $active==1);
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
			
			_branch = new Branch(MASTER);
			_detach = new Branch(DETACH);
			_branches.push(_branch);
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
		}
		
		public function get master():Branch
		{
			return _branches[0];
		}
		
		public function get detach():Branch
		{
			return _detach;
		}
		
		public function get branches():Array
		{
			return _branches;
		}	
		
	}
	
}
