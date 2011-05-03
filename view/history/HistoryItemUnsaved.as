package view.history {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Branch;
	import model.Commit;

	public class HistoryItemUnsaved extends HistoryListItem {
		
		public function HistoryItemUnsaved(b:Branch)
		{
			var o:Object = {	index :'XX', 	
								date :'- Right Now -',
								author : AppModel.proxies.config.userName || 'Unknown Author',
								note : 'Working Version (Not Saved)',
								branch : b};
								
			super(new Commit(o));								
			super.active = true;
			AppModel.proxies.config.addEventListener(BookmarkEvent.SET_USERNAME, onUserNameChange);	
		}
		
		private function onUserNameChange(e:BookmarkEvent):void 
		{
			super.author = AppModel.proxies.config.userName;
		}			
		
	}
	
}
