package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.modals.collab.AddBeanstalkCollab;
	import view.modals.collab.AddGitHubCollab;
	import view.modals.system.Message;
	import flash.events.Event;

	public class AddCollaborator extends WizardWindow {

		private static var _view			:*;

		public function AddCollaborator()
		{
			super.addHeading();
			super.nextButton = new OkButton();
			super.addBackButton();
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_view) removeChild(_view);
			if (super.account.type == HostingAccount.GITHUB){
				addGHCollab();
			}	else if (super.account.type == HostingAccount.BEANSTALK) {
				addBSCollab();
			}
			_view.y = 90;
			addChild(_view);
		}
		
		private function addGHCollab():void
		{
			_view = new AddGitHubCollab(new Form1());
			super.heading = 'Please enter the GitHub user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';			
		}
		
		private function addBSCollab():void
		{
			_view = new AddBeanstalkCollab();
			super.heading = 'Fill in below to create a new user to collaborate with on "'+AppModel.bookmark.label+'"';			
		}
		
		override protected function onNextButton(e:Event):void
		{
			_view.addCollaborator();
			AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);
		}		

		private function onCollabAdded(e:AppEvent):void
		{
			dispatchComplete();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			if (_view is AddBeanstalkCollab) _view.dispatchEmail();
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);			
		}
		
		private function dispatchComplete():void
		{
			var m:String = 'Awesome, I just added '+_view.collab.firstName+' to "'+super.repoName+'" on your '+super.account.type+' ';
				m+=	'account and sent them an email to let them know!';
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message(m)));
		}
		
	}
	
}
