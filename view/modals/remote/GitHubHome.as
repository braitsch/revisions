package view.modals.remote {


	public class GitHubHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();

		public function GitHubHome()
		{
			super(_view);
			_view.badgePage.label_txt.text = 'My Github';
		}

	}
	
}
