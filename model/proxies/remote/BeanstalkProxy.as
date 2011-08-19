package model.proxies.remote {

	import model.remote.Account;
	import system.BashMethods;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class BeanstalkProxy extends AccountProxy {

		private static var _loader		:URLLoader = new URLLoader();
		private static var _baseURL		:String;
		private static var _request		:String;
		
		public function BeanstalkProxy()
		{
			super.executable = 'Beanstalk.sh';
            _loader.addEventListener(Event.COMPLETE, onRequestComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onRequestFailure);
		}
		
		override public function login(ra:Account):void
		{
			_account = ra;
			_request = BashMethods.LOGIN;
			_baseURL = 'https://'+ra.user+':'+ra.pass+'@'+ra.user+'.beanstalkapp.com/api/';
			_loader.load(new URLRequest(_baseURL + 'users.xml'));
		}
		
		private function getRepositories():void
		{
			_request = BashMethods.GET_REPOSITORIES;
			_loader.load(new URLRequest(_baseURL + 'repositories.xml'));
		}			
		
		private function onRequestComplete(e:Event):void
		{
			var xml:XML = new XML(_loader.data);
			switch(_request){
				case BashMethods.LOGIN :
					onLoginSuccess(xml['user']);
				break;
				case BashMethods.GET_REPOSITORIES :
					onRepositories(xml['repository']);
				break;				
			}
		}

		private function onLoginSuccess(xl:XMLList):void
		{
			for (var i:int = 0; i < xl.length(); i++) {
				if (xl['login'] == _account.user) {
					var o:Object = {};
						o.id = xl['id'];
						o.email = xl['email'];
						o.name = xl['first-name']+' '+xl['last-name'];
					_account.loginData = o;	
				}
			}
			getRepositories();
		}
		
		private function onRepositories(xl:XMLList):void
		{
			var a:Array = [];
			for (var i:int = 0; i < xl.length(); i++) {
				if (xl[i]['vcs'] == 'git') a.push(xl[i]);
			}
			_account.repositories = a;
		//	traceUserData();
			dispatchLoginSuccess();
		}
		
//		private function traceUserData():void
//		{
//			for (var i : String in _userData) trace(i, '::', _userData[i]);
//		}
		
		private function onRequestFailure(e:IOErrorEvent):void
		{
			trace("BeanstalkProxy.onFailure(e)", e);
		}		
		
	}
	
}
