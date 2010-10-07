package view.bookmarks {
	import events.RepositoryEvent;

	import view.layout.ListItem;

	import flash.filesystem.File;

	public class Bookmark extends ListItem {

		private var _label			:String;
		private var _local			:String;		private var _remote			:String;
//		private var _branch			:String;
		private var _history		:Array;
		
		private var _view			:BookmarkItemMC = new BookmarkItemMC();
		private var _initialized	:Boolean = false;

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
		
	// history object -- stored locally to avoid unnecessary calls to the proxy //	
		
		public function set history(a:Array):void
		{
			_history = a;
			if (!_initialized) dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_READY));
			_initialized = true;
		}
		
		public function get history():Array
		{
			return _history;
		}
		
	}
	
}
