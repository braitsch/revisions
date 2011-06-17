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
		
		public function browseForAnything($msg:String):void
		{
		//TODO i don't think this lets us select folders - fuck!!	
		// i think i just need to create two separate buttons
		// track file, track folder..
			_file.browseForOpen($msg);			
			_file.addEventListener(Event.SELECT, onValidSelection);
		}

		private function onValidSelection(e:Event):void 
		{
			dispatchEvent(new UIEvent(UIEvent.FILE_BROWSER_SELECTION, e.target as File));
		}
		
	}
	
}
