package view.modals.remote {

	import model.AppModel;

	public class AddGitHubRepo extends RemoteRepo {

		public function AddGitHubRepo()
		{
			super.drawBackground(550, 210);
			super.proxy = AppModel.proxies.githubApi;
		}
		
//			var m:String = 'This bookmark is already associated with a GitHub account.\n';
//				m+='Name : '+g.name+'\n';
//				m+='Url : '+g.fetch+'\n';
//			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));							
		
	}
	
}
