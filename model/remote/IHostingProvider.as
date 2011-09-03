package model.remote {

	import model.proxies.remote.acct.ApiProxy;
	import model.proxies.remote.keys.KeyProxy;
	import view.modals.account.AccountHome;
	import view.modals.base.ModalWindow;
	public interface IHostingProvider {
		
		function get type()			:String			
		function get api()			:ApiProxy 			
		function get key()			:KeyProxy 			
		function get home()			:AccountHome		
		function get login()		:ModalWindow 	
		function get addRepoObj()	:Object				
		
	}
}
