package view.summary {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import view.btns.IconButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SummaryOptions extends Sprite {

		private static var _view:*;
		private static var _locked		:Boolean;
	
		public function SummaryOptions(v:Sprite)
		{
			_view = v;
			initButtons();
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelected);
			AppModel.engine.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
			AppModel.engine.addEventListener(AppEvent.BKMK_ADDED_TO_ACCOUNT, onBkmkAddedToAcct);
		}

		private function initButtons():void
		{
			var l:Array = ['Settings', 'Link Account', 'Sync Account', 'History'];
			var a:Array = [_view.settings_btn, _view.upload_btn, _view.sync_btn, _view.history_btn];
			for (var i:int = 0; i < 4; i++) new IconButton(a[i], l[i]);
			_view.sync_btn.addEventListener(MouseEvent.CLICK, onSyncButton);
			_view.upload_btn.addEventListener(MouseEvent.CLICK, onUploadButton);
			_view.history_btn.addEventListener(MouseEvent.CLICK, onHistoryButton);
			_view.settings_btn.addEventListener(MouseEvent.CLICK, onSettingsButton);
		}
		
		private function onSelected(e:BookmarkEvent):void
		{
			positionButtons();	
		}

		private function onBkmkAddedToAcct(e:AppEvent):void
		{
			positionButtons();	
		}
		
		private function positionButtons():void
		{
			var b:Boolean = AppModel.bookmark.remotes.length > 0;
			_view.sync_btn.visible = b;
			_view.history_btn.x = b ? 60 : 40;
			_view.upload_btn.x = b ? -20 : 0;
			_view.settings_btn.x = b ? -60 : -40;
		}			
		
		private function onSettingsButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.EDIT_BOOKMARK, AppModel.bookmark));			
		}
		
		private function onUploadButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_ACCOUNT));
		}
		
		private function onSyncButton(e:MouseEvent):void 
		{
			if (!_locked) syncRemote(); 
		}
		
		private function onHistoryButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_HISTORY));
		}
		
		private function syncRemote():void
		{
			if (AppModel.branch.isModified == false){
				_locked = true;
				AppModel.proxies.remote.syncRemotes(AppModel.bookmark.remotes);
			}	else{
				AppModel.alert('Please saves your lastest changes before syncing with the server.');
			}
		}

		private function onRemoteSynced(e:AppEvent):void { _locked = false; }				
		
	}
	
}
