package view.history {
	import events.RepositoryEvent;

	import model.AppModel;

	public class HistoryItemUnsaved extends HistoryItem {
		
		public function HistoryItemUnsaved($branchName:String)
		{
			var o:Object = {	index :'XX', 	
								date :'- Right Now -',
								author : AppModel.proxies.config.userName || 'Unknown Author',
								note : 'Working Version (Not Saved)',
								name : $branchName	};
								
			super(o);								
			super.active = true;
			AppModel.proxies.config.addEventListener(RepositoryEvent.SET_USERNAME, onUserNameChange);	
		}
		
		private function onUserNameChange(e:RepositoryEvent):void 
		{
			super.author = AppModel.proxies.config.userName;
		}			
		
	}
	
}
