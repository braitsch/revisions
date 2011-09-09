package view.modals.upload {

	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import flash.events.MouseEvent;

	public class OnBkmkAdded extends WizardWindow {

		private static var _view	:OnBkmkAddedMC = new OnBkmkAddedMC();
		private static var _service	:String;

		public function OnBkmkAdded()
		{
			addChild(_view);
			super.addButtons([_view.github, _view.beanstalk, _view.addCollab]);
			addEventListener(MouseEvent.CLICK, onButtonSelection);
		}

		public function set service(s:String):void
		{
			_service = s;
			_view.github.visible = _service == HostingAccount.GITHUB;
			var m:String = 'You just pushed "'+AppModel.bookmark.label+'" up to a shiny new repository on '+_service+'! ';
				m+='\nWhat would you like to do now?';
			super.setHeading(_view, m);
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
