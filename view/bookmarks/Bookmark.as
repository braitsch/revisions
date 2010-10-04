package view.bookmarks {
	import view.layout.ListItem;

	import flash.filesystem.File;

	public class Bookmark extends ListItem {

		private var _view		:BookmarkItemMC = new BookmarkItemMC();
		private var _label		:String;		private var _local		:String;
		private var _remote		:String;

		public function Bookmark($label:String, $local:String, $remote:String, $active:uint)
		{
			super(new File('file://'+$local), 190, $active==1);
			
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
		
	}
	
}
