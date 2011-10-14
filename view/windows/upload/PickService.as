package view.windows.upload {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import view.btns.ButtonIcon;
	import view.btns.DrawButton;
	import flash.events.MouseEvent;

	public class PickService extends WizardWindow {

		private static var _github			:DrawButton = new DrawButton(250, 45, 'Link To GitHub', 12);
		private static var _beanstalk		:DrawButton = new DrawButton(250, 45, 'Link To Beanstalk', 12);

		public function PickService()
		{
			setButtons();
			super.addHeading('Which kind of online account would you like to link this bookmark to?');
		}
		
		private function setButtons():void
		{
			_github.x = _beanstalk.x = 150;
			_github.y = 115; _beanstalk.y = 180;
			_github.icon = new ButtonIcon(new GitHubIcon(), false);
			_beanstalk.icon = new ButtonIcon(new BeanstalkIcon(), false);
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
