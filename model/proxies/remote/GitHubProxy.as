package model.proxies.remote {

	import model.proxies.remote.AccountProxy;

	public class GitHubProxy extends AccountProxy {

		public function GitHubProxy()
		{
			super.executable = 'GitHubLogin.sh';
		}
		
	}
	
}
