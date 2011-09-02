package view.modals.account {


	import model.remote.Hosts;
	import flash.events.MouseEvent;
	public class BeanstalkHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();

		public function BeanstalkHome()
		{
			super(_view);
			_view.badgePage.label_txt.text = 'My Beanstalk';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
		}
		
		override protected function onLogOutClick(e:MouseEvent):void
		{
			super.onLogOutClick(e);
			Hosts.beanstalk.logOut();
		}			
		
	}
	
}
