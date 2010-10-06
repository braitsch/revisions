package view {
	import events.RepositoryEvent;

	import model.AppModel;
	import model.git.RepositoryStatus;

	import view.bookmarks.Bookmark;

	import flash.display.Sprite;

	public class StatusBar extends Sprite {

		private static var _view:StatusBarMC = new StatusBarMC();

		public function StatusBar()
		{
			this.y = 72;
			this.x = 740;			
			addChild(_view);
			
			AppModel.getInstance().addEventListener(RepositoryEvent.BOOKMARK_SELECTED, onBookmarkChange);		
		}

		private function onBookmarkChange(e:RepositoryEvent):void 
		{
			var b:Bookmark = e.data as Bookmark;
			_view.tracked_txt.text = String(b.status[RepositoryStatus.T].length);			_view.untracked_txt.text = String(b.status[RepositoryStatus.U].length);
			_view.modified_txt.text = String(b.status[RepositoryStatus.M].length);
			_view.ignored_txt.text = String(b.status[RepositoryStatus.I].length);
		}
		
	}
	
}
