package model.proxies.remote.acct {

	import events.AppEvent;
	import events.ErrEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.BeanstalkRepo;
	import model.vo.Collaborator;

	public class BeanstalkApi extends ApiProxy {
		
		private static var _index		:uint;
		private static var _users		:XMLList;
		private static var _collab		:Collaborator;

		public function BeanstalkApi()
		{
			super.executable = 'Beanstalk.sh';
		}

	// public methods //

		override public function login(ra:HostingAccount):void
		{
			super.login(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@'+ra.acctName+'.beanstalkapp.com/api';
			super.loginToAccount('/users.xml');
		}
		
		override public function addRepository(o:Object):void
		{
			super.addRepositoryToAccount(HEADER_XML, getRepoObj(o.name), '/repositories.xml');
		}
		
		override public function getCollaborators():void
		{
			super.getCollaboratorsOfRepo('/users.xml');
		}						
		
		override public function addCollaborator(o:Collaborator):void
		{
			_collab = o;
			super.addCollaboratorToBeanstalk(HEADER_XML, getCollabObj(_collab), '/users.xml');
		}
		
		override public function setPermissions(o:Collaborator):void
		{
			super.setCollaboratorPermissions(HEADER_XML, getPermissionsObj(o), '/permissions.xml');
		}
		
//		public function setAdminPermissions(o:Collaborator):void
//		{
//			super.setAdmin(HEADER_XML, getAdminObj(o), '/users/'+o.userId+'.xml');
//		}
		
		override public function killCollaborator(o:Collaborator):void
		{
			_collab = o;
			super.killCollaboratorFromRepo('/users/'+o.userId+'.xml');
		}				
		
	// handlers //			
		
		override protected function onLoginSuccess(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var xml:XML = new XML(s);
			var usr:XMLList = xml['user'];
			for (var i:int = 0; i < usr.length(); i++) {
				if (usr[i]['login'] == super.account.user) {
					var o:Object = {};
						o.id = usr[i]['id'];
						o.email = usr[i]['email'];
						o.name = usr[i]['first-name']+' '+usr[i]['last-name'];
					super.account.loginData = o;	
				}
			}
			super.getRepositories('/repositories.xml');
		}
		
		override protected function onRepositories(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var xml:XML = new XML(s);
			var xl:XMLList = xml['repository'];			
			for (var i:int = 0; i < xl.length(); i++) {
				if (xl[i]['vcs'] == 'git') {
					var url:String = 'git@'+super.account.user+'.beanstalkapp.com:/'+xl[i]['name']+'.git';
					super.account.addRepository(new BeanstalkRepo(xl[i], url));
				}
			}
			Hosts.beanstalk.loggedIn = super.account;
			dispatchLoginSuccess();
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			var xml:XML = new XML(s);
			var url:String = 'git@'+super.account.acctName+'.beanstalkapp.com:/'+xml.name+'.git';
			super.account.addRepository(new BeanstalkRepo(xml, url));
			dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED));
		}
		
		override protected function onCollaborators(s:String):void
		{
			_users = new XML(s)['user']; _index = 0;
			super.getCollaboratorsPermissions('/permissions/'+_users[_index]['id']+'.xml');
		}
		
		override protected function onGetPermissions(s:String):void
		{
			var xml:XML = new XML(s); 
			_users[_index].appendChild(xml);
			if (++_index == _users.length()) {
				parseCollaborators();
			}	else{
				super.getCollaboratorsPermissions('/permissions/'+_users[_index]['id']+'.xml');
			}
		}
		
		override protected function onSetPermissions(s:String):void
		{
			var ok:Boolean;
			var xml:XML = new XML(s);
			trace('xml: ' + (xml));
			if (xml.name() == 'permission'){
				ok = true;
			// weird error we sometimes receive when setting permissions for first time on new user //	
			}	else if (xml['error'][0] == "Mode can't be blank" && xml['error'][1] == "Mode is invalid"){
				ok = true;
			}
			if (ok){
				super.dispatchCollaborators();
			}	else{
				dispatchFailure('Whoops, something went wrong. Failed to update user permissions.');
			}
		}
		
		private function parseCollaborators():void
		{
			var v:Vector.<Collaborator> = new Vector.<Collaborator>();
			for (var i:int = 0; i < _users.length(); i++) {
				var c:Collaborator = new Collaborator();
					c.userId = _users[i]['id'];
					c.userName = _users[i]['login'];
					c.firstName = _users[i]['first-name'];
					c.lastName = _users[i]['last-name'];
					c.userEmail = _users[i]['email'];
					c.owner = _users[i]['owner'] == true;
					c.admin = _users[i]['admin'] == true;
					var p:XMLList = _users[i]['permissions']['permission'];
				for (var k:int = 0; k < p.length(); k++) c.permissions.push(p[k]);
				v.push(c);
			}
			super.account.collaborators = v;
			super.dispatchCollaborators();
		}
		
		override protected function onCollaboratorAdded(s:String):void
		{	
			var xml:XML = new XML(s);
			if (xml.hasOwnProperty('error')){
				dispatchFailure(xml.error);
			}	else{
				_collab.userId = xml.id;
				super.setCollaboratorPermissions(HEADER_XML, getPermissionsObj(_collab), '/permissions.xml');
			}
		}
		
		override protected function onCollaboratorRemoved(s:String):void
		{	
			var xml:XML = new XML(s);
			trace("BeanstalkApi.onCollaboratorRemoved(s)", xml);
			super.dispatchCollaborators();
		}			
		
	// handle beanstalk specific errors //
		
		private function checkForErrors(s:String):Boolean
		{
			if (s.indexOf('<html>') != -1){
				dispatchFailure(ErrEvent.LOGIN_FAILURE);
				return true;
			}	else if (s.indexOf('Could\'t authenticate you') != -1){
				dispatchFailure(ErrEvent.LOGIN_FAILURE);
				return true;
			}	else if (s.indexOf('API is disabled for this account') != -1){
				dispatchFailure(ErrEvent.API_DISABLED);
				return true;
			}	else{
				return false;
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
		
		private function getPermissionsObj(o:Collaborator):String
		{
			var s:String = '';
				s+='<?xml version="1.0" encoding="UTF-8"?>';
				s+='<permission>';
  				s+='<user-id type="integer">'+o.userId+'</user-id>';
  				s+='<repository-id type="integer">'+super.account.repository.id+'</repository-id>';
  				s+='<read type="boolean">'+o.read+'</read>';
  				s+='<write type="boolean">'+o.write+'</write>';
				s+='</permission>';
			return s;			
		}
		
	}
	
}
