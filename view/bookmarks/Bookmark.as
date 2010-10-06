package view.bookmarks {
	import events.RepositoryEvent;

	import model.git.RepositoryHistory;

	import view.layout.ListItem;

	import flash.filesystem.File;

	public class Bookmark extends ListItem {

		private var _view			:BookmarkItemMC = new BookmarkItemMC();
		private var _label			:String;		private var _local			:String;
		private var _remote			:String;
		private var _proxy			:RepositoryHistory = new RepositoryHistory();		
		private var _history		:Array = [];
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
			
			_proxy.bookmark = this;
			_proxy.getHistory();
			_proxy.addEventListener(RepositoryEvent.HISTORY_RECEIVED, onHistoryReceived);	
		}
		
		public function getHistory():void
		{
			_proxy.getHistory();	
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
		
		public function get history():Array
		{
			return _history;
		}
		
		private function onHistoryReceived(e:RepositoryEvent):void 
		{
			trace("Bookmark.onHistoryReceived(e)");
			_history = e.data as Array;
			if (!_initialized) dispatchEvent(new RepositoryEvent(RepositoryEvent.BOOKMARK_READY));
			_initialized = true;
			
		}		
		
	}
	
}
