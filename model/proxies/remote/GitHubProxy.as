package model.proxies.remote {

	import events.AppEvent;
	import events.ErrorType;
	import model.AppModel;
	import model.remote.Account;
	import model.vo.Remote;

	public class GitHubProxy extends AccountProxy {

		override public function login(ra:Account):void
		{
			super.login(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@api.github.com/';
			super.attemptLogin('users/'+ra.user);
		}
		
		override protected function onLoginSuccess(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				super.account.loginData = getResultObject(s);
				super.getRepositories('user/repos');
			}	else{
				dispatchFailure(ErrorType.LOGIN_FAILURE);
			}
		}
		
		override protected function onRepositories(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				super.account.repositories = o as Array;
				dispatchLoginSuccess();
			}	else{
				handleJSONError(o.message);
			}
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.errors == null){
				var r:Remote = new Remote(Account.GITHUB+'-'+o.name, o.ssh_url);
				AppModel.proxies.editor.addRemoteToLocalRepository(r);
				dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, o));
			}	else{
				handleJSONError(o.errors[0].message);		
			}
		}
		
		private function handleJSONError(m:String):void
		{
			switch(m){
				case 'Bad Credentials' :
					dispatchFailure(ErrorType.LOGIN_FAILURE);
				break;
				case 'name can\'t be private. You are over your quota.' :
					dispatchFailure(ErrorType.OVER_QUOTA);
				break;
				case 'name is already taken' :
					dispatchFailure(ErrorType.REPOSITORY_TAKEN);
				break;	
			}
		}
		
	}
	
}
