package view.bookmarks {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.Bookmark;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

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
			_view.mouseEnabled = true;
			_view.mouseChildren = false;
			_view.addEventListener(MouseEvent.CLICK, onBookmarkSelection);
			addChild(_view);
			_icon = _bookmark.icon32;
			_icon.y = 4;
			_icon.x = 5;
			_icon.width = _icon.height = 24;
			_icon.smoothing = true;
			addChild(_icon);
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

		private function onBookmarkSelection(e:MouseEvent):void
		{			AppModel.engine.dispatchEvent(new BookmarkEvent(BookmarkEvent.SELECTED, _bookmark));
		}

	}
	
}
