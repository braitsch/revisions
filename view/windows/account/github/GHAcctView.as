package view.windows.account.github {

	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.windows.account.base.AccountBase;
	import view.windows.account.base.RepositoryView;
	import flash.events.MouseEvent;

	public class GHAcctView extends AccountBase {

	// account-pages //	
		private static var _viewRepos		:RepositoryView = new RepositoryView();
		private static var _viewCollabs		:GHCollabView = new GHCollabView();
		private static var _addCollab		:GHAddCollab = new GHAddCollab();

		public function GHAcctView()
		{
			super.setHeading('My Github');
			super.setViews(_viewRepos, _viewCollabs, _addCollab);
		}
		
		override public function set account(a:HostingAccount):void
		{
			_viewRepos.account = _viewCollabs.account = _addCollab.account = a;
			_viewRepos.reset();
			super.account = a;
		}
		
		override protected function onLogOutClick(e:MouseEvent):void
		{
			Hosts.github.logOut();
			super.onLogOutClick(e);
		}
		
	}
	
}
