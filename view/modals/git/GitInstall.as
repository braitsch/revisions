package view.modals.git {

	public class GitInstall extends GitWindow {

		private static var _view:GitInstallMC = new GitInstallMC();

		public function GitInstall()
		{
			super(_view);
			super.drawBackground(500, 202);
		}
		
		public function promptToInstall():void
		{
			_view.message_txt.text = '';
			_view.message_txt.appendText('Revisions requires the Git library to run correctly.\n');	
			_view.message_txt.appendText('It only takes a second to install. Okay if I add that for you?');	
		}
		
	}
	
}
