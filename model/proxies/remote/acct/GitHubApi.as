package model.proxies.remote.acct {

	import model.vo.Permission;
	import events.AppEvent;
	import events.ErrEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Collaborator;
	import model.vo.GitHubRepo;

	public class GitHubApi extends ApiProxy {
		
		private static var _baseURL		:String;
		private static var _account		:HostingAccount;		

		public function GitHubApi()
		{
			super.executable = 'GitHub.sh';
		}

	// public methods //

		override public function login(ha:HostingAccount):void
		{
			_account = ha;
			_baseURL = 'https://'+_account.user+':'+_account.pass+'@api.github.com';
			super.loginX(_baseURL + '/users/'+_account.user);
		}
		
		override public function addRepository(o:Object):void
		{
			super.addRepositoryX(getRepoObj(o.name, o.desc, o.publik), _baseURL + '/user/repos');
		}
		
		override public function getCollaborators():void
		{
			super.getCollaboratorsX(_baseURL + '/repos/'+_account.user+'/'+_account.repository.repoName+'/collaborators');
		}
		
		override public function killCollaborator(c:Collaborator):void
		{
			super.killCollaboratorX(_baseURL + '/repos/'+_account.user+'/'+_account.repository.repoName+'/collaborators/'+c.userName);
		}		
		
		override public function addCollaborator(o:Collaborator, p:Permission = null):void
		{
			super.addCollaboratorX(_baseURL + '/repos/'+_account.user+'/'+_account.repository.repoName+'/collaborators/'+o.userName);
		}		
		
	// handlers //	
		
		override protected function onLoginSuccess(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				_account.loginData = o;
				super.getRepositories(_baseURL + '/user/repos');
			}	else{
				dispatchFailure(ErrEvent.LOGIN_FAILURE);
			}
		}
		
		override protected function onRepositories(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				for (var i:int = 0; i < o.length; i++) _account.addRepository(new GitHubRepo(o[i]));
				Hosts.github.loggedIn = _account;
				super.dispatchLoginSuccess();
			}	else{
				handleJSONError(o.message);
			}
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.errors == null){
				_account.addRepository(new GitHubRepo(o));
				dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED));
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
						c.admin = o[i]['login'] == _account.user;
						c.avatarURL = o[i]['avatar_url'];
					v.push(c);
				}
				_account.repository.collaborators = v;
				super.dispatchCollaborators();
			}	else{
				handleJSONError(o.message);
			}		
		}
		
		override protected function onCollaboratorAdded(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				getCollaborators();
			}	else{
				handleJSONError(o.message);
			}
		}
		
		override protected function onCollaboratorRemoved(s:String):void
		{
			var o:Object = getResultObject(s);
			if (o.message == null){
				getCollaborators();
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
