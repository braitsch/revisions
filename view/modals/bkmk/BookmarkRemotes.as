package view.modals.bkmk {

	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.remote.Hosts;
	import model.vo.Bookmark;
	import view.modals.base.ModalWindowBasic;

	public class BookmarkRemotes extends ModalWindowBasic {

		private static var _view		:BookmarkRemotesMC = new BookmarkRemotesMC();
		private static var _bookmark	:Bookmark;
		private static var _remotes		:Sprite = new Sprite();

		public function BookmarkRemotes()
		{
			addChild(_view); 
			addChild(_remotes);
			super.addButtons([_view.addNew.github, _view.addNew.beanstalk]);
			super.setHeading(_view, 'Remote accounts linked to this bookmark');
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
			if (Hosts.github.loggedIn){
				dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_GITHUB));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.GITHUB_LOGIN, UIEvent.ADD_BKMK_TO_GITHUB));
			}	
		}
		
		private function onBeanstalkClick(e:MouseEvent):void
		{
			if (Hosts.beanstalk.loggedIn){
				dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_BEANSTALK));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.BEANSTALK_LOGIN, UIEvent.ADD_BKMK_TO_BEANSTALK));
			}				
		}					
		
	}
	
}
