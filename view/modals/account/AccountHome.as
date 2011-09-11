package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.Repository;
	import view.modals.base.ModalWindow;
	import view.modals.system.Message;
	import flash.events.MouseEvent;

	public class AccountHome extends ModalWindow {

		private var _view			:AccountHomeMC = new AccountHomeMC();	
		private var _model			:HostingAccount;
		private var _repos			:RepositoryView = new RepositoryView();
		private var _logOut			:LogOutBtn = new LogOutBtn();

		public function AccountHome()
		{
			addChild(_view);
			addChild(_repos);
			addChild(_logOut);
			super.addCloseButton();
			super.addButtons([_logOut]);
			super.drawBackground(590, 420);
			_repos.x = 10; _repos.y = 68;
			_logOut.x = 526; _logOut.y = 380;
			_logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
			addEventListener(UIEvent.MANAGE_COLLABORATORS, onManageCollaborators);
		}

		public function set model(r:HostingAccount):void
		{
			_model = r;
			attachAvatar();
			refreshUserInfo();
			_repos.attachRepositories(_model.repositories);
			_view.badgePage.label_txt.text = _model.type == HostingAccount.GITHUB ? 'My Github' : 'My Beanstalk';
		}
		
		public function addRepository(o:Repository):void
		{
			_model.repositories.push(o);
			_repos.attachRepositories(_model.repositories);
		}
		
		private function attachAvatar():void
		{
			_model.avatar.y = 7; 
			_model.avatar.x = -190;
			_view.badgeUser.addChild(_model.avatar);
		}
		
		private function refreshUserInfo():void
		{
			_view.badgeUser.user_txt.text = _model.fullName ? _model.fullName : '';
			if (_model.fullName && _model.location) _view.badgeUser.user_txt.appendText(' - '+_model.location);			
		}
		
		private function onManageCollaborators(e:UIEvent):void
		{
			trace("AccountHome.onManageCollaborators(e)", Repository(e.data).repoName);	
		}		
		
		private function onLogOutClick(e:MouseEvent):void
		{
			_model.type == HostingAccount.GITHUB ? Hosts.github.logOut() : Hosts.beanstalk.logOut();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('You Have Successfully Logged Out.')));
		}			

	}
	
}
