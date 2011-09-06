package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.ui.Form;
	import flash.events.Event;

	public class AddCollaborator extends WizardWindow {

		private static var _form			:Form;
		private static var _user			:TLFTextField = new FINorm().getChildAt(0) as TLFTextField;	
		private static var _service			:String;
		private static var _serviceApi		:ApiProxy;
		private static var _repository		:String;
		private static var _collaborator	:String;

		public function AddCollaborator()
		{
			_form = new Form(new Form1());
			_form.y = 90;
			_form.labels = ['UserName'];
			_form.inputs = [_user];
			_form.addEventListener(UIEvent.ENTER_KEY, onNextButton);
			addChild(_form);
			
			super.addHeading();
			super.nextButton = new OkButton();
			super.addBackButton();
		}
		
		public function set service(s:String):void
		{
			_service = s;
			super.heading = 'Please enter the '+_service+' user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';
		}
		
		public function set data(o:Object):void
		{
			_repository = o.repo; 
		}		
		
		override public function onEnterKey():void { onNextButton(); }		
		override protected function onNextButton(e:Event = null):void
		{
			if (_form.validate()) {
				_collaborator = _form.fields[0];
				_serviceApi = _service == HostingAccount.GITHUB ? Hosts.github.api : Hosts.beanstalk.api;
				_serviceApi.addCollaborator(_repository, _collaborator);
				_serviceApi.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);	
			}
		}
		
		private function onCollaboratorAdded(e:AppEvent = null):void
		{
			var m:String = 'Awesome! I just added "'+_collaborator+'" to your '+_service+' repository "'+_repository+'" ';
				m+='and just sent them an email so they\'re in the know. \nRock on now & get back to work!';
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
			_serviceApi.removeEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);	
		}
		
	}
	
}
