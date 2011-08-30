package model.proxies.air {

	import events.NativeProcessEvent;
	import system.StringUtils;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;


	public class NativeProcessProxy extends EventDispatcher {
		
		private var _np				:NativeProcess = new NativeProcess();
		private var _npi			:NativeProcessStartupInfo = new NativeProcessStartupInfo();
		private var _dir			:String = File.desktopDirectory.nativePath;
		private var _method			:String;
		private var _result			:String;
		private var _failed			:Boolean = false;	
		private var _debug			:Boolean = false;
		
		public function NativeProcessProxy()
		{
			if (NativeProcess.isSupported){
				init();
			}	else{
				log('Error : NativeProcess is NOT Supported');
			}
		}
		
		protected function set executable($file:String):void
		{			_npi.executable = File.applicationDirectory.resolvePath('sh/'+$file);			}
		
		protected function set directory($dir:String):void
		{
			_dir = $dir;
		}	
		
		protected function get failed():Boolean
		{
			return _failed;
		}			
		
		protected function call(v:Vector.<String>):void
		{
			if(_np.running == false){
				v.push(_dir);				_method = v[0];
				_result = '';
				_failed = false;
				_npi.arguments = v;
				_np.start(_npi);
				log('Calling Method :: '+_method);
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
            log('DataReceived @ '+_method+ ' :: Response = '+_result);			dispatchEvent(new NativeProcessEvent(NativeProcessEvent.PROCESS_PROGRESS, {method:_method, result:_result}));
		}
		
		private function onDataError(e:ProgressEvent):void 
		{
			_failed = true;
			if (_result!='') _result+='\n'; // linebreak between batches of data received //
			_result += StringUtils.trim(_np.standardError.readUTFBytes(_np.standardError.bytesAvailable));			            log('DataError @ '+_method+ ' :: Response = '+_result);
			dispatchEvent(new NativeProcessEvent(NativeProcessEvent.PROCESS_FAILURE, {method:_method, result:_result}));
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
			if (_debug) trace(args);
		}
		
	}
	
}
