package view.windows.modals.git {

	public class GitInstall extends GitWindow {

		private static var _view:GitInstallMC = new GitInstallMC();

		public function GitInstall()
		{
			super(_view);
			super.title = 'Install Git';
			super.drawBackground(550, 230);
		}
		
		public function promptToInstall():void
		{
			_view.textArea.message_txt.text = '';
			_view.textArea.message_txt.appendText('Revisions requires the Git library to run correctly.\n');	
			_view.textArea.message_txt.appendText('It only takes a second to install. Okay if I add that for you?');	
		}
		
	}
	
}
