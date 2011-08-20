package model.proxies.remote.acct {

	import events.ErrorType;
	import model.remote.Account;

	public class BeanstalkProxy extends AccountProxy {

		override public function login(ra:Account):void
		{
			super.login(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@'+ra.user+'.beanstalkapp.com/api/';
			super.attemptLogin('users.xml');
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
			super.getRepositories('repositories.xml');
		}
		
		override protected function onRepositories(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var a:Array = [];
			var xml:XML = new XML(s);
			var xl:XMLList = xml['repository'];			
			for (var i:int = 0; i < xl.length(); i++) {
				if (xl[i]['vcs'] == 'git') {
					xl[i]['https_url'] = 'git@'+super.account.user+'.beanstalkapp.com:/'+xl[i]['name']+'.git';
					a.push(xl[i]);
				}
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
			}	else if (s.indexOf('API is disabled for this account') != -1){
				dispatchFailure(ErrorType.API_DISABLED);
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
