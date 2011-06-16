package system {

	import events.InstallEvent;
	import flash.events.EventDispatcher;
	import events.UIEvent;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	public class UpdateManager extends EventDispatcher
	{
		private static const UPDATE_DESCRIPTOR_URL:String = "http://revisions-app.com/download/update.xml";
		
		private var updateFile	:File;
		private var urlStream	:URLStream;
		private var fileStream	:FileStream;
		private var hdiutil		:HdiutilHelper;
		private var _updateURL	:String;
		
	// public methods //	
		
		public function checkForUpdate():void
		{
			downloadXMLUpdateFile();
		}
		
		public function updateApplication():void
		{
			downloadNewInstallerFile();
		}
		
	// private methods //	
		
		private function downloadXMLUpdateFile():void
		{
		// fetch the update descriptor xml file //	
			var XMLLoader:URLLoader = new URLLoader;
			XMLLoader.addEventListener(Event.COMPLETE, onUpdateXMLLoadComplete);
			XMLLoader.addEventListener(IOErrorEvent.IO_ERROR, onUpdateXMLLoadError);
			XMLLoader.load(new URLRequest(UPDATE_DESCRIPTOR_URL));			
		}
		
		private function onUpdateXMLLoadComplete(event:Event):void
		{
			var XMLLoader:URLLoader = URLLoader(event.currentTarget);
			killUpdateXMLLoader(XMLLoader);
		
		// Getting update descriptor XML from loaded data
			var newDescriptor:XML = XML(XMLLoader.data);
			
		// Getting application descriptor XML
			var oldDescriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			
			var ndns:Namespace = newDescriptor.namespace();
			var odns:Namespace = oldDescriptor.namespace();
			
			var newVersion:String = newDescriptor.ndns::versionNumber.toString();
			var oldVersion:String = oldDescriptor.odns::versionNumber.toString();
			
		// Compare current version with update version
			if (oldVersion == newVersion) {
				dispatchEvent(new InstallEvent(InstallEvent.APP_UP_TO_DATE));
			}	else{
				_updateURL = newDescriptor.ndns::url.toString();
				dispatchEvent(new InstallEvent(InstallEvent.UPDATE_AVAILABLE, {o:oldVersion, n:newVersion}));
			}
		}
		
		private function onUpdateXMLLoadError(event:IOErrorEvent):void
		{
			killUpdateXMLLoader(URLLoader(event.currentTarget));
			dispatchEvent(new InstallEvent(InstallEvent.UPDATE_FAILURE, event.text));			
		}
		
		private function killUpdateXMLLoader(XMLLoader:URLLoader):void
		{
			XMLLoader.removeEventListener(Event.COMPLETE, onUpdateXMLLoadComplete);
			XMLLoader.removeEventListener(IOErrorEvent.IO_ERROR, onUpdateXMLLoadError);
			XMLLoader.close();
		}
		
	// installer file //	
		
		private function downloadNewInstallerFile():void
		{
		// parse out the installer name & version e.g. Revisions-0.2.0.dmg
			var fileName:String = _updateURL.substr(_updateURL.lastIndexOf("/") + 1);
			
		// create a temp directory to load the installer into //
			updateFile = File.createTempDirectory().resolvePath(fileName);

		// download the updated installer //
			urlStream = new URLStream;
			urlStream.addEventListener(Event.OPEN, onURLStreamOpen);
			urlStream.addEventListener(ProgressEvent.PROGRESS, onURLStreamProgress);
			urlStream.addEventListener(Event.COMPLETE, onURLStreamComplete);
			urlStream.addEventListener(IOErrorEvent.IO_ERROR, onURLStreamError);
			urlStream.load(new URLRequest(_updateURL));
		}
		
		private function onURLStreamOpen(event:Event):void
		{
			fileStream = new FileStream;
			fileStream.open(updateFile, FileMode.WRITE);
		}
		
		private function onURLStreamProgress(event:ProgressEvent):void
		{
		// ByteArray with loaded bytes
			var loadedBytes:ByteArray = new ByteArray;
		// Reading loaded bytes
			urlStream.readBytes(loadedBytes);
		// Writing loaded bytes into the FileStream
			fileStream.writeBytes(loadedBytes);
			dispatchEvent(new InstallEvent(InstallEvent.UPDATE_PROGRESS, event));			
		}
		
		private function onURLStreamError(event:IOErrorEvent):void
		{
			closeStreams();
			dispatchEvent(new InstallEvent(InstallEvent.UPDATE_FAILURE, event.text));
		}
		
		private function onURLStreamComplete(event:Event):void
		{
			closeStreams();
			var os:String = Capabilities.os.toLowerCase();
			if (os.indexOf('win') != -1){
				installUpdate(updateFile);
			}	else if (os.indexOf('mac') != -1){
				hdiutil = new HdiutilHelper(updateFile);
				hdiutil.addEventListener(Event.COMPLETE, onHdiutilSuccess);
				hdiutil.addEventListener(ErrorEvent.ERROR, onHdiutilError);
				hdiutil.attach();
			}	else if (os.indexOf('linux') != -1){
				installUpdate(updateFile);
			}
			dispatchEvent(new InstallEvent(InstallEvent.UPDATE_COMPLETE));
		}
		
	// mac osx install handlers //	
		
		private function onHdiutilError(e:ErrorEvent):void
		{
			dispatchEvent(new InstallEvent(InstallEvent.UPDATE_FAILURE, e.text));
		}

		private function onHdiutilSuccess(e:Event):void
		{
    		var dmg:File = new File(e.target.mountPoint);
			var files:Array = dmg.getDirectoryListing();
            if (files.length == 1)
            {
				var installFileFolder:File = File(files[0]).resolvePath("Contents/MacOS");
				var installFiles:Array = installFileFolder.getDirectoryListing();
				if (installFiles.length == 1) {
					installUpdate(installFiles[0]);
				}	else{
					trace("Contents/MacOS folder should contain only 1 install file!");
				}
            }
		}
		
		private function installUpdate(installer:File):void
		{
		// Running the installer using NativeProcess API
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo;
				info.executable = installer;
			var process:NativeProcess = new NativeProcess;
				process.start(info);
			
		// Exit application for the installer to be able to proceed
			NativeApplication.nativeApplication.exit();
		}		
		
		private function closeStreams():void
		{
			urlStream.removeEventListener(Event.OPEN, onURLStreamOpen);
			urlStream.removeEventListener(ProgressEvent.PROGRESS, onURLStreamProgress);
			urlStream.removeEventListener(Event.COMPLETE, onURLStreamComplete);
			urlStream.removeEventListener(IOErrorEvent.IO_ERROR, onURLStreamError);
			urlStream.close();
			if (fileStream) fileStream.close();
		}
		
	}
	
}