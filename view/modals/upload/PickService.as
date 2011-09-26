package view.modals.upload {

	import view.ui.DrawButton;
	import events.UIEvent;
	import model.remote.HostingAccount;
	import flash.events.MouseEvent;

	public class PickService extends WizardWindow {

		private static var _github			:DrawButton = new DrawButton(250, 36, 'Link To GitHub', 12);
		private static var _beanstalk		:DrawButton = new DrawButton(250, 36, 'Link To Beanstalk', 12);

		public function PickService()
		{
			setButtons();
			super.addHeading('Which kind of account would you like to link this bookmark to?');
		}
		
		private function setButtons():void
		{
			_github.x = _beanstalk.x = 150;
			_github.y = 110; _beanstalk.y = 170;
			_github.addIcon(new GitHubLogoSM());
			_beanstalk.addIcon(new BeanstalkLogoSM());
			addChild(_github); addChild(_beanstalk);
			addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		private function onButtonClick(e:MouseEvent):void
		{
			var s:String;
			if (e.target == _github){
				s = HostingAccount.GITHUB;
			}	else if (e.target == _beanstalk){
				s = HostingAccount.BEANSTALK;
			}
			dispatchEvent(new UIEvent(UIEvent.WIZARD_NEXT, s));
		}
		
	}
	
}
