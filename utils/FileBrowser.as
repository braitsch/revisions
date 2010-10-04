package utils{
	import commands.UICommand;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.filesystem.File;

	public class FileBrowser extends EventDispatcher {

		private var _local:File = File.desktopDirectory.resolvePath('repositories');
		private var _target:String;
	
		public function browse($msg:String = 'browse'):void 
		{
			_local.browseForDirectory($msg);	
			_local.addEventListener(Event.SELECT, onDirectorySelection);
		}

		private function onDirectorySelection(e:Event):void 
		{
			_local = e.target as File;
			_target = _local.nativePath;
			dispatchEvent(new UICommand(UICommand.FILE_BROWSER_SELECTION, _target));
		}
		
	}
	
}
