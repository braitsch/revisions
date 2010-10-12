package view.history {
	import events.RepositoryEvent;

	import model.AppModel;

	public class HistoryItemUnsaved extends HistoryItem {
		
		public function HistoryItemUnsaved()
		{
			var n:String = AppModel.config.userName || 'Unknown Author';
			super('XX', '- Right Now -', n, 'Working Version (Not Saved)');
			super.active = true;
			AppModel.config.addEventListener(RepositoryEvent.SET_USERNAME, onUserNameChange);	
		}
		
		private function onUserNameChange(e:RepositoryEvent):void 
		{
			super.author = AppModel.config.userName;
		}			
		
	}
	
}
