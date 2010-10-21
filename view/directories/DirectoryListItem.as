package view.directories {
	import events.UIEvent;

	import view.layout.ListItem;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class DirectoryListItem extends ListItem {

		private var _view		:DirectoryMC = new DirectoryMC();
		private var _collapsed	:Boolean = true;
		private var _subdirs 	:Vector.<ListItem>;

		public function DirectoryListItem($f:File)
		{
			super.file = $f;
			super.draw(280, 20);
			
			_view.mouseEnabled = false;
			_view.label_txt.x = 25;
			_view.label_txt.autoSize = 'left';
			_view.label_txt.mouseEnabled = false;
			_view.label_txt.text = clean(super.file.url);
			_view.nested.addEventListener(MouseEvent.CLICK, onToggleSubDirectories);
			
			addChild(_view);		
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
	// private //			

		private function onToggleSubDirectories(e:MouseEvent):void 
		{
			_collapsed=!_collapsed;
			dispatchEvent(new UIEvent(UIEvent.TOGGLE_OPEN_DIRECTORY, {open:!_collapsed, subdirs:_subdirs}));
		}

		private function onAddedToStage(e:Event):void 
		{
			if (_subdirs==null){
				_subdirs = new Vector.<ListItem>();
				var a:Array = super.file.getDirectoryListing();
				for (var i : int = 0; i < a.length; i++) {
					if (a[i].isDirectory) _subdirs.push(new DirectoryListItem(a[i]));			
				}
				_view.nested.visible = (_subdirs.length > 0);
			}
		}
		
		private function clean(s:String):String
		{	
			return s.substr(s.lastIndexOf('/')+1).replace(/%20/g, ' ').replace('.app', '');	
		}
		
	}
	
}
