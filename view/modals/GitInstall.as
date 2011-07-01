package view.modals {

	public class GitInstall extends GitWindow {

		public function GitInstall()
		{
			attachBadge(new GitInstallBadge());			
		}
		
		public function promptToInstall():void
		{
			super.view.message_txt.appendText('Revisions requires the Git library to run correctly.\n');	
			super.view.message_txt.appendText('It only takes a second to install. Okay if I add that for you?');	
		}
		
	}
	
}
