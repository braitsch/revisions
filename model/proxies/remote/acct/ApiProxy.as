package model.proxies.remote.acct {

	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.CurlProxy;
	import model.remote.HostingAccount;
	import system.BashMethods;
	import system.StringUtils;
	import view.modals.collab.Collab;

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
			super.request = BashMethods.ADD_BKMK_TO_ACCOUNT;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Connecting to '+StringUtils.capitalize(_account.type)}));
			super.call(Vector.<String>([BashMethods.POST_REQUEST, header, data, _baseURL + url]));
		}
		
	// collaborators //	
		
		public function addCollaborator(o:Collab):void { }
		protected function addCollaboratorToGitHub(header:String, url:String):void
		{
			startTimer();
			super.request = BashMethods.ADD_COLLABORATOR;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Adding Collaborator'}));
			super.call(Vector.<String>([BashMethods.PUT_REQUEST, header, _baseURL + url]));
		}		
		
		protected function addCollaboratorToBeanstalk(header:String, data:Object, url:String):void
		{
			startTimer();
			super.request = BashMethods.ADD_COLLABORATOR;
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_LOADER, {msg:'Adding Collaborator'}));
			super.call(Vector.<String>([BashMethods.POST_REQUEST, header, data, _baseURL + url]));	
		}
		
		protected function setCollaboratorPermissions(header:String, data:Object, url:String):void
		{
			startTimer();
			super.request = BashMethods.SET_PERMISSIONS;
			super.call(Vector.<String>([BashMethods.POST_REQUEST, header, data, _baseURL + url]));	
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
				case BashMethods.ADD_BKMK_TO_ACCOUNT : 
					onRepositoryCreated(r);
				break;	
				case BashMethods.ADD_COLLABORATOR : 
					onCollaboratorAdded(r);
				break;	
				case BashMethods.SET_PERMISSIONS : 
					onPermissionsSet(r);
				break;																	
			}			
		}

	// callbacks //	
		
		protected function onLoginSuccess(s:String):void { }
		
		protected function onRepositories(s:String):void { }
		
		protected function onRepositoryCreated(s:String):void { }
		
		protected function onCollaboratorAdded(s:String):void { }
		
		protected function onPermissionsSet(s:String):void { }		
		
		protected function dispatchLoginSuccess():void 
		{ 
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS, _account));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));
		}
		
		protected function dispatchCollaboratorSuccess():void
		{
			dispatchEvent(new AppEvent(AppEvent.COLLABORATOR_ADDED));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.HIDE_LOADER));			
		}
		
	}
	
}
