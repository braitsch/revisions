package model.proxies.remote {

	import events.ErrorType;
	import model.remote.Account;

	public class BeanstalkProxy extends AccountProxy {

		override public function login(ra:Account):void
		{
			super.login(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@'+ra.user+'.beanstalkapp.com/api/';
			super.makeRequest('users.xml');
		}
		
		override protected function getRepositories():void
		{
			super.getRepositories();
			super.makeRequest('repositories.xml');
		}			
		
		override protected function onLoginSuccess(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var xml:XML = new XML(s);
			var usr:XMLList = xml['user'];
			for (var i:int = 0; i < usr.length(); i++) {
				if (usr['login'] == super.account.user) {
					var o:Object = {};
						o.id = usr['id'];
						o.email = usr['email'];
						o.name = usr['first-name']+' '+usr['last-name'];
					super.account.loginData = o;	
				}
			}
			getRepositories();
		}
		
		override protected function onRepositories(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var a:Array = [];
			var xml:XML = new XML(s);
			var xl:XMLList = xml['repository'];			
			for (var i:int = 0; i < xl.length(); i++) {
				if (xl[i]['vcs'] == 'git') a.push(xl[i]);
			}
			super.account.repositories = a;
			dispatchLoginSuccess();
		}
		
		private function checkForErrors(s:String):Boolean
		{
			if (s.indexOf('<html>') != -1){
				dispatchFailure(ErrorType.LOGIN_FAILURE);
				return true;
			}	else if (s.indexOf('Could\'t authenticate you') != -1){
				dispatchFailure(ErrorType.LOGIN_FAILURE);
				return true;
			}	else{
				return false;
			}
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			trace("BeanstalkProxy.onRepositoryCreated(s)", s);
		}		
		
	}
	
}
