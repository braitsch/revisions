package view {
	import events.InstallEvent;
	import events.BookmarkEvent;

	import model.AppModel;

	import model.Bookmark;

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

			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, zeroAllFields);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkChanged);
			AppModel.proxies.config.addEventListener(InstallEvent.SET_GIT_VERSION, onGitVersion);
		}

		public function get view():BaseViewMC
		{
			return _view;
		}	
		
		private function zeroAllFields(e:BookmarkEvent):void
		{
			_bookmark = null;
			_view.target_txt.text = 'Repository / Branch : NONE';
		}			
		
		private function onBookmarkChanged(e:BookmarkEvent):void 
		{
			_bookmark = e.data as Bookmark;
			_bookmark.addEventListener(BookmarkEvent.EDITED, setStatus);
			_bookmark.branch.addEventListener(BookmarkEvent.BRANCH_HISTORY, setStatus);
		}		
		
		private function getLocation():String
		{
			return 'Repository / Branch : ' + _bookmark.label +' [ '+_bookmark.branch.name+' ]';
		}		
		
		private function getPosition():String
		{
			var a:Array = AppModel.bookmark.branch.history;
			if (a.length == 0){
				return ' -- Last Saved : No Previous Versions Yet';
			}	else{
				return ' -- Version '+a.length+' -- Last Saved : '+a[0][1]+' by '+a[0][2];
			}
		}
		
		private function setStatus(e:BookmarkEvent = null):void 
		{
			_view.target_txt.text = getLocation();
			_view.target_txt.appendText(getPosition());
		}		
		
		private function onGitVersion(e:InstallEvent):void 
		{
			_view.version_txt.text = 'git : '+e.data as String;
		}
		
	}
	
}
