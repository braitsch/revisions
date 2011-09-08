package model.proxies.remote.acct {

	import events.AppEvent;
	import events.ErrEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.BookmarkRemote;

	public class GitHubApi extends ApiProxy {

	// public methods //

		override public function login(ra:HostingAccount):void
		{
			super.login(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@api.github.com';
			super.loginToAccount('/users/'+ra.user);
		}
		
		override public function addRepository(o:Object):void
		{
			super.addRepositoryToAccount(HEADER_TXT, getRepoObj(o.name, o.desc, o.publik), '/user/repos');
		}
		
		override public function addCollaborator(r:String, u:String):void
		{
			super.addCollaboratorToAccount('Content-Length: 0', '/repos/'+super.account.user+'/'+r+'/collaborators/'+u);
		}
		
	// handlers //	
		
		override protected function onLoginSuccess(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				super.account.loginData = getResultObject(s);
				super.getRepositories('/user/repos');
			}	else{
				dispatchFailure(ErrEvent.LOGIN_FAILURE);
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
		
		override protected function onCollaboratorAdded(s:String):void
		{	
			var o:Object = getResultObject(s);
			if (o.message == null){
				dispatchCollaboratorSuccess();
			}	else{
				handleJSONError(o.message);		
			}
		}
		
	// handle github specific errors //		
		
		private function handleJSONError(m:String):void
		{
			switch(m){
				case 'Bad Credentials' :
					dispatchFailure(ErrEvent.LOGIN_FAILURE);
				break;
				case 'name can\'t be private. You are over your quota.' :
					dispatchFailure(ErrEvent.OVER_QUOTA);
				break;
				case 'name is already taken' :
					dispatchFailure(ErrEvent.REPOSITORY_TAKEN);
				break;	
				case 'Not Found' :
					dispatchFailure(ErrEvent.COLLAB_NOT_FOUND);
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
