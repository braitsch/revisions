package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;
	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;

	public class GitHubHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();
		private static var _proxy		:ApiProxy;

		public function GitHubHome(p:ApiProxy)
		{
			super(_view);
			_proxy = p;
			_view.badgePage.label_txt.text = 'My Github';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
			_proxy.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);	
			_proxy.addEventListener(AppEvent.LOGOUT_SUCCESS, onLogoutSuccess);	
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			super.model = e.data as HostingAccount;
		}
		
		private function onLogOutClick(e:MouseEvent):void
		{
			_proxy.logout();
		}	
		
		private function onLogoutSuccess(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}			
		
	}
	
}
