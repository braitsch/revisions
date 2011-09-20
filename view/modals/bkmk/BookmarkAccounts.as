package view.modals.bkmk {

	import flash.events.MouseEvent;
	import view.ui.BasicButton;
	import view.modals.system.Confirm;
	import com.greensock.TweenLite;
	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import model.vo.Repository;
	import view.modals.base.ModalWindowBasic;
	import flash.display.Sprite;

	public class BookmarkAccounts extends ModalWindowBasic {

		private static var _view		:BookmarkAccountsMC = new BookmarkAccountsMC();
		private static var _bookmark	:Bookmark;
		private static var _item		:AccountItem;
		private static var _repo		:Repository;
		private static var _remotes		:Sprite = new Sprite();

		public function BookmarkAccounts()
		{
			addChild(_view); 
			addChild(_remotes);
			new BasicButton(_view.linkBtn);
			_view.linkBtn.addEventListener(MouseEvent.CLICK, onLinkToAccount);
			addEventListener(UIEvent.UNLINK_ACCOUNT, onUnlinkAccount);
			AppModel.engine.addEventListener(AppEvent.BKMK_REMOVED_FROM_ACCOUNT, onBkmkRemovedFromAcct);
		}

		public function set bookmark(b:Bookmark):void
		{
			_bookmark = b;
			attachRemotes();
		}

		private function attachRemotes():void
		{
			while(_remotes.numChildren) _remotes.removeChildAt(0);
			for (var i:int = 0; i < _bookmark.remotes.length; i++) {
				var ri:AccountItem = new AccountItem(_bookmark.remotes[i]);
					ri.y = 44 * i;
				_remotes.addChild(ri);
			}
			_remotes.x = 10; _remotes.y = 100;
			writeHeading();
		}

		private function writeHeading():void
		{
			var m:String;
			if (_remotes.numChildren){
				_view.linkBtn.visible = false;
				m = 'This bookmark is linked to the following online accounts:';
			}	else{
				_view.linkBtn.visible = true;
				m = 'It looks like you haven\'t pushed this bookmark online yet.\n';
				m+= 'Why not link it up to your Beanstalk or GitHub account?';
			}
			super.setHeading(_view, m);
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
