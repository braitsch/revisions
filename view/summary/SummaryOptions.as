package view.summary {

	import model.vo.Repository;
	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.AppSettings;
	import view.btns.IconButton;
	import view.windows.modals.system.Confirm;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SummaryOptions extends Sprite {

		private static var _view:*;
		private static var _locked		:Boolean;
		private static var _confirm		:Confirm;
		private static var _remote		:Repository;
	
		public function SummaryOptions(v:Sprite)
		{
			_view = v;
			initButtons();
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelected);
			AppModel.engine.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
			AppModel.engine.addEventListener(AppEvent.BRANCH_STATUS, onBranchStatus);
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
			showBranchStatus();
		}
		
		private function onBranchStatus(e:AppEvent):void
		{
			showBranchStatus();
		}	
		
		private function showBranchStatus():void
		{
			if (AppModel.branch.remoteStatus == 0){
				_view.sync_btn.syncCount.visible = false;	
			}	else{
				_view.sync_btn.syncCount.visible = true;	
				if (AppModel.branch.remoteStatus < 0){
					drawSyncCountBkgd(0xCC323E);
				}	else{
					drawSyncCountBkgd(0x009FAF);
				}
				_view.sync_btn.syncCount.num.text =	AppModel.branch.remoteStatus;
			}
		}
		
		private function drawSyncCountBkgd(c:uint):void
		{
			_view.sync_btn.syncCount.graphics.clear();
			_view.sync_btn.syncCount.graphics.beginFill(c);
			_view.sync_btn.syncCount.graphics.drawCircle(0, 0, 10);
			_view.sync_btn.syncCount.graphics.endFill();
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
			if (!_locked) checkBranchHasBeenPublished();
		}
		
		private function onHistoryButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_HISTORY));
		}
		
		private function syncRemote():void
		{
			_locked = true;
			AppModel.proxies.remote.sync(AppModel.branch, _remote);
		}
		
		private function checkBranchHasBeenPublished():void
		{
			if (AppModel.branch.isModified){
				AppModel.alert('Please saves your lastest changes before syncing with the server.');		
			}	else {
				_remote = AppModel.bookmark.remotes[0];
				if (_remote.hasBranch(AppModel.branch.name)){
					syncRemote();
				}	else {
					if (AppSettings.getSetting(AppSettings.PROMPT_NEW_REMOTE_BRANCHES) == false){
						syncRemote();
					}	else{
						confirmUnpublishedBranch();
					}
				}
			}
		}
				
		private function confirmUnpublishedBranch():void 
		{
			var m:String = 'The current branch "'+AppModel.branch.name+'" has not yet been published online.';
				m+= '\nAre you sure you\'d like to add it to your '+_remote.acctType+' account?';
			_confirm = new Confirm(m);
			_confirm.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, _confirm));				
		}
		
		private function onConfirm(e:UIEvent):void
		{
			trace("SyncProxy.onConfirm(e)", e.data);
			if (e.data as Boolean == true) syncRemote();
		}			

		private function onRemoteSynced(e:AppEvent):void 
		{
			 _locked = false;
			 showBranchStatus();
		}				
		
	}
	
}
