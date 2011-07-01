package view.modals {

	import model.AppModel;
	import system.SystemRules;

	public class GitUpgrade extends GitWindow {

		public function GitUpgrade()
		{
			attachBadge(new GitUpdateBadge());
		}
		
		public function promptToUpgrade():void
		{
			var v:String = AppModel.proxies.config.gitVersion;
			var i:String = AppModel.proxies.config.gitInstall;
			var n:String = super.checkForPackageInstaller();
			if (n){
				super.view.message_txt.appendText('I see you have Git '+v+' installed at '+i+'\n');
				super.view.message_txt.appendText('This looks like a '+n+' install.\n');
				super.view.message_txt.appendText('Revisions requires version '+SystemRules.MIN_GIT_VERSION+'\n');
				super.view.message_txt.appendText('Would you like me to try to upgrade for you?');
			}	else{
				super.view.message_txt.appendText('I need to update your Git version of '+v+' to ');
				super.view.message_txt.appendText(SystemRules.MIN_GIT_VERSION+'\nIs that OK?');			
			}
		}
		
	}
	
}
