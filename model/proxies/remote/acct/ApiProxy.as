package model.proxies.remote.acct {

	import model.vo.Permission;
	import events.AppEvent;
	import model.AppModel;
	import model.proxies.remote.base.CurlProxy;
	import model.remote.HostingAccount;
	import model.vo.Collaborator;
	import system.BashMethods;

	public class ApiProxy extends CurlProxy {

		public function login(ra:HostingAccount):void { }
		protected function loginX(url:String):void
		{
			super.call(Vector.<String>([BashMethods.LOGIN, url]));
		}
		
	// repositories //	
	
		protected function getRepositories(url:String):void
		{
			super.call(Vector.<String>([BashMethods.GET_REPOSITORIES, url]));
		}	
		
		public function addRepository(o:Object):void { }
		protected function addRepositoryX(data:String, url:String):void
		{
			super.call(Vector.<String>([BashMethods.ADD_REPOSITORY, data, url]));
		}
		
	// collaborators //	
	
		public function getCollaborators():void { }	
		protected function getCollaboratorsX(url:String):void
		{
			super.call(Vector.<String>([BashMethods.GET_COLLABORATORS, url]));			
		}
		
		public function addCollaborator(o:Collaborator, p:Permission = null):void { }
		protected function addCollaboratorX(url:String, data:Object = null):void
		{
			if (data == null){
				super.call(Vector.<String>([BashMethods.ADD_COLLABORATOR, url]));	
			}	else{
				super.call(Vector.<String>([BashMethods.ADD_COLLABORATOR, data, url]));	
			}
		}
		
		public function killCollaborator(c:Collaborator):void { }	
		protected function killCollaboratorX(url:String):void
		{
			super.call(Vector.<String>([BashMethods.KILL_COLLABORATOR, url]));
		}	
		
	// beanstalk permission methods //			
		
		protected function getPermissions(url:String):void
		{
			super.call(Vector.<String>([BashMethods.GET_PERMISSIONS, url]));			
		}
		
		public function setPermissions(c:Collaborator, p:Permission):void { }
		protected function setPermissionsX(data:Object, url:String):void
		{
			super.call(Vector.<String>([BashMethods.SET_PERMISSIONS, data, url]));	
		}
		
	// callbacks //			
		
		override protected function onProcessSuccess(m:String, r:String):void
		{
			switch(m){
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
