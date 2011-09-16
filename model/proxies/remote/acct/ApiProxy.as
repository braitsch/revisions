package model.proxies.remote.acct {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.CurlProxy;
	import model.remote.HostingAccount;
	import model.vo.Collaborator;
	import system.BashMethods;
	import system.StringUtils;

	public class ApiProxy extends CurlProxy {

		private static var _baseURL		:String;
		private static var _account		:HostingAccount;

		public function ApiProxy()
		{
			super.executable = 'Account.sh';
		}
		
		protected function get account()				:HostingAccount 	{ return _account; 		}
		protected function set baseURL(baseURL:String)	:void 				{ _baseURL = baseURL; 	}	

		public function login(ra:HostingAccount):void { _account = ra; }
		protected function loginToAccount(url:String):void
		{
			startTimer();
			super.request = BashMethods.LOGIN;
			super.call(Vector.<String>([BashMethods.GET_REQUEST, _baseURL + url]));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Attemping Login'}));
		}
		
	// repositories //	
	
		protected function getRepositories(url:String):void
		{
			startTimer();
			super.request = BashMethods.GET_REPOSITORIES;
			super.call(Vector.<String>([BashMethods.GET_REQUEST, _baseURL + url]));
		}	
		
		public function addRepository(o:Object):void { }
		protected function addRepositoryToAccount(header:String, data:String, url:String):void
		{
			startTimer();
			super.request = BashMethods.ADD_REPOSITORY;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Connecting to '+StringUtils.capitalize(_account.type)}));
			super.call(Vector.<String>([BashMethods.POST_REQUEST, header, data, _baseURL + url]));
		}
		
	// collaborators //	
	
		public function getCollaborators():void { }	
		protected function getCollaboratorsOfRepo(url:String):void
		{
			startTimer();
			super.request = BashMethods.GET_COLLABORATORS;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Fetching Collaborators'}));
			super.call(Vector.<String>([BashMethods.GET_REQUEST, _baseURL + url]));			
		}
		
		public function addCollaborator(o:Collaborator):void { }
		protected function addCollaboratorToGitHub(header:String, url:String):void
		{
			startTimer();
			super.request = BashMethods.ADD_COLLABORATOR;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Adding Collaborator'}));
			super.call(Vector.<String>([BashMethods.PUT_REQUEST, header, header, _baseURL + url]));
		}		
		
		protected function addCollaboratorToBeanstalk(header:String, data:Object, url:String):void
		{
			startTimer();
			super.request = BashMethods.ADD_COLLABORATOR;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Adding Collaborator'}));
			super.call(Vector.<String>([BashMethods.POST_REQUEST, header, data, _baseURL + url]));	
		}
		
		public function killCollaborator(c:Collaborator):void { }	
		protected function killCollaboratorFromRepo(url:String):void
		{
			startTimer();
			super.request = BashMethods.KILL_COLLABORATOR;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Removing Collaborator'}));
			super.call(Vector.<String>([BashMethods.DELETE_REQUEST, _baseURL + url]));
		}	
		
	// beanstalk permission methods //			
		
		protected function getCollaboratorsPermissions(url:String):void
		{
			startTimer();
			super.request = BashMethods.GET_PERMISSIONS;
			super.call(Vector.<String>([BashMethods.GET_REQUEST, _baseURL + url]));			
		}
		
		protected function setCollaboratorPermissions(header:String, data:Object, url:String):void
		{
			startTimer();
			super.request = BashMethods.SET_PERMISSIONS;
			super.call(Vector.<String>([BashMethods.POST_REQUEST, header, data, _baseURL + url]));	
		}
		
		protected function setAdmin(header:String, data:Object, url:String):void
		{
			startTimer();
			super.request = BashMethods.SET_ADMINISTRATOR;
			super.call(Vector.<String>([BashMethods.PUT_REQUEST, header, data, _baseURL + url]));				
		}			
		
		override protected function onProcessSuccess(r:String):void
		{
			switch(super.request){
				case BashMethods.LOGIN :
					onLoginSuccess(r);
				break;
				case BashMethods.GET_REPOSITORIES :
					onRepositories(r);
				break;
				case BashMethods.ADD_REPOSITORY : 
					onRepositoryCreated(r);
				break;	
				case BashMethods.GET_COLLABORATORS : 
					onCollaborators(r);
				break;	
				case BashMethods.ADD_COLLABORATOR : 
					onCollaboratorAdded(r);
				break;	
				case BashMethods.KILL_COLLABORATOR : 
					onCollaboratorRemoved(r);
				break;					
				case BashMethods.GET_PERMISSIONS : 
					onGetPermissions(r);
				break;								
				case BashMethods.SET_PERMISSIONS : 
					onSetPermissions(r);
				break;
				case BashMethods.SET_ADMINISTRATOR : 
					dispatchCollaborators();
				break;				
			}			
		}

	// callbacks //	
		
		protected function onLoginSuccess(s:String):void { }
		
		protected function onRepositories(s:String):void { }
		
		protected function onRepositoryCreated(s:String):void { }

		protected function onCollaborators(s:String):void { }
		
		protected function onCollaboratorAdded(s:String):void { }
		
		protected function onCollaboratorRemoved(s:String):void { }
		
		protected function onGetPermissions(s:String):void { }
		
		protected function onSetPermissions(s:String):void { }
		
		protected function dispatchLoginSuccess():void 
		{ 
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS));
		}
		
		protected function dispatchCollaborators():void 
		{ 
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.COLLABORATORS_RECEIEVED));
		}

	}
	
}
