package view.windows.account {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.type.TextHeading;
	import view.windows.modals.collab.AddBeanstalkCollab;
	import view.windows.modals.collab.AddGitHubCollab;
	import flash.events.Event;
	public class AddCollaborator extends AccountView {

		private var _view			:*;
		private var _heading		:TextHeading = new TextHeading();

		public function AddCollaborator()
		{
			_heading.y = 5;
			addChild(_heading);
			super.addOkButton('Add Collaborator', 443);
			super.addNoButton('Go Back', 313);
			addEventListener(UIEvent.ENTER_KEY, onNextButton);
			addEventListener(UIEvent.NO_BUTTON, onPrevButton);
		}
		
		override protected function onAddedToStage(e:Event):void
		{
			if (_view) removeChild(_view);
			if (super.account.type == HostingAccount.GITHUB){
				addGHCollab();
			}	else if (super.account.type == HostingAccount.BEANSTALK) {
				addBSCollab();
			}			
			_view.y = 35;
			addChild(_view);
		}
		
		private function addGHCollab():void
		{
			_view = new AddGitHubCollab(558);
			_heading.text = 'Please enter the GitHub user you\'d like to collaborate with on "'+super.account.repository.repoName+'"';
			super.okButton.y = super.noButton.y = 90;
		}
		
		private function addBSCollab():void
		{
			_view = new AddBeanstalkCollab(558);
			_heading.text = 'Fill in below to create a new user to collaborate with on "'+super.account.repository.repoName+'"';
			super.okButton.y = super.noButton.y = 200;
		}		
		
		private function onNextButton(e:Event):void
		{
			_view.addCollaborator();
			AppModel.engine.addEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);
		}
		
		private function onPrevButton(e:UIEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
		}	
		
		private function onCollabAdded(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.WIZARD_PREV));
			AppModel.engine.removeEventListener(AppEvent.COLLABORATORS_RECEIEVED, onCollabAdded);
		}				
		
	}
	
}
