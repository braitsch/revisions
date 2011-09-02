package view.modals.upload {

	import events.AppEvent;
	import model.remote.HostingAccount;
	import view.modals.base.ModalWindowBasic;
	import flash.events.MouseEvent;

	public class ChooseService extends ModalWindowBasic {

		private static var _view			:ChooseServiceMC = new ChooseServiceMC();

		public function ChooseService()
		{
			addChild(_view);
			super.addButtons([_view.github, _view.beanstalk]);
			super.setHeading(_view, 'Which kind of account would you like to link this bookmark to?');
			_view.github.addEventListener(MouseEvent.CLICK, onButtonClick);
			_view.beanstalk.addEventListener(MouseEvent.CLICK, onButtonClick);
		}

		private function onButtonClick(e:MouseEvent):void
		{
			var s:String;
			if (e.target.name == 'github'){
				s = HostingAccount.GITHUB;
			}	else if (e.target.name == 'beanstalk'){
				s = HostingAccount.BEANSTALK;	
			}
			dispatchEvent(new AppEvent(AppEvent.SERVICE_SELECTED, s));
		}
		
	}
	
}
