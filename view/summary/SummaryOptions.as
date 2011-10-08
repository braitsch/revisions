package view.summary {

	import com.greensock.TweenLite;
	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import system.AppSettings;
	import view.btns.IconButton;
	import view.windows.modals.system.Confirm;
	import view.windows.modals.system.Message;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SummaryOptions extends Sprite {

		private static var _view:*;
		private static var _confirm		:Confirm;
	
		public function SummaryOptions(v:Sprite)
		{
			_view = v;
			initButtons();
			positionButtons(false);
			AppModel.engine.addEventListener(AppEvent.BRANCH_STATUS, onBranchStatus);
			AppModel.engine.addEventListener(AppEvent.BRANCH_PUSHED, onBranchPushed);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, onModified);
		}

		private function initButtons():void
		{
			var l:Array = ['Settings', 'Link Account', 'Sync Account', 'History'];
			var a:Array = [_view.settings_btn, _view.upload_btn, _view.sync_btn, _view.history_btn];
			for (var i:int = 0; i < 4; i++) new IconButton(a[i], l[i]);
			_view.sync_btn.syncCount.num.mouseEnabled = false;
			_view.sync_btn.addEventListener(MouseEvent.CLICK, onSyncButton);
			_view.upload_btn.addEventListener(MouseEvent.CLICK, onUploadButton);
			_view.history_btn.addEventListener(MouseEvent.CLICK, onHistoryButton);
			_view.settings_btn.addEventListener(MouseEvent.CLICK, onSettingsButton);
		}
		
		private function onModified(e:AppEvent):void
		{
			if (AppModel.repository){	
				checkBranchStatus();
			}	else{
				positionButtons(false);
			}
		}

		private function onBranchStatus(e:AppEvent):void
		{
			checkBranchStatus();
		}
		
		private function onBranchPushed(e:AppEvent):void 
		{
			positionButtons(false);
		}			
		
		private function checkBranchStatus():void
		{
			_view.sync_btn.syncCount.visible = true;
			if (AppModel.repository.hasBranch(AppModel.branch.name)){
				_view.sync_btn.syncCount.num.visible = true;
				_view.sync_btn.syncCount.plus.visible = false;
				if (AppModel.branch.remoteStatus == 0){
					_view.sync_btn.syncCount.visible = false;		
				}	else if (AppModel.branch.remoteStatus < 0){
					drawSyncCountBkgd(0xCC323E);
				}	else if (AppModel.branch.remoteStatus > 0){
					drawSyncCountBkgd(0x009FAF);
				}
			}	else{
				_view.sync_btn.syncCount.num.visible = false;
				_view.sync_btn.syncCount.plus.visible = true;				
			}			
			positionButtons(_view.sync_btn.syncCount.visible);
		}
		
		private function positionButtons(v:Boolean):void
		{
			if (v){
				TweenLite.to(_view.history_btn, .3, {x:60});
				TweenLite.to(_view.upload_btn, .3, {x:-20});
				TweenLite.to(_view.settings_btn, .3, {x:-60});
				TweenLite.to(_view.sync_btn, .2, {alpha:1, delay:.1});
			}	else{
				TweenLite.to(_view.sync_btn, .3, {alpha:0});
				TweenLite.to(_view.history_btn, .3, {x:40, delay:.1});
				TweenLite.to(_view.upload_btn, .3, {x:-0, delay:.1});
				TweenLite.to(_view.settings_btn, .3, {x:-40, delay:.1});
			}
		}
		
		private function drawSyncCountBkgd(c:uint):void
		{
			_view.sync_btn.syncCount.graphics.clear();
			_view.sync_btn.syncCount.graphics.beginFill(c);
			_view.sync_btn.syncCount.graphics.drawCircle(0, 0, 10);
			_view.sync_btn.syncCount.graphics.endFill();
			_view.sync_btn.syncCount.num.text =	Math.abs(AppModel.branch.remoteStatus);
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
			if (AppModel.branch.remoteStatus >= 0){
				checkBranchHasBeenPublished();
			}	else{
				if (AppModel.branch.isModified){
					AppModel.alert(new Message('Please saves your lastest changes before syncing with the server.'));
				}	else{
					AppModel.proxies.editor.mergeRemoteIntoLocal();
				}
			}
		}
		
		private function onHistoryButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_HISTORY));
		}
		
		private function checkBranchHasBeenPublished():void
		{
			if (AppModel.repository.hasBranch(AppModel.branch.name)){
				pushBranch();
			}	else {
				if (AppSettings.getSetting(AppSettings.PROMPT_NEW_REMOTE_BRANCHES) == false){
					pushBranch();
				}	else{
					confirmUnpublishedBranch();
				}
			}
		}
		
		private function pushBranch():void
		{
			AppModel.proxies.sync.pushBranch(AppModel.repository);
		}		
				
		private function confirmUnpublishedBranch():void 
		{
			var m:String = 'The current branch "'+AppModel.branch.name+'" has not yet been added to your '+AppModel.repository.acctType+' account.';
				m+= '\nAre you sure you\'d like to publish it online?';
			_confirm = new Confirm(m);
			_confirm.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.alert(_confirm);
		}
		
		private function onConfirm(e:UIEvent):void
		{
			if (e.data as Boolean == true) pushBranch();
		}			

	}
	
}
