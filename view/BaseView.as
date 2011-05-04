package view {

	import events.BookmarkEvent;
	import events.InstallEvent;
	import model.AppModel;
	import flash.display.Sprite;

	public class BaseView extends Sprite {

		private static var _view		:BaseViewMC = new BaseViewMC();
		private static var _toolbar		:Toolbar = new Toolbar();
		private static var _status		:StatusBar = new StatusBar();

		public function BaseView()
		{
			_view.target_txt.autoSize = 'left';
			_view.addChild(_status);			_view.addChild(_toolbar);			addChild(_view);

			AppModel.engine.addEventListener(BookmarkEvent.EDITED, refreshView);
			AppModel.engine.addEventListener(BookmarkEvent.STATUS, refreshView);
			AppModel.engine.addEventListener(BookmarkEvent.NO_BOOKMARKS, zeroAllFields);
			AppModel.proxies.config.addEventListener(InstallEvent.SET_GIT_VERSION, setGitVersion);
		}

		public function get view():BaseViewMC
		{
			return _view;
		}	
		
		private function refreshView(e:BookmarkEvent):void
		{
			_view.target_txt.text = setLocation() + setPosition();
		}				
		
		private function setLocation():String
		{
			return 'Bookmark / Branch : ' + AppModel.bookmark.label +' [ '+AppModel.branch.name+' ]';			
		}

		private function setPosition():String
		{
			var a:Array = AppModel.bookmark.branch.history;
			if (a.length == 0){
				return ' -- Last Saved : No Previous Versions Yet';
			}	else{
				return ' -- Version '+a.length+' -- Last Saved : '+a[0][1]+' by '+a[0][2];
			}			
		}				
		
		private function zeroAllFields(e:BookmarkEvent):void
		{
			_view.target_txt.text = 'Bookmark / Branch : NONE';
		}			
		
		private function setGitVersion(e:InstallEvent):void 
		{
			_view.version_txt.text = 'git : '+e.data as String;
		}
		
	}
	
}
