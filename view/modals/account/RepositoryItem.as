package view.modals.account {

	import view.ui.Tooltip;
	import events.UIEvent;
	import model.remote.HostingAccount;
	import model.vo.BeanstalkRepo;
	import model.vo.GitHubRepo;
	import model.vo.Repository;
	import view.ui.SmartButton;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class RepositoryItem extends Sprite {

		private var _repo	:Repository;
		private var _view	:RepositoryItemMC = new RepositoryItemMC();

		public function RepositoryItem(o:Repository):void
		{
			_repo = o;
			if (o.acctType == HostingAccount.GITHUB){
				drawGHRepo(o as GitHubRepo);
			}	else if (o.acctType == HostingAccount.BEANSTALK){
				drawBSRepo(o as BeanstalkRepo);
			}
 			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = o.repoName;
			addChild(_view);
			activateButton();
		}

		private function drawGHRepo(o:GitHubRepo):void
		{
			_view.desc_txt.text = o.description;
		}
		
		private function drawBSRepo(o:BeanstalkRepo):void
		{
			_view.desc_txt.text = 'last commit :: '+o.lastCommittedAt;
		}
		
		private function activateButton():void
		{
			_view.clone.over.alpha = 0;
			_view.clone.buttonMode = true;
			_view.clone.addEventListener(MouseEvent.CLICK, onCloneClick);
			_view.clone.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_view.clone.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			_view.collab.over.alpha = 0;
			_view.collab.buttonMode = true;
			_view.collab.addEventListener(MouseEvent.CLICK, onCollabClick);
			_view.collab.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_view.collab.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			new SmartButton(_view.collab, new Tooltip('Collaborators'));
			new SmartButton(_view.clone, new Tooltip('Clone Repository'));
		}
		
		private function onCloneClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.LOGGED_IN_CLONE, _repo.url));
		}
		
		private function onCollabClick(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.MANAGE_COLLABORATORS, _repo));
		}		
		
		private function onButtonRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		private function onButtonRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}			
		
	}
	
}
