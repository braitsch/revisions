package view.modals.account {

	import events.UIEvent;
	import model.remote.Hosts;
	import model.vo.Avatar;
	import model.vo.Collaborator;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CollaboratorItem extends Sprite {

		private var _data	:Collaborator;
		private var _view	:CollaboratorMC = new CollaboratorMC();

		public function CollaboratorItem(o:Collaborator)
		{
			_data = o;	
			_view.label.text = _data.userName;
			addChild(_view);
			attachAvatar();
			attachCloseButton();
		}

		public function get collaborator():Collaborator
		{
			return _data;
		}	
		
		private function attachAvatar():void
		{
			var a:Avatar = new Avatar(_data.avatarURL);
				a.x = a.y = 6;
			_view.addChild(a);
		}
		
		private function attachCloseButton():void
		{
			if (_data.userName == Hosts.github.loggedIn.user){
				_view.close.visible = false;
			}	else{
				_view.close.buttonMode = true;
				_view.close.addEventListener(MouseEvent.CLICK, onKillCollaborator);			
			}
		}

		private function onKillCollaborator(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.KILL_COLLABORATOR));
		}
		
	}
	
}
