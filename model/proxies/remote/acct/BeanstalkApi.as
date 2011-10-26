package model.proxies.remote.acct {

	import events.AppEvent;
	import events.ErrEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.vo.BeanstalkRepo;
	import model.vo.Collaborator;
	import model.vo.Permission;
	import model.vo.Repository;

	public class BeanstalkApi extends ApiProxy {
		
		private static var _index		:uint;
		private static var _collab		:Collaborator;
		private static var _permission	:Permission;
		private static var _baseURL		:String;
		private static var _account		:HostingAccount;
		private static var _silentLogin	:Boolean;

		public function BeanstalkApi()
		{
			super.executable = 'Beanstalk.sh';
		}

	// public methods //

		override public function login(ha:HostingAccount, silent:Boolean):void
		{
			_account = ha; _silentLogin = silent;
			_baseURL = 'https://'+_account.user+':'+_account.pass+'@'+_account.acctName+'.beanstalkapp.com/api';
			if (silent){
				super.silentLogin(_baseURL + '/users.xml');
			}	else{
				super.activeLogin(_baseURL + '/users.xml');
			}
		}
		
		override public function addRepository(o:Object):void
		{
			super.addRepositoryX(getRepoObj(o.name), _baseURL + '/repositories.xml');
		}
		
		override public function getCollaborators():void
		{
			super.getCollaboratorsX(_baseURL + '/users.xml');
		}						
		
		override public function addCollaborator(o:Collaborator, p:Permission = null):void
		{
			_collab = o; _permission = p; _permission.repoId = _account.repository.id;
			super.addCollaboratorX(_baseURL + '/users.xml', getCollabObj(_collab));
		}
		
		override public function killCollaborator(o:Collaborator):void
		{
			_collab = o;
			super.killCollaboratorX(_baseURL + '/users/'+o.userId+'.xml');			
		}		

		override public function setPermissions(o:Collaborator, p:Permission):void
		{
			super.setPermissionsX(getPermissionsObj(o, p), _baseURL + '/permissions.xml');
		}
		
//		public function setAdminPermissions(o:Collaborator):void
//		{
//			super.setAdmin(getAdminObj(o), _baseURL + '/users/'+o.userId+'.xml');
//		}
		
	// handlers //			
		
		override protected function onLoginSuccess(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var xml:XML = new XML(s);
			var usr:XMLList = xml['user'];
			for (var i:int = 0; i < usr.length(); i++) {
				if (usr[i]['login'] == _account.user) {
					var o:Object = {};
						o.id = usr[i]['id'];
						o.email = usr[i]['email'];
						o.name = usr[i]['first-name']+' '+usr[i]['last-name'];
					_account.loginData = o;	
				}
			}
			super.getRepositories(_baseURL + '/repositories.xml');
		}

		override protected function onRepositories(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var xml:XML = new XML(s);
			var xl:XMLList = xml['repository'];			
			var v:Vector.<Repository> = new Vector.<Repository>(); 
			for (var i:int = 0; i < xl.length(); i++) {
				if (xl[i]['vcs'] == 'git') {
					var url:String = 'git@'+_account.user+'.beanstalkapp.com:/'+xl[i]['name']+'.git';
					v.push(new BeanstalkRepo(xl[i], url));
				}
			}
			_account.repositories = v;
			AppModel.hideLoader();
			dispatchEvent(new AppEvent(AppEvent.LOGIN_SUCCESS, _account));
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			var xml:XML = new XML(s);
			var url:String = 'git@'+_account.acctName+'.beanstalkapp.com:/'+xml.name+'.git';
			_account.addRepository(new BeanstalkRepo(xml, url));
			dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED));
		}
		
	// collaborators //	
		
		override protected function onCollaborators(s:String):void
		{
			var u:XMLList = new XML(s)['user'];
			var v:Vector.<Collaborator> = new Vector.<Collaborator>();
			for (var i:int = 0; i < u.length(); i++) {
				var c:Collaborator = new Collaborator();
					c.userId 	= u[i]['id'];
					c.userName 	= u[i]['login'];
					c.firstName = u[i]['first-name'];
					c.lastName 	= u[i]['last-name'];
					c.userEmail = u[i]['email'];
					c.owner 	= u[i]['owner'] == true;
					c.admin 	= u[i]['admin'] == true;
					c.permissions = new Vector.<Permission>();
				v.push(c);
			}
			_account.collaborators = v;	_index = 0;
			super.getPermissions(_baseURL + '/permissions/'+_account.collaborators[_index].userId+'.xml');
		}
		
		override protected function onCollaboratorAdded(s:String):void
		{	
			var xml:XML = new XML(s);
			if (xml.hasOwnProperty('error')){
				dispatchError(xml.error);
			}	else{
				_collab.userId = xml.id;
				_collab.permissions = new <Permission>[_permission];
				_account.addCollaborator(_collab);
				super.setPermissionsX(getPermissionsObj(_collab, _permission), _baseURL + '/permissions.xml');
			}
		}
		
		override protected function onCollaboratorRemoved(s:String):void
		{	
			if (s.indexOf('HTTP/1.1 200 OK') != -1) {
				_account.killCollaborator(_collab);
				super.dispatchCollaborators();
			}	else{
				var m:String = 'Something went wrong. I was unable to remove collaborator "'+_collab.firstName+' '+_collab.lastName+'". ';
					m+='Please try again in a few moments.';
				dispatchError(m);
			}
		}
		
		override protected function onGetPermissions(s:String):void
		{
			var x:XMLList = new XML(s)['permission'];
			var c:Collaborator = _account.collaborators[_index];
				c.permissions = new Vector.<Permission>();
			for (var i:int = 0; i < _account.repositories.length; i++) {
				var p:Permission = new Permission();
					p.repoId = _account.repositories[i].id;
				if (c.owner || c.admin)	p.read = true;
				if (c.owner || c.admin)	p.write = true;
				for (var k:int = 0; k < x.length(); k++) {
					if (p.repoId == x[k]['repository-id']){
						p.read = x[k]['read'] == true;
						p.write = x[k]['write'] == true;
					}
				}
				c.permissions.push(p);
			}
			if (++_index == _account.collaborators.length) {
				super.dispatchCollaborators();
			}	else{
				super.getPermissions(_baseURL + '/permissions/'+_account.collaborators[_index].userId+'.xml');
			}
		}
		
		override protected function onSetPermissions(s:String):void
		{
			var ok:Boolean;
			var xml:XML = new XML(s);
			if (xml.name() == 'permission'){
				ok = true;
			// weird error we sometimes receive when setting permissions for first time on new user //	
			}	else if (xml['error'][0] == "Mode can't be blank" && xml['error'][1] == "Mode is invalid"){
				ok = true;
			}
			if (ok){
				super.dispatchCollaborators();
			}	else{
				dispatchError(ErrEvent.PERMISSIONS);
			}
		}
		
	// handle beanstalk specific errors //
		
		private function checkForErrors(s:String):Boolean
		{
			if (s.indexOf('<html>') != -1){
				onLoginFailure();
				return true;
			}	else if (s.indexOf('Could\'t authenticate you') != -1){
				onLoginFailure();
				return true;
			}	else if (s.indexOf('API is disabled for this account') != -1){
				dispatchError(ErrEvent.API_DISABLED);
				return true;
			}	else if (s.indexOf('You need admin privileges to access this action') != -1){
				dispatchError(ErrEvent.UNAUTHORIZED);
				return true;
			}	else{
				return false;
			}
		}
		
		private function onLoginFailure():void
		{
			if (_silentLogin){
				dispatchEvent(new AppEvent(AppEvent.LOGIN_FAILURE));
			}	else{
				dispatchError(ErrEvent.LOGIN_FAILURE);	
			}
		}
		
		private function getRepoObj(n:String):String
		{
			var s:String = '';
				s+='<?xml version="1.0" encoding="UTF-8"?>';
				s+='<repository>';
  				s+='<name>'+n+'</name>';
  				s+='<title>'+n+'</title>';
  				s+='<type_id>git</type_id>';
  				s+='<color_label>label-blue</color_label>';
				s+='</repository>';
			return s;
		}
		
		private function getCollabObj(o:Collaborator):String
		{
			var s:String = '';
				s+='<?xml version="1.0" encoding="UTF-8"?>';
				s+='<user>';
  				s+='<first_name>'+o.firstName+'</first_name>';
  				s+='<last_name>'+o.lastName+'</last_name>';
  				s+='<email>'+o.userEmail+'</email>';
  				s+='<login>'+o.userName+'</login>';
  				s+='<password>'+o.passWord+'</password>';
  				s+='<admin>'+(o.admin==true ? 1 : 0)+'</admin>';
				s+='</user>';
			return s;
		}
		
//		private function getAdminObj(o:Collaborator):String
//		{
//			var s:String = '';
//				s+='<?xml version="1.0" encoding="UTF-8"?>';
//				s+='<user>';
//  				s+='<admin>'+(o.admin==true ? 1 : 0)+'</admin>';
//				s+='</user>';
//			return s;			
//		}
		
		private function getPermissionsObj(o:Collaborator, p:Permission):String
		{
			var s:String = '';
				s+='<?xml version="1.0" encoding="UTF-8"?>';
				s+='<permission>';
  				s+='<user-id type="integer">'+o.userId+'</user-id>';
  				s+='<repository-id type="integer">'+_account.repository.id+'</repository-id>';
  				s+='<read type="boolean">'+p.read+'</read>';
  				s+='<write type="boolean">'+p.write+'</write>';
				s+='</permission>';
			return s;			
		}
		
	}
	
}
