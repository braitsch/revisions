package view.bookmarks {

	import model.proxies.StatusProxy;
	import com.greensock.TweenLite;
	import events.BookmarkEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Bookmark;

	public class BookmarkListItem extends Sprite {

		private var _view			:BookmarkItem = new BookmarkItem();
		private var _icon			:Bitmap;
		private var _bookmark		:Bookmark;
		
		public function BookmarkListItem($bkmk:Bookmark)
		{
			_bookmark = $bkmk;
			_bookmark.addEventListener(BookmarkEvent.EDITED, onBookmarkEdited);
			_view.blue.alpha = 0;
			_view.label_txt.autoSize = 'left';
			_view.label_txt.selectable = false;
			_view.label_txt.text = _bookmark.label;
			_icon = _bookmark.icon32;
			_icon.y = 4;
			_icon.x = 5;
			_icon.width = _icon.height = 24;
			_icon.smoothing = true;
			addChild(_view);
			addChild(_icon);
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onBookmarkSelected);			
		}
		
		public function get bookmark():Bookmark
		{
			return _bookmark;
		}
		
		public function set active(b:Boolean):void
		{
			TweenLite.to(_view.blue, .5, {alpha: b ? 1 : 0});
		}
		
		private function onBookmarkEdited(e:BookmarkEvent):void 		{
			_view.label_txt.text = _bookmark.label;
		}

		private function onBookmarkSelected(e:MouseEvent):void
		{
			if (StatusProxy.working == false){
				AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, _bookmark));
			}
		}

	}
	
}
