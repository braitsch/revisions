package model.db {

	import events.InstallEvent;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class AppSettings {

		private static var _file		:File;
		private static var _xml			:XML;
		private static var _stage		:Stage;
		private static var _settings	:Array = [];

		public static function initialize(stage:Stage):void
		{
			_stage = stage;
			_stage.nativeWindow.addEventListener(Event.CLOSING, saveXML); 
			_file = File.applicationStorageDirectory.resolvePath("settings.xml");
			_file.exists ? readXML() : saveXML();
		}
		
		public static function set setting(o:Object):void
		{
			_settings.push(o);			
		}

		private static function readXML():void 
		{
			var stream:FileStream = new FileStream();
    			stream.open(_file, FileMode.READ);
			_xml = XML(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
			_stage.nativeWindow.x = _xml['window'].@x;
			_stage.nativeWindow.y = _xml['window'].@y;
			_stage.nativeWindow.width = _xml['window'].@width;
			_stage.nativeWindow.height = _xml['window'].@height;
			var p:XMLList = _xml['user-defined'].children();
			for (var i:int = 0; i < p.length(); i++) {
				var o:Object = {};
					o[p.name()] = p.valueOf();
				_settings.push(o);	
			}
			_stage.nativeWindow.visible = true;
			_stage.dispatchEvent(new InstallEvent(InstallEvent.SETTINGS, _settings));
		}
		
		private static function saveXML(e:Event = null):void
		{
			getSettings(); 
			writeToFile();
		}
		
		private static function getSettings():void 
		{
			_xml = <preferences/>;
			_xml['window'].@width = _stage.nativeWindow.width;
			_xml['window'].@height = _stage.nativeWindow.height;
			_xml['window'].@x = _stage.nativeWindow.x;
			_xml['window'].@y = _stage.nativeWindow.y;
		// write user defined preferences //	
			for (var i:int = 0; i < _settings.length; i++) {
				var p:Object = _settings[i];
				for (var val : String in p) _xml['user-defined'][val] = p[val];
			}
			_xml['lastSaved'] = new Date().toString();
		}
		
		private static function writeToFile():void 
		{
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
