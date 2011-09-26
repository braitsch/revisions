package view.windows.account {

	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.vo.Collaborator;
	import view.avatars.Avatar;
	import view.avatars.Avatars;

	public class CollaboratorItemGH extends Sprite {

		private var _collab	:Collaborator;
		private var _view	:GitHubCollaborator = new GitHubCollaborator();

		public function CollaboratorItemGH(o:Collaborator)
		{
			_collab = o;	
			_view.label.text = _collab.userName;
			addChild(_view);
			attachAvatar();
			showKillButton();
		}

		private function attachAvatar():void
		{
			var a:Avatar = Avatars.getAvatar(_collab.avatarURL);
				a.x = a.y = 6;
			_view.addChild(a);
		}
		
		private function showKillButton():void
		{
			if (_collab.admin){
				_view.close.visible = false;
			}	else{
				_view.close.buttonMode = true;
				_view.close.addEventListener(MouseEvent.CLICK, onKillCollaborator);
			}		
		}

		private function onKillCollaborator(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.KILL_COLLABORATOR, _collab));
		}
		
	}
	
}
