package view.modals.bkmk {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import model.vo.Bookmark;
	import view.modals.ModalWindowBasic;
	import flash.events.MouseEvent;

	public class BookmarkRemotes extends ModalWindowBasic {

		private static var _view		:BookmarkRemotesMC = new BookmarkRemotesMC();
		private static var _bookmark	:Bookmark;

		public function BookmarkRemotes()
		{
			addChild(_view);
			super.drawBackground(550, 273);
			super.addButtons([_view.github, _view.beanstalk]);
			_view.github.addEventListener(MouseEvent.CLICK, onGitHubClick);
			_view.beanstalk.addEventListener(MouseEvent.CLICK, onBeanstalkClick);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
		}
		
		private function onGitHubClick(e:MouseEvent):void
		{
			if (AccountManager.github){
				dispatchEvent(new UIEvent(UIEvent.ADD_REMOTE_TO_BOOKMARK, RemoteAccount.GITHUB));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.REMOTE_LOGIN, {type:RemoteAccount.GITHUB, event:UIEvent.ADD_REMOTE_TO_BOOKMARK}));
			}	
		}
		
		private function onBeanstalkClick(e:MouseEvent):void
		{
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, 'Beanstalk integration is coming in the next build.'));			
		}					
		
	}
	
}
