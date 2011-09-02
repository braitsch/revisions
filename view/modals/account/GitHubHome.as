package view.modals.account {


	import model.remote.Hosts;
	import flash.events.MouseEvent;
	public class GitHubHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();

		public function GitHubHome()
		{
			super(_view);
			_view.badgePage.label_txt.text = 'My Github';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
		}
		
		override protected function onLogOutClick(e:MouseEvent):void
		{
			super.onLogOutClick(e);
			Hosts.github.logOut();
		}

	}
	
}
