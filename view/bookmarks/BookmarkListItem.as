package view.bookmarks {

	import events.BookmarkEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.btns.ButtonIcon;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BookmarkListItem extends Sprite {

		private var _view			:BookmarkItem = new BookmarkItem();
		private var _icon			:ButtonIcon;
		private var _bookmark		:Bookmark;
		
		public function BookmarkListItem($bkmk:Bookmark)
		{
			_bookmark = $bkmk;
			_bookmark.addEventListener(BookmarkEvent.EDITED, onBookmarkEdited);
			_view.blue.alpha = 0;
			_view.label_txt.y = 11;
			_view.label_txt.selectable = false;
			_view.label_txt.text = _bookmark.label;
			addChild(_view);
			attachIcon();
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onBookmarkSelected);			
		}

		private function attachIcon():void
		{
			if (_bookmark.type == Bookmark.FILE){
				var b:Bitmap = _bookmark.icon32;
					b.smoothing = true;
					b.width = b.height = 24;
				_icon = new ButtonIcon(b, false, false);
				_icon.y = 6; _icon.x = 5;
			}	else{
				_icon = new ButtonIcon(new FolderIcon(), true, false); 
				_icon.y = 17; _icon.x = 17;
				_icon.scaleX = _icon.scaleY = .7;
			}
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

		private function onBookmarkSelected(e:MouseEvent):void
		{
			AppModel.bookmark = _bookmark;
		}

	}
	
}
