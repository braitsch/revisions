package view.modals.bkmk {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import model.vo.Bookmark;
	import view.modals.ModalWindowBasic;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkRemotes extends ModalWindowBasic {

		private static var _view		:BookmarkRemotesMC = new BookmarkRemotesMC();
		private static var _remotes		:Sprite = new Sprite();
		private static var _bookmark	:Bookmark;

		public function BookmarkRemotes()
		{
			addChild(_view); 
			addChild(_remotes);
			super.addButtons([_view.addNew.github, _view.addNew.beanstalk]);
			_view.addNew.github.addEventListener(MouseEvent.CLICK, onGitHubClick);
			_view.addNew.beanstalk.addEventListener(MouseEvent.CLICK, onBeanstalkClick);
		}
		
		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			attachRemotes();
		}

		private function attachRemotes():void
		{
			while(_remotes.numChildren) _remotes.removeChildAt(0);
			for (var i:int = 0; i < _bookmark.remotes.length; i++) {
				var ri:RemoteItem = new RemoteItem(_bookmark.remotes[i]);
				ri.y = 40*i;
				_remotes.addChild(ri);
			}
			_remotes.x = 10; _remotes.y = 90;
			_view.addNew.y = _remotes.y + _remotes.height + 20;
			super.drawBackground(550, _view.addNew.y + _view.addNew.height + 20);	
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
