package model.db {

	import events.InstallEvent;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class AppSettings extends EventDispatcher {

		public static var CHECK_FOR_UPDATES			:String = 'checkForUpdates';
		public static var PROMPT_BEFORE_DOWNLOAD	:String = "promptBeforeDownload";

		private static var _file		:File;
		private static var _xml			:XML;
		private static var _stage		:Stage;
		private static var _settings:Object = {};

		public function initialize(stage:Stage):void
		{
			_stage = stage;
			_stage.nativeWindow.addEventListener(Event.CLOSING, saveXML); 
			_file = File.applicationStorageDirectory.resolvePath("settings.xml");
			_file.exists ? readXML() : saveXML();
		}
		
		public static function setSetting(name:String, val:*):void
		{
			_settings[name] = val;
		}
		
		public static function getSetting(name:String):*
		{
			for (var p:String in _settings) if (name == p) return _settings[p];
		}

		private function readXML():void 
		{
			var stream:FileStream = new FileStream();
    			stream.open(_file, FileMode.READ);
			_xml = XML(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
			_stage.nativeWindow.x = _xml['window'].@x;
			_stage.nativeWindow.y = _xml['window'].@y;
			_stage.nativeWindow.width = _xml['window'].@width;
			_stage.nativeWindow.height = _xml['window'].@height;
			_stage.nativeWindow.visible = true;
		// store user-defined preferences //	
			var p:XMLList = _xml['user-defined'].children();
			for (var i:int = 0; i < p.length(); i++) _settings[p[i].name()] = p[i].valueOf();
			dispatchEvent(new InstallEvent(InstallEvent.SETTINGS));
			traceSettings();
		}
		
		private function saveXML(e:Event = null):void
		{
			getSettings(); 
			writeToFile();
		}
		
		private function getSettings():void 
		{
			_xml = <preferences/>;
			_xml['window'].@width = _stage.nativeWindow.width;
			_xml['window'].@height = _stage.nativeWindow.height;
			_xml['window'].@x = _stage.nativeWindow.x;
			_xml['window'].@y = _stage.nativeWindow.y;
		// write user-defined preferences //	
			for (var p:String in _settings) _xml['user-defined'][p] = _settings[p];
			_xml['lastSaved'] = new Date().toString();
		}
		
		private function traceSettings():void
		{
			for (var p:String in _settings) trace('prop & value = '+p, _settings[p]);
		}
		
		private function writeToFile():void 
		{
			traceSettings();
			var output:String = '<?xml version="1.0" encoding="utf-8"?>\n';
				output += _xml.toXMLString();
				output = output.replace(/\n/g, File.lineEnding);
			var stream:FileStream = new FileStream();
				stream.open(_file, FileMode.WRITE);
				stream.writeUTFBytes(output);
				stream.close();
		}

	}
	
}
