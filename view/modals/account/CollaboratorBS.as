package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.vo.Avatar;
	import model.vo.Collaborator;
	import view.modals.system.Message;
	import view.ui.AccountRadio;
	import view.ui.BasicButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CollaboratorBS extends Sprite {

		private var _collab		:Collaborator;
		private var _view		:*;
		private var _repoId		:uint;
		private var _radios		:Vector.<AccountRadio> = new Vector.<AccountRadio>();

		public function CollaboratorBS(o:Collaborator, n:uint)
		{
			_collab = o; _repoId = n;
			attachView();
			attachAvatar();
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
					_collab.read = true;
					_collab.write = true;
				break;
				case 1 : 
					_collab.read = true;
					_collab.write = false;
				break;
				case 2 : 
					_collab.read = false;
					_collab.write = false;
				break;								
			}
			Hosts.beanstalk.api.setPermissions(_collab);
		}

		private function showPermissions():void
		{
			if (_collab.admin == true) {
				_radios[0].selected = true;
			}	else{
				var p:Array = _collab.permissions;
				for (var i:int = 0; i < p.length; i++) {
					if (p[i]['repository-id'] == _repoId){
						if (p[i]['read'] == true){
							if (p[i]['write'] == true){
								_radios[0].selected = true;	
							}	else{
								_radios[1].selected = true;
							}
						}
					}
				}
				if (_radios[0].selected == false && _radios[1].selected == false) _radios[2].selected = true; // no access //
			}
		}

		private function attachAvatar():void
		{
			var a:Avatar = new Avatar(_collab.userEmail);
				a.y = 5;
				a.x = 10; 
			_view.addChild(a);
		}
		
		private function onKillCollaborator(e:MouseEvent):void
		{
			var m:String = 'Support for deleting collaborators is not quite there yet.\n';
			m+='We\'re working on resolving some issues with Beanstalk\'s API and should have this up and running soon.';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
		//	dispatchEvent(new UIEvent(UIEvent.KILL_COLLABORATOR, _collab));
		}
		
	}
	
}
