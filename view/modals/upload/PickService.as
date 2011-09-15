package view.modals.upload {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import flash.events.MouseEvent;

	public class PickService extends WizardWindow {

		private static var _view			:PickServiceMC = new PickServiceMC();

		public function PickService()
		{
			addChild(_view);
			super.addButtons([_view.github, _view.beanstalk]);
			super.addHeading('Which kind of account would you like to link this bookmark to?');
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
			super.service = s;
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT, s));
		}
		
	}
	
}
