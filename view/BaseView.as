package view {
	import events.InstallEvent;
	import events.RepositoryEvent;

	import model.AppModel;

	import view.bookmarks.Bookmark;

	import flash.display.Sprite;

	public class BaseView extends Sprite {

		private static var _view		:BaseViewMC = new BaseViewMC();
		private static var _toolbar		:Toolbar = new Toolbar();
		private static var _status		:StatusBar = new StatusBar();
		private static var _bookmark	:Bookmark;

		public function BaseView()
		{
			_view.target_txt.autoSize = 'left';
			_view.addChild(_status);			_view.addChild(_toolbar);			addChild(_view);

			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkChanged);
			AppModel.proxies.installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitVersion);
		}
		
		public function get view():BaseViewMC
		{
			return _view;
		}		
		
		private function onBookmarkChanged(e:RepositoryEvent):void 
		{
			_bookmark = e.data as Bookmark;
			if (_bookmark == null) {
				_view.target_txt.text = 'Repository / Branch : NONE';
			}	else{
				_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;
				if (AppModel.branch.history) onHistoryReceived(e);
				_bookmark.branch.addEventListener(RepositoryEvent.BRANCH_HISTORY, onHistoryReceived);
			}
		}		

		private function onHistoryReceived(e:RepositoryEvent):void
		{
			var a:Array = AppModel.bookmark.branch.history;
			if (a.length != 0){
				_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;								_view.target_txt.appendText(' -- Version '+a.length+' -- Last Saved : '+a[0][1]+' by '+a[0][2]);
			}	else{
				_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;				
				_view.target_txt.appendText(' -- Last Saved : Unavailable');				
			}
		}
		
		private function onGitVersion(e:InstallEvent):void 
		{
			_view.version_txt.text = 'git : '+e.data as String;
		}
		
	}
	
}
