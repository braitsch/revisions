package view.bookmarks {
	import events.RepositoryEvent;

	import model.git.RepositoryProxy;

	import view.layout.ListItem;

	import flash.filesystem.File;

	public class Bookmark extends ListItem {

		private var _view		:BookmarkItemMC = new BookmarkItemMC();
		private var _label		:String;		private var _local		:String;
		private var _remote		:String;
		private var _proxy		:RepositoryProxy;		
		private var _status 	:Array = [];		private var _history	:Array = [];

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
			
			initialize();
		}

		private function initialize():void 
		{
			_proxy = new RepositoryProxy(this);
			_proxy.status.addEventListener(RepositoryEvent.STATUS_RECEIVED, onStatus);			
			_proxy.history.addEventListener(RepositoryEvent.HISTORY_RECEIVED, onHistory);
		}

		private function onStatus(e:RepositoryEvent):void 
		{
			trace("Bookmark.onStatus(e)");
			_status = e.data as Array;
		}

		private function onHistory(e:RepositoryEvent):void 
		{
			trace("Bookmark.onHistory(e)");
			_history = e.data as Array;
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
		
		public function get status():Array
		{
			return _status;
		}		
		
		public function get history():Array
		{
			return _history;
		}
		
	}
	
}
