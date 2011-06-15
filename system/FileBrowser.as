package system{
	import events.UIEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.filesystem.File;

	public class FileBrowser extends EventDispatcher {

		private var _local:File = File.desktopDirectory.resolvePath('repositories');
	
		public function browse($msg:String = 'browse'):void 
		{
			_local.browseForDirectory($msg);	
			_local.addEventListener(Event.SELECT, onDirectorySelection);
		}

		private function onDirectorySelection(e:Event):void 
		{
			dispatchEvent(new UIEvent(UIEvent.FILE_BROWSER_SELECTION, e.target as File));
		}
		
	}
	
}
