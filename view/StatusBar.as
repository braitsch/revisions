package view {
	import events.RepositoryEvent;

	import model.AppModel;
	import model.proxies.StatusProxy;

	import flash.display.Sprite;

	public class StatusBar extends Sprite {

		private static var _view:StatusBarMC = new StatusBarMC();

		public function StatusBar()
		{
			this.y = 72;
			this.x = 740;			
			addChild(_view);
			
			AppModel.engine.addEventListener(RepositoryEvent.BOOKMARK_SET, onBookmarkSet);
			AppModel.proxies.status.addEventListener(RepositoryEvent.BRANCH_STATUS, onStatusReceived);
		}

		private function onStatusReceived(e:RepositoryEvent):void 
		{
		// we receive the full status of the active branch //	
			var a:Array = e.data as Array;
			_view.tracked_txt.text = String(a[StatusProxy.T].length);			_view.untracked_txt.text = String(a[StatusProxy.U].length);
			_view.modified_txt.text = String(a[StatusProxy.M].length);
			_view.ignored_txt.text = String(a[StatusProxy.I].length);
		}
		
		private function onBookmarkSet(e:RepositoryEvent):void 
		{
			if (e.data == null){
				_view.tracked_txt.text = '0';
				_view.untracked_txt.text = '0';
				_view.modified_txt.text = '0';
				_view.ignored_txt.text = '0';
			}
		}		
		
	}
	
}
