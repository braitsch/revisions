package model.proxies.remote.acct {

	import events.AppEvent;
	import events.ErrEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Collaborator;
	import model.vo.GitHubRepo;
	import model.vo.Repository;

	public class GitHubApi extends ApiProxy {

		private static var _repository		:Repository;
		
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
		
		override public function getCollaborators(r:Repository):void
		{
			_repository = r;
			super.getCollaboratorsOfRepo('/repos/'+super.account.user+'/'+r.repoName+'/collaborators');
		}
		
		override public function killCollaborator(r:Repository, c:Collaborator):void
		{
			super.killCollaboratorFromRepo('/repos/'+super.account.user+'/'+r.repoName+'/collaborators/'+c.userName);
		}		
		
		override public function addCollaborator(o:Collaborator, r:Repository):void
		{
			super.addCollaboratorToGitHub('Content-Length: 0', '/repos/'+super.account.user+'/'+r.repoName+'/collaborators/'+o.userName);
		}		
		
	// handlers //	
		
		override protected function onLoginSuccess(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				super.account.loginData = o;
				super.getRepositories('/user/repos');
			}	else{
				dispatchFailure(ErrEvent.LOGIN_FAILURE);
			}
		}
		
		override protected function onRepositories(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				for (var i:int = 0; i < o.length; i++) super.account.addRepository(new GitHubRepo(o[i]));
				super.dispatchLoginSuccess();
			}	else{
				handleJSONError(o.message);
			}
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.errors == null){
				var rpo:GitHubRepo = new GitHubRepo(o);
				Hosts.github.home.addRepository(rpo);
				dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, rpo));
			}	else{
				handleJSONError(o.errors[0].message);		
			}
		}

		override protected function onCollaborators(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				var v:Vector.<Collaborator> = new Vector.<Collaborator>();
				for (var i:int = 0; i < o.length; i++) {
					var c:Collaborator = new Collaborator();
						c.userId = o[i]['id'];
						c.userName = o[i]['login'];
						c.avatarURL = o[i]['avatar_url'];
					v.push(c);
				}
				_repository.collaborators = v;
				super.dispatchCollaborators();
			}	else{
				handleJSONError(o.message);
			}		
		}
		
		override protected function onCollaboratorAdded(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				getCollaborators(_repository);
			}	else{
				handleJSONError(o.message);
			}
		}
		
		override protected function onCollaboratorRemoved(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				getCollaborators(_repository);
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
