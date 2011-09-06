package model.proxies.remote.acct {

	import events.AppEvent;
	import events.ErrorType;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.BookmarkRemote;

	public class BeanstalkApi extends ApiProxy {

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
		
	// handlers //			
		
		override protected function onLoginSuccess(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var xml:XML = new XML(s);
			var usr:XMLList = xml['user'];
			for (var i:int = 0; i < usr.length(); i++) {
				if (usr['login'] == super.account.user) {
					var o:Object = {};
						o.id = usr['id'];
						o.email = usr['email'];
						o.name = usr['first-name']+' '+usr['last-name'];
					super.account.loginData = o;	
				}
			}
			super.getRepositories('/repositories.xml');
		}
		
		override protected function onRepositories(s:String):void
		{
			if (checkForErrors(s) == true) return;
			var a:Array = [];
			var xml:XML = new XML(s);
			var xl:XMLList = xml['repository'];			
			for (var i:int = 0; i < xl.length(); i++) {
				if (xl[i]['vcs'] == 'git') {
					xl[i]['https_url'] = 'git@'+super.account.user+'.beanstalkapp.com:/'+xl[i]['name']+'.git';
					a.push(xl[i]);
				}
			}
			super.account.repositories = a;
			dispatchLoginSuccess();
		}
		
		override protected function onRepositoryCreated(s:String):void
		{
			var xml:XML = new XML(s);
			var url:String = 'git@'+super.account.acct+'.beanstalkapp.com:/'+xml.name+'.git';
			Hosts.beanstalk.home.addRepository(xml);
			dispatchEvent(new AppEvent(AppEvent.REPOSITORY_CREATED, new BookmarkRemote(HostingAccount.BEANSTALK+'-'+xml.name, url)));
		}
		
	// handle beanstalk specific errors //
		
		private function checkForErrors(s:String):Boolean
		{
			if (s.indexOf('<html>') != -1){
				dispatchFailure(ErrorType.LOGIN_FAILURE);
				return true;
			}	else if (s.indexOf('Could\'t authenticate you') != -1){
				dispatchFailure(ErrorType.LOGIN_FAILURE);
				return true;
			}	else if (s.indexOf('API is disabled for this account') != -1){
				dispatchFailure(ErrorType.API_DISABLED);
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
		
	}
	
}
