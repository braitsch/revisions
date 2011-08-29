package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.MouseEvent;

	public class GitHubHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();

		public function GitHubHome()
		{
			super(_view);
			_view.badgePage.label_txt.text = 'My Github';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
		}

		private function onLogOutClick(e:MouseEvent):void
		{
			dispatchEvent(new AppEvent(AppEvent.LOGOUT));
		}	
		
		public function closeWindow():void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}			
		
	}
	
}
