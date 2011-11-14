package view.windows.account.github {

	import view.windows.account.base.AddCollaborator;
	import view.windows.modals.collab.AddGitHubCollab;
	import flash.events.Event;

	public class GHAddCollab extends AddCollaborator {

		private static var _view	:AddGitHubCollab;

		public function GHAddCollab()
		{
			_view = new AddGitHubCollab(558);
			_view.y = 35;
			super.okButton.y = super.noButton.y = 90;			
			addChild(_view);
		}
		
		override protected function onAddedToStage(e:Event):void 
		{ 
			super.heading = 'Please enter the GitHub user you\'d like to collaborate with on "'+super.account.repository.repoName+'"';
			super.onAddedToStage(e);
		}
		
		override protected function onNextButton(e:Event):void
		{
			_view.addCollaborator();
			super.onNextButton(e);
		}
		
	}
	
}
