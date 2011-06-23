package system {

	import events.UIEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;

	public class FileBrowser extends EventDispatcher {

		private var _file:File = File.desktopDirectory;
	
		public function browseForFile($msg:String):void
		{
			_file.browseForOpen($msg);	
			_file.addEventListener(Event.SELECT, onValidSelection);
		}

		public function browseForDirectory($msg:String):void 
		{
			_file.browseForDirectory($msg);	
			_file.addEventListener(Event.SELECT, onValidSelection);
		}
		
		private function onValidSelection(e:Event):void 
		{
			dispatchEvent(new UIEvent(UIEvent.FILE_BROWSER_SELECTION, e.target as File));
		}
		
	}
	
}
