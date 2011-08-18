package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import model.proxies.remote.AccountProxy;
	import flash.events.MouseEvent;

	public class BeanstalkHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();
		private static var _proxy		:AccountProxy;

		public function BeanstalkHome(p:AccountProxy)
		{
			super(_view);
			_proxy = p;
			_view.badgePage.label_txt.text = 'My Beanstalk';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
			_proxy.addEventListener(AppEvent.LOGOUT_SUCCESS, onLogout);			
		}
		
		private function onLogOutClick(e:MouseEvent):void
		{
			_proxy.logout();
		}	
		
		private function onLogout(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}	
		
	}
	
}
