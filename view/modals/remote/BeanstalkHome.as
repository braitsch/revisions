package view.modals.remote {


	public class BeanstalkHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();

		public function BeanstalkHome()
		{
			super(_view);
			_view.badgePage.label_txt.text = 'My Beanstalk';
		}
		
	}
	
}
