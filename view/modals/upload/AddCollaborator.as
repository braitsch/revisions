package view.modals.upload {

	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.modals.collab.BeanstalkCollab;
	import view.modals.collab.GitHubCollab;
	import flash.events.Event;

	public class AddCollaborator extends WizardWindow {

		private static var _collab			:*;
		private static var _service			:String;

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
			if (_collab) removeChild(_collab);
			if (_service == HostingAccount.GITHUB){
				_collab = new GitHubCollab();
				super.heading = 'Please enter the GitHub user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';
			}	else if (_service == HostingAccount.BEANSTALK) {
				_collab = new BeanstalkCollab();
				super.heading = 'Fill in below to create a new user to collaborate with on "'+AppModel.bookmark.label+'"';
			}
			_collab.y = 90;
			addChild(_collab);
		}
		
		public function set data(o:Object):void
		{
			_collab.data = o.url; 
		}
		
		override protected function onNextButton(e:Event):void
		{
			_collab.addCollaborator();
		}
		
	}
	
}
