package model.proxies.remote.acct {

	import model.remote.Hosts;
	import events.AppEvent;
	import events.ErrorType;
	import model.remote.HostingAccount;
	import model.vo.BookmarkRemote;

	public class GitHubProxy extends AccountProxy {

	// public methods //

		override public function login(ra:HostingAccount):void
		{
			super.login(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@api.github.com';
			super.attemptLogin('/users/'+ra.user);
		}
		
		override public function makeNewRemoteRepository(o:Object):void
		{
			super.makeNewRepoOnAccount(HEADER_TXT, getRepoObj(o.name, o.desc, o.publik), '/user/repos');
		}		
		
	// handlers //	
		
		override protected function onLoginSuccess(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				super.account.loginData = getResultObject(s);
				super.getRepositories('/user/repos');
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
				Hosts.github.home.addRepository(o);
				dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, new BookmarkRemote(HostingAccount.GITHUB+'-'+o.name, o.ssh_url)));
			}	else{
				handleJSONError(o.errors[0].message);		
			}
		}
		
	// handle github specific errors //		
		
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
		
		private function getRepoObj(n:String, d:String, p:Boolean):String
		{
			var s:String = '';
				s+='{"name" : "'+n+'",';
			  	s+='"description" : "'+d+'",';
				s+='"homepage" : "https://github.com",';
			  	s+='"public" : '+p+',';
			 	s+='"has_issues" : true,';
			  	s+='"has_wiki" : true,';
			  	s+='"has_downloads" : true}';
			return s;
		}
		
	}
	
}
