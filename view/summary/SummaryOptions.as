package view.summary {

	import events.AppEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.btns.IconButton;
	import view.windows.modals.system.Message;
	
	public class SummaryOptions extends Sprite {

		private static var _view:*;
		private static var _locked		:Boolean;
		private static var _bookmark	:Bookmark;
	
		public function SummaryOptions(v:Sprite)
		{
			_view = v;
			initButtons();
			AppModel.engine.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
		}
		
		public function set bookmark(b:Bookmark):void { _bookmark = b; }
		
		public function positionButtons(b:Boolean):void
		{
			_view.sync_btn.visible = b;
			_view.history_btn.x = b ? 60 : 40;
			_view.upload_btn.x = b ? -20 : 0;
			_view.settings_btn.x = b ? -60 : -40;
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
		
		private function onSettingsButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.EDIT_BOOKMARK, _bookmark));			
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
			if (_bookmark.branch.isModified){
				var m:Message = new Message('Please saves your lastest changes before syncing with the server.');
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
			}	else{
				_locked = true;
				AppModel.proxies.remote.syncRemotes(_bookmark.remotes);
			}
		}

		private function onRemoteSynced(e:AppEvent):void { _locked = false; }				
		
	}
	
}
