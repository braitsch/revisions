package view.modals.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.remote.acct.BeanstalkApi;
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
			var l:Array = ['Admin', 'Read & Write', 'Read Only'];
			for (var i:int = 0; i < 3; i++) {
				var r:AccountRadio = new AccountRadio(false);
				r.y = 8.5;
				r.label = l[i];
				_radios.push(r);
				if (i == 0){
					r.x = 180;
				}	else{
					r.x = _radios[i-1].x + _radios[i-1].width + 7;
				}
				_view.addChild(r);
			}
			addEventListener(UIEvent.RADIO_SELECTED, onRadioSelected);
		}

		private function onRadioSelected(e:UIEvent):void
		{
			for (var i:int = 0; i < 3; i++) {
				if (e.target == _radios[i]) {
					switch(i){
						case 0 : setAdminPermissions(_radios[i].selected);
						break;
						case 1 : setWritePermissions(true);
						break;
						case 2 : setWritePermissions(false);
					}
				}	else{
					_radios[i].selected = false;
				}
			}
		}

		private function setAdminPermissions(on:Boolean):void
		{
			trace("CollaboratorBS.setAdminPermissions(on) - setting admin to ", on);
			_collab.admin = on;
			BeanstalkApi(Hosts.beanstalk.api).setAdminPermissions(_collab);
		}
		
		private function setWritePermissions(on:Boolean):void
		{
			trace("CollaboratorBS.setWritePermissions(on) - write perms = ", on);
		}

		private function showPermissions():void
		{
			if (_collab.admin == true) {
				_radios[0].selected = true;
			}	else{
				var p:Array = _collab.permissions;
				for (var i:int = 0; i < _collab.permissions.length; i++) {
					if (p[i]['repository-id'] == _repoId){
						if (p[i]['read'] == true){
							if (p[i]['write'] == true){
								_radios[1].selected = true;	
							}	else{
								_radios[2].selected = true;
							}
						}
					}
				}
			}
		}

		private function attachAvatar():void
		{
			var a:Avatar = new Avatar(_collab.avatarURL);
				a.y = 5;
				a.x = 10; 
			_view.addChild(a);
		}
		
		private function onKillCollaborator(e:MouseEvent):void
		{
			var m:String = 'Support for deleting collaborators is not quite there yet.';
			m+='We\'re working on resolving issues with Beanstalk\'s API and should have this up and running soon.';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
		//	dispatchEvent(new UIEvent(UIEvent.KILL_COLLABORATOR, _collab));
		}
		
	}
	
}
