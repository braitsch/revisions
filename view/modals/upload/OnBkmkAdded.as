package view.modals.upload {

	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class OnBkmkAdded extends WizardWindow {

		private static var _view	:OnBkmkAddedMC = new OnBkmkAddedMC();

		public function OnBkmkAdded()
		{
			addChild(_view);
			super.addHeading();
			super.addButtons([_view.github, _view.beanstalk, _view.addCollab]);
			addEventListener(MouseEvent.CLICK, onButtonSelection);
		}

		override protected function onAddedToStage(e:Event):void
		{
			_view.github.visible = super.obj.service == HostingAccount.GITHUB;
			var m:String = 'You just pushed "'+AppModel.bookmark.label+'" up to a shiny new repository on '+super.obj.service+'! ';
				m+='\nWhat would you like to do now?';
			super.heading = m;
		}

		private function onButtonSelection(e:MouseEvent):void
		{
			switch(e.target){
				case _view.github :
					dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
				break;
				case _view.beanstalk :
					dispatchEvent(new UIEvent(UIEvent.BEANSTALK_HOME));
				break;
				case _view.addCollab :
					dispatchEvent(new UIEvent(UIEvent.ADD_COLLABORATOR));
				break;
			}
		}		
				
	}
	
}
