package view.modals.remote {

	import events.AppEvent;
	import flash.events.MouseEvent;

	public class BeanstalkHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();

		public function BeanstalkHome()
		{
			super(_view);
			_view.badgePage.label_txt.text = 'My Beanstalk';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
		}
		
		private function onLogOutClick(e:MouseEvent):void
		{
			dispatchEvent(new AppEvent(AppEvent.LOGOUT));
		}	
		
	}
	
}
