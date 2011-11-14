package view.windows.account.beanstalk {

	import view.windows.account.base.AddCollaborator;
	import view.windows.modals.collab.AddBeanstalkCollab;
	import flash.events.Event;

	public class BSAddCollab extends AddCollaborator {

		private static var _view	:AddBeanstalkCollab;

		public function BSAddCollab()
		{
			_view = new AddBeanstalkCollab(558);
			_view.y = 35;
			super.okButton.y = super.noButton.y = 200;
			addChild(_view);
		}
		
		override protected function onAddedToStage(e:Event):void 
		{ 
			super.heading = 'Fill in below to create a new user to collaborate with on "'+super.account.repository.repoName+'"';
			super.onAddedToStage(e);
		}
		
		override protected function onNextButton(e:Event):void
		{
			_view.addCollaborator();
			super.onNextButton(e);
		}		
		
	}
	
}
