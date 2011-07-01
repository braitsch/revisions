package view.modals {

	import model.AppModel;
	import system.SystemRules;

	public class GitUpgrade extends GitWindow {

		private static var _view:GitUpgradeMC = new GitUpgradeMC();

		public function GitUpgrade()
		{
			super(_view);
		}
		
		public function promptToUpgrade():void
		{
			_view.message_txt.text = '';			
			var v:String = AppModel.proxies.config.gitVersion;
			var i:String = AppModel.proxies.config.gitInstall;
			var n:String = super.checkForPackageInstaller();
			if (n){
				_view.message_txt.appendText('I see you have Git '+v+' installed at '+i+'\n');
				_view.message_txt.appendText('This looks like a '+n+' install.\n');
				_view.message_txt.appendText('Revisions requires version '+SystemRules.MIN_GIT_VERSION+'\n');
				_view.message_txt.appendText('Would you like me to try to upgrade for you?');
			}	else{
				_view.message_txt.appendText('I need to update your Git version of '+v+' to ');
				_view.message_txt.appendText(SystemRules.MIN_GIT_VERSION+'\nIs that OK?\n');
				_view.message_txt.appendText('It should only take a few seconds.');
			}
		}
		
	}
	
}