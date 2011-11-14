package view.windows.account.beanstalk {

	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.windows.account.base.AccountBase;
	import view.windows.account.base.RepositoryView;
	import flash.events.MouseEvent;

	public class BSAcctView extends AccountBase {

	// account-pages //	
		private static var _viewRepos		:RepositoryView = new RepositoryView();
		private static var _viewCollabs		:BSCollabView = new BSCollabView();
		private static var _addCollab		:BSAddCollab = new BSAddCollab();

		public function BSAcctView()
		{
			super.setHeading('My Beanstalk');
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
			Hosts.beanstalk.logOut();
			super.onLogOutClick(e);
		}
		
	}
	
}