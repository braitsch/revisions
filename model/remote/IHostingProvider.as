package model.remote {

	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.keys.KeyProxy;
	import view.windows.account.AccountHome;
	import view.windows.base.ParentWindow;
	public interface IHostingProvider {
		
		function get type()			:String			
		function get api()			:ApiProxy 			
		function get key()			:KeyProxy 			
		function get home()			:AccountHome		
		function get login()		:ParentWindow 	
		function get addRepoObj()	:Object				
		
	}
}
