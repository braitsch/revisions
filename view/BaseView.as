package view {
	import commands.UICommand;

	import events.InstallEvent;
	import events.RepositoryEvent;

	import model.AppModel;
	import model.git.GitInstaller;
	import model.git.RepositoryHistory;

	import view.bookmarks.Bookmark;

	import flash.display.Sprite;

	public class BaseView extends Sprite {

		private static var _view		:BaseViewMC = new BaseViewMC();
		private static var _toolbar		:Toolbar = new Toolbar();
		private static var _status		:StatusBar = new StatusBar();
		private static var _installer	:GitInstaller = AppModel.core;
		private static var _history		:RepositoryHistory = AppModel.history;
		private static var _bookmark	:Bookmark;

		public function BaseView()
		{
			addChild(_view);
			_view.target_txt.autoSize = 'left';			_view.addChild(_status);			_view.addChild(_toolbar);

			_installer.addEventListener(InstallEvent.GIT_AVAILABLE, onGitAvailable);			_installer.addEventListener(InstallEvent.GIT_UNAVAILABLE, promptForInstall);	
			_history.addEventListener(RepositoryEvent.HISTORY_RECEIVED, onHistoryReceived);
			_history.addEventListener(RepositoryEvent.HISTORY_UNAVAILABLE, onHistoryUnavailable);	
			
			AppModel.getInstance().addEventListener(RepositoryEvent.SET_BOOKMARK, onBookmarkChange);										
		}

		private function onBookmarkChange(e:RepositoryEvent):void 
		{
			_bookmark = e.data as Bookmark;
			if (_bookmark) {
				_history.getHistory();					
				_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;				
			}
		}
		
		public function get view():BaseViewMC
		{
			return _view;
		}
		
	// private //	
		
		private function onGitAvailable(e:InstallEvent):void 
		{
			_view.version_txt.text = 'git : '+e.data as String;;
			AppModel.database.init();
		}		

		private function promptForInstall(e:InstallEvent):void 
		{
			dispatchEvent(new UICommand(UICommand.INSTALL_GIT, String(e.data)));
		}		
		
		private function onHistoryReceived(e:RepositoryEvent):void 
		{
			var a:Array = e.data[0].split('##');
			if (a[1]=='0 seconds ago') a[1]='Just Now';
			_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;							_view.target_txt.appendText(' -- Version '+e.data.length+' -- Last Commit : '+a[1]+' by '+a[2]);
		}
		
		private function onHistoryUnavailable(e:RepositoryEvent):void 
		{
			_view.target_txt.text = 'Repository / Branch : ' + _bookmark.label;				
			_view.target_txt.appendText(' -- Last Commit : Unavailable');				
		}		
		
	}
	
}
