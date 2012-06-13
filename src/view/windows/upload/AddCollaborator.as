package view.windows.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.vo.Collaborator;
	import view.windows.modals.collab.AddBeanstalkCollab;
	import view.windows.modals.collab.AddGitHubCollab;
	import view.windows.modals.system.Message;
	import flash.events.Event;

	public class AddCollaborator extends WizardWindow {

		private static var _view			:*;

		public function AddCollaborator()
		{
			super.addHeading();
			super.addNextButton('OK');
			super.addBackButton();
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_view) removeChild(_view);
			if (super.account.acctType == HostingAccount.GITHUB){
				addGHCollab();
			}	else if (super.account.acctType == HostingAccount.BEANSTALK) {
				addBSCollab();
			}
			_view.y = 90;
			addChild(_view);
		}
		
		private function addGHCollab():void
		{
			_view = new AddGitHubCollab(530);
			super.heading = 'Please enter the GitHub user you\'d like to collaborate with on "'+AppModel.bookmark.label+'"';			
		}
		
		private function addBSCollab():void
		{
			_view = new AddBeanstalkCollab(530);
			_view.checkY = 167;
			super.heading = 'Fill in below to create a new user to collaborate with on "'+AppModel.bookmark.label+'"';			
		}
		
		override protected function onNextButton(e:Event):void
		{
			_view.addCollaborator();
			_view.addEventListener(AppEvent.COLLABORATOR_ADDED, onCollabAdded);
		}		

		private function onCollabAdded(e:AppEvent):void
		{
			var m:String = 'Awesome, I just added '+Collaborator(e.data).firstName+' to "'+super.repoName+'" on your '+super.account.acctType+' ';
				m+=	'account and sent them an email to let them know!';
			AppModel.alert(new Message(m));	
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			_view.removeEventListener(AppEvent.COLLABORATOR_ADDED, onCollabAdded);
		}
		
	}
	
}
