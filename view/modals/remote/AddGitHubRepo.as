package view.modals.remote {

	import model.remote.Accounts;

	public class AddGitHubRepo extends AddRemoteRepo {

		public function AddGitHubRepo()
		{
			super.drawBackground(550, 210);
			super.proxy = Accounts.github.proxy.repo;
			super.view.pageBadge.label_txt.text = 'Add To Github';			
		}
		
//			var m:String = 'This bookmark is already associated with a GitHub account.\n';
//				m+='Name : '+g.name+'\n';
//				m+='Url : '+g.fetch+'\n';
//			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));							
		
	}
	
}
