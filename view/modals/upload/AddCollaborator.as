package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.remote.acct.ApiProxy;
	import model.remote.HostingAccount;
	import model.remote.Hosts;
	import view.modals.collab.BeanstalkCollab;
	import view.modals.collab.Collaborator;
	import view.modals.collab.GitHubCollab;
	import view.modals.system.Message;
	import flash.events.Event;

	public class AddCollaborator extends WizardWindow {

		private static var _collab			:Collaborator;
		private static var _service			:String;
		private static var _serviceApi		:ApiProxy;
		private static var _repository		:String;
		private static var _collaborator	:String;

		public function AddCollaborator()
		{
			super.addHeading();
			super.nextButton = new OkButton();
			super.addBackButton();
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		public function set service(s:String):void
		{
			_service = s;
			super.heading = 'Please enter the '+_service+' user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';
			if (_service == HostingAccount.GITHUB){
				_collab = new GitHubCollab();
			}	else if (_service == HostingAccount.BEANSTALK) {
				_collab = new BeanstalkCollab();
			}
			_collab.y = 90;
			addChild(_collab);
		}
		
		public function set data(o:Object):void
		{
			_repository = o.repo; 
		}
		
		override protected function onNextButton(e:Event):void
		{
			if (_collab.validate()) {
				_collaborator = _collab.form.getField(0);
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
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
			_serviceApi.removeEventListener(AppEvent.COLLABORATOR_ADDED, onCollaboratorAdded);	
		}
		
	}
	
}
