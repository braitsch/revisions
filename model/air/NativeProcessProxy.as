package model.air {

	import events.NativeProcessEvent;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import system.StringUtils;


	public class NativeProcessProxy extends EventDispatcher {
		
		private var _np				:NativeProcess = new NativeProcess();
		private var _npi			:NativeProcessStartupInfo = new NativeProcessStartupInfo();
		private var _dir			:String = File.desktopDirectory.nativePath;
		private var _method			:String;
		private var _result			:String;
		private var _failed			:Boolean = false;	
		protected var debug			:Boolean = false;
		
		public function NativeProcessProxy($exec:String = '')
		{
			if (NativeProcess.isSupported){
				init();
			}	else{
				log('Error : NativeProcess is NOT Supported');
			}
			if ($exec) _npi.executable = File.applicationDirectory.resolvePath('sh/'+$exec);	
		}
		
		public function set executable($file:String):void
		{			_npi.executable = File.applicationDirectory.resolvePath('sh/'+$file);			}
		
		public function set directory($dir:String):void
		{
			_dir = $dir;
		}	
		
		public function get failed():Boolean
		{
			return _failed;
		}			
		
		public function call(v:Vector.<String>):void
		{
			v.push(_dir);
			_method = v[0];
			_result = '';
			_failed = false;
			_npi.arguments = v;
			log('Attempting to Call Method :: '+_method);
			if(!_np.running){				log('Calling Method :: '+_method);
				_np.start(_npi);
			}	else{
				log('NativeProcess Is Still Running - Check Bash File For Errors');
			}
		}
		
		private function init():void
		{
            _np.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onDataReceived);
            _np.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onDataError);
            _np.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            _np.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
            _np.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
		}
		
		private function onDataReceived(e:ProgressEvent):void 
		{
			if (_result!='') _result+='\n'; // linebreak between batches of data received //
			_result += StringUtils.trim(_np.standardOutput.readUTFBytes(_np.standardOutput.bytesAvailable));
            log('DataReceived @ '+_method+ ' :: Response = '+_result);		}
		
		private function onDataError(e:ProgressEvent):void 
		{
			_failed = true;
            _result = StringUtils.trim(_np.standardError.readUTFBytes(_np.standardError.bytesAvailable));            log('DataError @ '+_method+ ' :: Response = '+_result);			dispatchEvent(new NativeProcessEvent(NativeProcessEvent.PROCESS_FAILURE, {method:_method, result:_result}));
		}	
		
		private function onIOError(e:IOErrorEvent):void 
		{
			_failed = true;
			log('IOError @ '+_method+ ' :: Response = '+e.toString());
			dispatchEvent(new NativeProcessEvent(NativeProcessEvent.PROCESS_FAILURE, {method:_method}));
		}				

		private function onProcessExit(e:NativeProcessExitEvent):void 
		{
			log("NativeProcessProxy :: Process Complete");
			dispatchEvent(new NativeProcessEvent(NativeProcessEvent.PROCESS_COMPLETE, {method:_method, result:_result}));
		}
		
		private function log(...args):void
		{
			if (debug) trace(args);
		}
		
	}
	
}
