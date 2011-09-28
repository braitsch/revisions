package view.windows.account {

	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import model.vo.GitHubRepo;
	import model.vo.Repository;
	import system.StringUtils;
	import view.btns.IconButton;

	public class RepositoryItem extends Sprite {

		private var _repo	:Repository;
		private var _view	:RepositoryItemMC = new RepositoryItemMC();
		private var _clone	:IconButton = new IconButton(_view.clone, 'Clone Repository');
		private var _collab	:IconButton = new IconButton(_view.collab, 'Collaborators');
	
		public function RepositoryItem(o:Repository):void
		{
			_repo = o;
			addChild(_view);
 			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = o.repoName;
			_view.desc_txt.text = 'last commit :: '+StringUtils.parseISO8601Date(o.lastUpdated).toLocaleString();
			_clone.addEventListener(MouseEvent.CLICK, onCloneClick);
			if (o.acctType == HostingAccount.GITHUB) checkIfOwner();
			if (_collab.enabled) _collab.addEventListener(MouseEvent.CLICK, onCollabClick);
		}

		private function checkIfOwner():void
		{
			_collab.enabled = GitHubRepo(_repo).owner==Hosts.github.loggedIn.user;
		}
		
		private function onCloneClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.LOGGED_IN_CLONE, _repo.url));
		}
		
		private function onCollabClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.GET_COLLABORATORS, _repo));
		}
		
	}
	
}
