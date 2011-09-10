package view.modals.collab {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.Hosts;
	import system.StringUtils;
	import view.modals.system.Debug;
	import view.modals.system.Message;
	import view.ui.Form;
	import view.ui.ModalCheckbox;
	import com.adobe.crypto.MD5;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class BeanstalkCollab extends CollabView {

		private var _form				:Form = new Form(new Form4());
		private var _check				:ModalCheckbox = new ModalCheckbox(true);
		private var _message			:String = '(optional) we\'ll use their last name if you leave this blank.';
		private var _urlLoader			:URLLoader;

		public function BeanstalkCollab()
		{
			_form.labels = ['First Name', 'Last Name', 'Email', 'Login Name'];
			_form.enabled = [1, 2, 3, 4];
			_form.setField(3, _message);
			addChild(_form);
			_check.label = 'Allow collaborator read & write access';
			_check.y = 145;
			addChild(_check);
		}
		
		override public function addCollaborator():void
		{
			super.collab.firstName 	= 	_form.getField(0);
			super.collab.lastName 	= 	_form.getField(1);
			super.collab.userEmail	=	_form.getField(2); 
			super.collab.userName	=	_form.getField(3); 
			super.collab.readWrite 	= 	_check.selected;
			super.collab.fullName 	= 	_form.getField(0) +' '+_form.getField(1);
			super.collab.passWord 	= 	MD5.hash(new Date().toString());		
			if (super.collab.userName == _message || super.collab.userName == '') super.collab.userName = super.collab.lastName.toLowerCase();
			var m:String = validate();
			if (m == null){
				Hosts.beanstalk.api.addCollaborator(super.collab);
				Hosts.beanstalk.api.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);
			}	else{
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			}	
		}
		
		private function validate():String
		{
			var a:Array = ['first name', 'last name', 'login'];
			var b:Array = [super.collab.firstName, super.collab.lastName, super.collab.userName];
			for (var i:int = 0; i < 3; i++) {
				if (b[i] == '') {
					return 'Your collaborator\'s ' + a[i] + ' cannot be blank.';
				}	else if (b[i].search(/\s/g) != -1)
					return 'Your collaborator\'s ' + a[i] + ' cannot contain spaces.';
				}
			if (super.collab.userEmail == '') return 'Please enter your collaborator\'s email.';	
			if (StringUtils.validateEmail(super.collab.userEmail) == false) return 'The email you entered is invalid.';
			return null;
		}
		
		private function onCollaboratorAdded(e:AppEvent):void
		{
			dispatchEmail();
			Hosts.beanstalk.api.removeEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);
		}		
		
		private function dispatchEmail():void
		{
			var vrs:URLVariables = new URLVariables();
				vrs.recipientName = _form.getField(0);
				vrs.recipientEmail = super.collab.userEmail;
				vrs.sendersName = 'Stephen Braitsch';
				vrs.sendersEmail = 'stephen@quietless';
				vrs.userName = super.collab.userName;
				vrs.userPass = super.collab.passWord;
				vrs.homePage = super.collab.repository.homePage;
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
			dispatchEvent(new AppEvent(AppEvent.COLLABORATOR_ADDED, super.collab));			
		}
		
		private function onEmailFailure(e:Event):void
		{
			dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Debug({source:this, method:'dispatchEmail()', message:e.type})));
		}		

	}
	
}
