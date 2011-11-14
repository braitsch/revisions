package model.remote {

	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.acct.KeyProxy;
	import view.windows.account.base.AccountBase;
	import view.windows.base.ParentWindow;
	public interface IHostingService {
		
		function get type()			:String			
		function get api()			:ApiProxy 			
		function get key()			:KeyProxy 			
		function get home()			:AccountBase
		function get login()		:ParentWindow 	
		function get addRepoObj()	:Object				
		
	}
}
