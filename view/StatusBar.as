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
			
			AppModel.status.addEventListener(RepositoryEvent.STATUS_RECEIVED, onStatusReceived);
		}

		private function onStatusReceived(e:RepositoryEvent):void 
		{
			_view.tracked_txt.text = String(e.data[RepositoryStatus.T].length);			_view.untracked_txt.text = String(e.data[RepositoryStatus.U].length);
			_view.modified_txt.text = String(e.data[RepositoryStatus.M].length);
			_view.ignored_txt.text = String(e.data[RepositoryStatus.I].length);
		}
		
	}
	
}
