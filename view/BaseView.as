package view {
	import events.InstallEvent;
	import events.RepositoryEvent;

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
			if (_bookmark != null){
				_bookmark.addEventListener(RepositoryEvent.BRANCH_SET, setStatus);				_bookmark.addEventListener(RepositoryEvent.BOOKMARK_EDITED, setStatus);
				_bookmark.branch.addEventListener(RepositoryEvent.BRANCH_HISTORY, setStatus);
			}
			setStatus();
		}		
		
		private function getLocation():String
		{
			if (_bookmark == null){
				return 'Repository / Branch : NONE';
			}	else{
				return 'Repository / Branch : ' + _bookmark.label +' [ '+_bookmark.branch.name+' ]';
			}
		}		
		
		private function getPosition():String
		{
			var a:Array = AppModel.bookmark.branch.history;
			if (a == null){
				return ' -- Last Saved : No Previous Versions Yet';			}	else if (a.length == 0){
				return ' -- Last Saved : No Previous Versions Yet';
			}	else{
				return ' -- Version '+a.length+' -- Last Saved : '+a[0][1]+' by '+a[0][2];
			}
		}
		
		private function setStatus(e:RepositoryEvent = null):void 
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
