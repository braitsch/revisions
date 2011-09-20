package view.modals.bkmk {

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
		private static var _remotes		:Sprite = new Sprite();

		public function BookmarkAccounts()
		{
			addChild(_view); 
			addChild(_remotes);
			super.setHeading(_view, 'This bookmark is linked to the following accounts: (features coming soon)');
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
		}
		
		private function onUnlinkAccount(e:UIEvent):void
		{
			_item = e.target as AccountItem;
			AppModel.proxies.remote.rmBkmkFromAccount(e.data as Repository);
		}

		private function onBkmkRemovedFromAcct(e:AppEvent):void
		{
			TweenLite.to(_item, .3, {alpha:0, onComplete:function():void
				{	_remotes.removeChild(_item); _item = null; }
			});
		}
		
	}
	
}
