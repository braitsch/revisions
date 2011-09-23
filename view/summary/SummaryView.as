package view.summary {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.StringUtils;
	import view.fonts.Fonts;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SummaryView extends Sprite {

		private static var _icon		:Bitmap;
		private static var _bkgd		:Shape = new Shape();
		private static var _offset		:int;
		private static var _details		:MovieClip;
		private static var _view		:SummaryViewMC = new SummaryViewMC();
		private static var _options		:SummaryOptions = new SummaryOptions(_view.details.options);
		private static var _fringe		:Bitmap = new Bitmap(new SummaryBkgdBottom());
		private static var _pattern		:BitmapData = new SummaryBkgdPattern();
		private static var _bookmark	:Bookmark;
		private static var _tformat		:TextFormat = new TextFormat();
		private static var _glowSmall	:GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 3, 3);
		private static var _glowLarge	:GlowFilter = new GlowFilter(0xffffff, 1, 6, 6, 3, 3);

		public function SummaryView()
		{
			_view.x = 175;
			_details = _view.details;
			addChild(_bkgd);
			addChild(_view);
			addChild(_fringe);
			addChild(_options);
			initTextFields();
			_details.save_btn.over.alpha = 0;
			this.filters = [new DropShadowFilter(5, 45, 0, .5, 10, 10)];
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelected);
			AppModel.engine.addEventListener(AppEvent.SUMMARY_RECEIVED, drawView);
			AppModel.engine.addEventListener(AppEvent.HISTORY_RECEIVED, drawView);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, enableSaveButton);
			AppModel.engine.addEventListener(AppEvent.BKMK_ADDED_TO_ACCOUNT, onBkmkAddedToAcct);
			AppModel.proxies.editor.addEventListener(AppEvent.BRANCH_RENAMED, drawView);
		}

		public function resize(h:uint):void
		{
			_view.y = (h - 100) / 2;
			_fringe.y = h - 100;
			_bkgd.graphics.clear();
			_bkgd.graphics.beginBitmapFill(_pattern);
			_bkgd.graphics.drawRect(0, 0, 350, h - 100);
			_bkgd.graphics.endFill();
		}		
		
		private function initTextFields():void
		{
			_tformat.letterSpacing = 2;
			_view.name_txt.width = 200;
			_view.name_txt.wordWrap = true;
			_view.name_txt.multiline = true;
			_view.name_txt.filters = [_glowLarge];
			_details.branch_txt.filters = [_glowSmall];
			_details.version_txt.filters = [_glowSmall];
			_details.lastSaved_txt.filters = [_glowSmall]; 
			_view.name_txt.defaultTextFormat = _tformat;
			_details.branch_txt.defaultTextFormat = Fonts.helveticaBold;
			_details.version_txt.defaultTextFormat = Fonts.helveticaBold;
			_details.lastSaved_txt.defaultTextFormat = Fonts.helveticaBold;
			_view.name_txt.autoSize = TextFieldAutoSize.CENTER;
			_details.branch_txt.autoSize = TextFieldAutoSize.CENTER;
			_details.version_txt.autoSize = TextFieldAutoSize.CENTER;
			_details.lastSaved_txt.autoSize = TextFieldAutoSize.CENTER;
		}

		private function onSelected(e:BookmarkEvent):void
		{
			if (_bookmark) removeBookmarkListeners();
			_bookmark = e.data as Bookmark;
			_options.bookmark = _bookmark;
			onBookmarkEdited(e);
			addBookmarkListeners();
		}

		private function onBkmkAddedToAcct(e:AppEvent):void
		{
			_options.positionButtons(_bookmark.remotes.length > 0);
		}		

		private function addBookmarkListeners():void
		{
			_bookmark.addEventListener(BookmarkEvent.EDITED, onBookmarkEdited);			
		}
		
		private function removeBookmarkListeners():void
		{
			_bookmark.removeEventListener(BookmarkEvent.EDITED, onBookmarkEdited);			
		}		

		private function onBookmarkEdited(e:BookmarkEvent):void
		{
			_view.name_txt.text = _bookmark.label;
			_offset = (_view.name_txt.height-26)/2;
			_details.y = 20 + _offset;
			_view.name_txt.y = -_offset - 13;
			_view.name_txt.x = -_view.name_txt.width/2;
			getBookmarkIcon();
			_options.positionButtons(_bookmark.remotes.length > 0);
		}
		
		private function getBookmarkIcon():void
		{
			if (_icon) _view.removeChild(_icon);
			_icon = _bookmark.icon128;
			_icon.x = -64;
			_icon.y = -140 - _offset;
			_view.addChild(_icon);
		// offset file icons slightly so they're not so close to the main text //	
			if (_bookmark.type == Bookmark.FILE) _icon.y -= 10;
		}

		private function drawView(e:AppEvent):void
		{
		// ignore if we're not showing the bookmark that just updated //
			if (e.data != _bookmark) return;
			enableSaveButton();
			_details.version_txt.text = 'Version #'+_bookmark.branch.totalCommits as String;
			_details.lastSaved_txt.text = 'Last Saved : '+_bookmark.branch.lastCommit.date;
			_details.branch_txt.text = 'On Branch : '+StringUtils.capitalize(_bookmark.branch.name);			
		}
		
		private function enableSaveButton(a:AppEvent = null):void
		{
			if (_bookmark.branch.isModified){
				_details.save_btn.over.alpha = 1;
				_details.save_btn.buttonMode = true;
				_details.save_btn.addEventListener(MouseEvent.CLICK, onSaveButton);
			}	else{
				_details.save_btn.over.alpha = 0;
				_details.save_btn.buttonMode = false;
				_details.save_btn.removeEventListener(MouseEvent.CLICK, onSaveButton);
			}				
		}
		
		private function onSaveButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}		
		
	}
	
}
