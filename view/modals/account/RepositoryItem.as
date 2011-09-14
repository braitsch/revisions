package view.modals.account {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import model.vo.BeanstalkRepo;
	import model.vo.GitHubRepo;
	import model.vo.Repository;
	import view.ui.BasicButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class RepositoryItem extends Sprite {

		private var _repo	:Repository;
		private var _view	:RepositoryItemMC = new RepositoryItemMC();
		private var _clone	:BasicButton = new BasicButton(_view.clone, 'Clone Repository');
		private var _collab	:BasicButton = new BasicButton(_view.collab, 'Collaborators');

		public function RepositoryItem(o:Repository):void
		{
			_repo = o;
			addChild(_view);
			if (o.acctType == HostingAccount.GITHUB){
				drawGHRepo(o as GitHubRepo);
			}	else if (o.acctType == HostingAccount.BEANSTALK){
				drawBSRepo(o as BeanstalkRepo);
			}
 			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = o.repoName;
			_clone.addEventListener(MouseEvent.CLICK, onCloneClick);
			_collab.addEventListener(MouseEvent.CLICK, onCollabClick);
		}
		
		private function drawGHRepo(o:GitHubRepo):void
		{
			_view.desc_txt.text = o.description;
		}
		
		private function drawBSRepo(o:BeanstalkRepo):void
		{
			_view.desc_txt.text = 'last commit :: '+o.lastCommittedAt;
		}
		
		private function onCloneClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.LOGGED_IN_CLONE, _repo.url));
		}
		
		private function onCollabClick(e:MouseEvent):void
		{
			AccountView.repository = _repo;
			dispatchEvent(new UIEvent(UIEvent.GET_COLLABORATORS));
		}
		
	}
	
}
