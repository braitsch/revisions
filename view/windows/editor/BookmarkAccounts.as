package view.windows.editor {

	import com.greensock.TweenLite;
	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Repository;
	import view.btns.DrawButton;
	import view.type.TextHeading;
	import view.windows.base.ChildWindow;
	import view.windows.modals.system.Confirm;

	public class BookmarkAccounts extends ChildWindow {

		private static var _item		:AccountItem;
		private static var _repo		:Repository;
		private static var _remotes		:Sprite = new Sprite();
		private static var _heading		:TextHeading = new TextHeading();
		private static var _linkBtn		:DrawButton = new DrawButton(320, 50, 'Link This Bookmark To An Online Account', 11);		

		public function BookmarkAccounts()
		{
			addChild(_remotes);
			addChild(_heading);
			addUnlinkButton();
			_remotes.x = 10; _remotes.y = 100;
			addEventListener(UIEvent.UNLINK_ACCOUNT, onUnlinkAccount);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);
			AppModel.engine.addEventListener(AppEvent.BKMK_REMOVED_FROM_ACCOUNT, onBkmkRemovedFromAcct);
		}
		
		private function addUnlinkButton():void
		{
			_linkBtn.x = 140; _linkBtn.y = 140;
			_linkBtn.addEventListener(MouseEvent.CLICK, onLinkToAccount);
			addChild(_linkBtn);
		}

		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			while(_remotes.numChildren) _remotes.removeChildAt(0);
			for (var i:int = 0; i < AppModel.bookmark.remotes.length; i++) {
				var ai:AccountItem = new AccountItem(AppModel.bookmark.remotes[i]);
					ai.y = 44 * i;
				_remotes.addChild(ai);
			}
			writeHeading();
		}

		private function writeHeading():void
		{
			var m:String;
			if (_remotes.numChildren){
				_linkBtn.visible = false;
				m = 'This bookmark is linked to the following online accounts:';
			}	else{
				_linkBtn.visible = true;
				m = 'It looks like you haven\'t pushed this bookmark online yet.\n';
				m+= 'Why not link it up to your Beanstalk or GitHub account?';
			}
			_heading.text = m;
		}
		
		private function onLinkToAccount(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.ADD_BKMK_TO_ACCOUNT));	
		}		
		
		private function onUnlinkAccount(e:UIEvent):void
		{
			_repo = e.data as Repository;
			_item = e.target as AccountItem;
			var m:String = 'You are about to unlink this bookmark from your '+_repo.acctType+' repository "'+_repo.repoName+'". ';
				m+='After unlinking you will not be able to sync with the copy of this bookmark that is on '+_repo.acctType+', ';
				m+='however those files will still be on their server so you can view them at anytime.\n';
				m+='Would you like to continue?';
			var k:Confirm = new Confirm(m);
				k.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, k));
		}

		private function onConfirm(e:UIEvent):void
		{
			if (e.data as Boolean == true) AppModel.proxies.remote.rmBkmkFromAccount(_repo);
		}

		private function onBkmkRemovedFromAcct(e:AppEvent):void
		{
			TweenLite.to(_item, .3, {alpha:0, onComplete:function():void
				{	_remotes.removeChild(_item); _item = null; writeHeading(); }
			});
		}
		
	}
	
}
