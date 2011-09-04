package view.modals.upload {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import system.StringUtils;
	import view.modals.base.ModalWindowBasic;
	import flash.events.MouseEvent;

	public class OnBkmkAdded extends ModalWindowBasic {

		private static var _view	:OnBkmkAddedMC = new OnBkmkAddedMC();

		public function OnBkmkAdded()
		{
			addChild(_view);
			super.addButtons([_view.github, _view.beanstalk, _view.addCollab, _view.share, _view.close]);
			addEventListener(MouseEvent.CLICK, onButtonSelection);
		}
		
		public function set service(s:String):void
		{
			var a:String = StringUtils.capitalize(s);
			var m:String = 'You just pushed "'+AppModel.bookmark.label+'" up to a shiny new repository on '+a+'! ';
			m+='\nWhat would you like to do now?';
			super.setHeading(_view, m);
			_view.github.visible = s == HostingAccount.GITHUB;
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
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'This feature is coming soon.'));
				break;
				case _view.share :
					AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'This feature is coming soon.'));
				break;
				case _view.close :
					dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				break;								
			}
		}		
				
	}
	
}
