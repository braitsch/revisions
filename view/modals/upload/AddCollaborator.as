package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.vo.Collaborator;
	import view.modals.collab.BeanstalkCollab;
	import view.modals.collab.GitHubCollab;
	import flash.events.Event;

	public class AddCollaborator extends WizardWindow {

		private static var _collab			:*;

		public function AddCollaborator()
		{
			super.addHeading();
			super.nextButton = new OkButton();
			super.addBackButton();
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_collab) removeChild(_collab);
			if (super.obj.service == HostingAccount.GITHUB){
				_collab = new GitHubCollab(new Form1());
				super.heading = 'Please enter the GitHub user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';
			}	else if (super.obj.service == HostingAccount.BEANSTALK) {
				_collab = new BeanstalkCollab();
				super.heading = 'Fill in below to create a new user to collaborate with on "'+AppModel.bookmark.label+'"';
			}
			_collab.y = 90;
			_collab.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollabAdded);
			addChild(_collab);
		}

		private function onCollabAdded(e:AppEvent):void
		{
			super.obj.collaborator = e.data as Collaborator;
			super.onNextButton(e);
		}
		
		override protected function onNextButton(e:Event):void
		{
			_collab.addCollaborator(super.obj.repository);
		}
		
	}
	
}
