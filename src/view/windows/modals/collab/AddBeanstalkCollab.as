package view.windows.modals.collab {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import model.vo.Collaborator;
	import model.vo.Permission;
	import system.StringUtils;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import view.windows.modals.system.Debug;
	import view.windows.modals.system.Message;
	import com.adobe.crypto.MD5;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class AddBeanstalkCollab extends Sprite {

		private var _form				:Form;
		private var _check				:ModalCheckbox = new ModalCheckbox(true);
		private var _message			:String = '(optional) we\'ll use their last name if you leave this blank.';
		private var _urlLoader			:URLLoader;
		private var _collab				:Collaborator = new Collaborator();	

		public function AddBeanstalkCollab(w:uint)
		{
			_form = new Form(w);
			_form.labelWidth = 90;
			_form.fields = [{label:'First Name'}, {label:'Last Name'}, {label:'Email'}, {label:'Login Name'}];			
			_form.setField(3, _message);
			_check.label = 'Allow collaborator read & write access';
			_check.y = 171;
			addChild(_form);
			addChild(_check);
		}
		
		public function set checkY(y:uint):void
		{
			_check.y = y;
		}
		
		public function addCollaborator():void
		{
			_collab.firstName 	= 	_form.getField(0);
			_collab.lastName 	= 	_form.getField(1);
			_collab.userEmail	=	_form.getField(2); 
			_collab.userName	=	_form.getField(3); 
			_collab.passWord 	= 	MD5.hash(new Date().toString());
			if (_collab.userName == _message || _collab.userName == '') _collab.userName = _collab.lastName.toLowerCase();
			var m:String = validate();
			if (m == null){
				var p:Permission = new Permission();
					p.read = true;
					p.write = _check.selected;
				Hosts.beanstalk.api.addCollaborator(_collab, p);
				AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorAdded);
			}	else{
				AppModel.alert(new Message(m));
			}	
		}

		private function onCollaboratorAdded(e:AppEvent):void
		{
			dispatchEmail();
			dispatchEvent(new AppEvent(AppEvent.COLLABORATOR_ADDED, _collab));
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollaboratorAdded);
		}

		private function validate():String
		{
			var a:Array = ['first name', 'last name', 'login'];
			var b:Array = [_collab.firstName, _collab.lastName, _collab.userName];
			for (var i:int = 0; i < 3; i++) {
				if (b[i] == '') {
					return 'Your collaborator\'s ' + a[i] + ' cannot be blank.';
				}	else if (b[i].search(/\s/g) != -1)
					return 'Your collaborator\'s ' + a[i] + ' cannot contain spaces.';
				}
			if (_collab.userEmail == '') return 'Please enter your collaborator\'s email.';	
			if (StringUtils.validateEmail(_collab.userEmail) == false) return 'The email you entered is invalid.';
			return null;
		}
		
		private function dispatchEmail():void
		{
			var vrs:URLVariables = new URLVariables();
				vrs.recipientName = _form.getField(0);
				vrs.recipientEmail = _collab.userEmail;
				vrs.sendersName = 'Stephen Braitsch';
				vrs.sendersEmail = 'stephen@quietless';
				vrs.userName = _collab.userName;
				vrs.userPass = _collab.passWord;
				vrs.homePage = Hosts.beanstalk.account.repository.homePage;
			var req:URLRequest = new URLRequest('http://revisions-app.com/email/add-collaborator.php');
				req.method = URLRequestMethod.POST;
				req.data = vrs;
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onEmailSuccess);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onEmailFailure);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onEmailFailure);
			_urlLoader.load(req);
		}

		private function onEmailSuccess(e:Event):void
		{
			//trace('email successfully sent');	
		}
		
		private function onEmailFailure(e:Event):void
		{
			AppModel.alert(new Debug({source:this, method:'dispatchEmail()', message:e.type}));
		}		

	}
	
}
