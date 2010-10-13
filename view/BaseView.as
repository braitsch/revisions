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

			AppModel.installer.addEventListener(InstallEvent.SET_GIT_VERSION, onGitVersion);			
			AppModel.proxy.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkChange);									
		}

		private function onBookmarkChange(e:RepositoryEvent):void 
		{
			_bookmark = e.data as Bookmark;
			if (_bookmark) {
				_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;
				if (_bookmark.branch.history){
					onHistoryReceived();
				}	else{
					onHistoryUnavailable();
				}
			}	else{
				_view.target_txt.text = 'Repository / Branch : NONE';
			}
		}

		public function get view():BaseViewMC
		{
			return _view;
		}
		
	// private //	
		
		private function onGitVersion(e:InstallEvent):void 
		{
			_view.version_txt.text = 'git : '+e.data as String;
		}		

		private function onHistoryReceived():void 
		{
			var a:Array = _bookmark.branch.history[0].split('##');
			if (a[1]=='0 seconds ago') a[1]='Just Now';
			_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;							_view.target_txt.appendText(' -- Version '+_bookmark.branch.history.length+' -- Last Saved : '+a[1]+' by '+a[2]);
		}
		
		private function onHistoryUnavailable():void 
		{
			_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;				
			_view.target_txt.appendText(' -- Last Saved : Unavailable');				
		}		
		
	}
	
}
