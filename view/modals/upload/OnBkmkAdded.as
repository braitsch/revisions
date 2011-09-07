package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import view.modals.base.ModalWindowBasic;
	import view.modals.system.Message;
	import flash.events.MouseEvent;

	public class OnBkmkAdded extends ModalWindowBasic {

		private static var _view	:OnBkmkAddedMC = new OnBkmkAddedMC();
		private static var _service	:String;

		public function OnBkmkAdded()
		{
			addChild(_view);
			super.addButtons([_view.github, _view.beanstalk, _view.addCollab, _view.share, _view.close]);
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
					if (_service == HostingAccount.GITHUB){
						dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT));
					}	else{
						var m:Message = new Message('This feature for Beanstalk accounts is coming soon.');
						AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
					}
				break;
				case _view.share :
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('This feature is coming soon.')));
				break;
				case _view.close :
					dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				break;								
			}
		}		
				
	}
	
}
