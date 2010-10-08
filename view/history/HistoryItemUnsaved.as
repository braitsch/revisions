package view.history {
	import events.RepositoryEvent;

	import model.AppModel;

	public class HistoryItemUnsaved extends HistoryItem {
		
		public function HistoryItemUnsaved()
		{
			super('X', 'Right Now', 'Unknown Author', 'Current Working Version');
			super.active = true;
			AppModel.config.addEventListener(RepositoryEvent.SET_USERNAME, onUserNameChange);	
		}
		
		private function onUserNameChange(e:RepositoryEvent):void 
		{
			super.author = AppModel.config.userName;
		}			
		
	}
	
}
