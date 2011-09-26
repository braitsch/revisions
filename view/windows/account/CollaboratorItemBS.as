package view.windows.account {

	import events.AppEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.vo.Collaborator;
	import model.vo.Permission;
	import view.avatars.Avatar;
	import view.avatars.Avatars;
	import view.ui.AccountRadio;
	import view.ui.BasicButton;
	import view.windows.modals.system.Message;

	public class CollaboratorItemBS extends Sprite {

		private var _collab		:Collaborator;
		private var _view		:*;
		private var _repoId		:uint;
		private var _radios		:Vector.<AccountRadio>;
		private var _permission	:Permission;

		public function CollaboratorItemBS(o:Collaborator, n:uint)
		{
			_collab = o; _repoId = n;
			attachView();
			attachAvatar();
		}
		
		public function hasWriteAccess():Boolean
		{
			if (_collab.owner){
				return true;
			}	else{
				return _permission.write;
			}
		}

		private function attachView():void
		{
			if (_collab.owner){
				_view = new BeanstalkOwner();
			}	else{
				_view = new BeanstalkRegular();
				new BasicButton(_view.kill);
				attachRadios();
				showPermissions();	
				_view.kill.addEventListener(MouseEvent.CLICK, onKillCollaborator);
			}
			_view.label.text = _collab.firstName +' '+_collab.lastName;
			addChild(_view);
		}
		
		private function attachRadios():void
		{
			_radios = new Vector.<AccountRadio>();
			var l:Array = ['Read & Write', 'Read Only', 'No Access'];
			for (var i:int = 0; i < 3; i++) {
				var r:AccountRadio = new AccountRadio(false);
				r.y = 8.5;
				r.label = l[i];
				_radios.push(r);
				if (i == 0){
					r.x = 165;
				}	else{
					r.x = _radios[i-1].x + _radios[i-1].width + 5;
				}
				_view.addChild(r);
			}
			addEventListener(UIEvent.RADIO_SELECTED, onRadioSelected);
		}

		private function onRadioSelected(e:UIEvent):void
		{
			if (_collab.admin == false) {
				for (var i:int = 0; i < 3; i++) {
					if (e.target == _radios[i]) {
						setWritePermissions(i);
						_radios[i].selected = true;
					}	else{
						_radios[i].selected = false;
					}
				}
			}	else{
				var m:String = _collab.firstName+' '+_collab.lastName+' has adminstrator privledges.\n';
					m+='This means they have full access to all of you repositories.\n';
					m+='Please login to your account online if you\'d like to change this.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));				
			}
		}

		private function setWritePermissions(n:uint):void
		{
			switch(n){
				case 0 : 
					_permission.read = true;
					_permission.write = true;
				break;
				case 1 : 
					_permission.read = true;
					_permission.write = false;
				break;
				case 2 : 
					_permission.read = false;
					_permission.write = false;
				break;
			}
			Hosts.beanstalk.api.setPermissions(_collab, _permission);
		}

		private function showPermissions():void
		{
			var p:Vector.<Permission> = _collab.permissions;
			for (var i:int = 0; i < p.length; i++) {
				if (p[i].repoId == _repoId){
					_permission = p[i];
					if (_permission.read == true){
						if (_permission.write == true){
							_radios[0].selected = true;	
						}	else{
							_radios[1].selected = true;
						}
					}	else{
						_radios[2].selected = true; // no access //			
					}
				}
			}
		}

		private function attachAvatar():void
		{
			var a:Avatar = Avatars.getAvatar(_collab.userEmail);
				a.y = 5;
				a.x = 10; 
			_view.addChild(a);
		}
		
		private function onKillCollaborator(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.KILL_COLLABORATOR, _collab));
		}
		
	}
	
}
