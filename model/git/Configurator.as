package model.git {
	import events.NativeProcessEvent;

	import model.air.NativeProcessQueue;

	import flash.events.EventDispatcher;

	public class Configurator extends EventDispatcher {

		private static var _proxy			:NativeProcessQueue;
		private static var _userName		:String;		private static var _userEmail		:String;

		public function Configurator()
		{
			_proxy = new NativeProcessQueue('Config.sh');
			_proxy.addEventListener(NativeProcessEvent.PROCESS_FAILURE, onProcessFailure);
			_proxy.addEventListener(NativeProcessEvent.PROCESS_COMPLETE, onProcessComplete);
			_proxy.addEventListener(NativeProcessEvent.QUEUE_COMPLETE, onShellQueueComplete);
			getUserInfo();
		}

		public function get userName():String
		{
			return _userName;
		}
		
		public function get userEmail():String
		{
			return _userEmail;
		}
		
		public function set userName($n:String):void
		{
			_proxy.call(Vector.<String>(['getUserName', $n]));
		}
		
		public function set userEmail($e:String):void
		{
			_proxy.call(Vector.<String>(['getUserEmail', $e]));
		}		
		
	// private methods //			

		private function getUserInfo():void
		{
			_proxy.queue = [	Vector.<String>(['getUserName']),
								Vector.<String>(['getUserEmail'])	];						
		}	
		
	// response handlers //			
		
		private function onShellQueueComplete(e:NativeProcessEvent):void 
		{
			_userName = e.data[0];
			_userEmail = e.data[1];
		//TODO prompt if username / email is empty	
		}

		private function onProcessComplete(e:NativeProcessEvent):void 
		{
			switch(e.data.method){
				case 'getUserName' : _userName = e.data.result;		break;				case 'getUserEmail' : _userEmail = e.data.result;	break;
			}
		}			
		
		private function onProcessFailure(e:NativeProcessEvent):void 
		{
			trace("Configurator.onProcessFailure(e)");
		}
					
	}
	
}
