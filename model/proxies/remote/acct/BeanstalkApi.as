package model.proxies.remote.acct {

	import events.AppEvent;
	import events.ErrEvent;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.BeanstalkRepo;
	import model.vo.Collaborator;
	import model.vo.Repository;

	public class BeanstalkApi extends ApiProxy {
		
		private static var _index		:uint;
		private static var _users		:XMLList;
		private static var _collab		:Collaborator;
		private static var _repository	:BeanstalkRepo;

	// public methods //

		override public function login(ra:HostingAccount):void
		{
			super.login(ra);
			super.baseURL = 'https://'+ra.user+':'+ra.pass+'@'+ra.acct+'.beanstalkapp.com/api';
			super.loginToAccount('/users.xml');
		}
		
		override public function addRepository(o:Object):void
		{
			super.addRepositoryToAccount(HEADER_XML, getRepoObj(o.name), '/repositories.xml');
		}
		
		override public function addCollaborator(o:Collaborator, r:Repository):void
		{
			_collab = o; _repository = r as BeanstalkRepo;
			super.addCollaboratorToBeanstalk(HEADER_XML, getCollabObj(_collab), '/users.xml');
		}	
		
		override public function getCollaborators(r:Repository):void
		{
			_repository = r as BeanstalkRepo;
			super.getCollaboratorsOfRepo('/users.xml');
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
			dispatchLoginSuccess();
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			var xml:XML = new XML(s);
			var url:String = 'git@'+super.account.acct+'.beanstalkapp.com:/'+xml.name+'.git';
			var rpo:BeanstalkRepo = new BeanstalkRepo(xml, url);
			Hosts.beanstalk.home.addRepository(rpo);
			dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, rpo));
		}
		
		override protected function onCollaborators(s:String):void
		{
			_users = new XML(s)['user']; _index = 0;
			trace('id=', _users[_index]['id']);
			super.getCollaboratorsPermissions('/permissions/'+_users[_index]['id']+'.xml');
		}
		
		override protected function onGetPermissions(s:String):void
		{
			var xml:XML = new XML(s); 
			trace("BeanstalkApi.onPermissions(s)", xml);
			if (++_index < _users.length()) super.getCollaboratorsPermissions('/permissions/'+_users[_index]['id']+'.xml');
		}
		
		override protected function onCollaboratorAdded(s:String):void
		{	
			var xml:XML = new XML(s);
			if (xml.hasOwnProperty('error')){
				dispatchFailure(xml.error);
			}	else{
				_collab.userId = xml.id;
				super.setCollaboratorPermissions(HEADER_XML, getPermissionsObj(_collab, _repository), '/permissions.xml');
			}
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
				s+='</user>';
			return s;			
		}
		
		private function getPermissionsObj(o:Collaborator, r:BeanstalkRepo):String
		{
			var s:String = '';
				s+='<?xml version="1.0" encoding="UTF-8"?>';
				s+='<permission>';
  				s+='<user-id>'+o.userId+'</user-id>';
  				s+='<repository-id>'+r.id+'</repository-id>';
  				s+='<write>'+o.readWrite+'</write>';
				s+='</permission>';
			trace("BeanstalkApi.getPermissionsObj(o) >>", s);	
			return s;			
		}
		
	}
	
}
