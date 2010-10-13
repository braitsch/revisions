package view {
	import events.RepositoryEvent;

	import model.AppModel;
	import model.git.RepositoryStatus;

	import flash.display.Sprite;

	public class StatusBar extends Sprite {

		private static var _view:StatusBarMC = new StatusBarMC();

		public function StatusBar()
		{
			this.y = 72;
			this.x = 740;			
			addChild(_view);
			
			AppModel.repos.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkChanged);
		}

		private function onBookmarkChanged(e:RepositoryEvent):void 
		{
			AppModel.repos.bookmark.branch.addEventListener(RepositoryEvent.BRANCH_STATUS, onStatusReceived);
		}

		private function onStatusReceived(e:RepositoryEvent):void 
		{
			var a:Array = AppModel.repos.bookmark.branch.status;
			_view.tracked_txt.text = String(a[RepositoryStatus.T].length);			_view.untracked_txt.text = String(a[RepositoryStatus.U].length);
			_view.modified_txt.text = String(a[RepositoryStatus.M].length);
			_view.ignored_txt.text = String(a[RepositoryStatus.I].length);
		}
		
	}
	
}
