package view {

	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.ui.SmartButton;
	import view.ui.Tooltip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SummaryView extends Sprite {

		private static var _icon		:Bitmap;
		private static var _bkgd		:Shape = new Shape();
		private static var _offset		:int;
		private static var _details		:MovieClip;
		private static var _view		:SummaryViewMC = new SummaryViewMC();
		private static var _fringe		:Bitmap = new Bitmap(new SummaryBkgdBottom());
		private static var _pattern		:BitmapData = new SummaryBkgdPattern();
		private static var _bold		:Font = new HelveticaBold() as Font;		
		private static var _bookmark	:Bookmark;
		private static var _tformat1	:TextFormat = new TextFormat();
		private static var _tformat2	:TextFormat = new TextFormat();
		private static var _glowSmall	:GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 3, 3);
		private static var _glowLarge	:GlowFilter = new GlowFilter(0xffffff, 1, 6, 6, 3, 3);

		public function SummaryView()
		{
			_view.x = 175;
			_details = _view.details;
			addChild(_bkgd);
			addChild(_view);
			addChild(_fringe);
			initButtons();
			initTextFields();
			this.filters = [new DropShadowFilter(5, 45, 0, .5, 10, 10)];
			AppModel.engine.addEventListener(BookmarkEvent.STATUS, onStatusReceived);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onBookmarkSelected);			
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
		
		private function initButtons():void
		{
			var l:Array = ['settings', 'pull remote', 'push remote', 'history'];
			var a:Array = [_details.settings_btn, _details.pull_btn, _details.push_btn, _details.history_btn];
			for (var i:int = 0; i < 4; i++) new SmartButton(a[i], new Tooltip(l[i]));
			_details.save_btn.over.alpha = 0;
			_details.pull_btn.addEventListener(MouseEvent.CLICK, onPullButton);
			_details.push_btn.addEventListener(MouseEvent.CLICK, onPushButton);
			_details.history_btn.addEventListener(MouseEvent.CLICK, onHistoryButton);
			_details.settings_btn.addEventListener(MouseEvent.CLICK, onSettingsButton);
		}

		private function initTextFields():void
		{
			_tformat1.color = 0x666666;
			_tformat1.letterSpacing = .7;
			_tformat1.bold = _bold.fontName;
			_tformat2.letterSpacing = 2;
			_view.name_txt.width = 200;
			_view.name_txt.wordWrap = true;
			_view.name_txt.multiline = true;
			_view.name_txt.filters = [_glowLarge];
			_details.version_txt.filters = [_glowSmall];
			_details.lastSaved_txt.filters = [_glowSmall]; 
			_view.name_txt.defaultTextFormat = _tformat2;
			_details.version_txt.defaultTextFormat = _tformat1;
			_details.lastSaved_txt.defaultTextFormat = _tformat1;
			_view.name_txt.autoSize = TextFieldAutoSize.CENTER;
			_details.version_txt.autoSize = TextFieldAutoSize.CENTER;
			_details.lastSaved_txt.autoSize = TextFieldAutoSize.CENTER;
		}

		private function onBookmarkSelected(e:BookmarkEvent):void
		{
			if (_bookmark) removeBookmarkListeners();
			_bookmark = e.data as Bookmark;
			_view.name_txt.text = _bookmark.label;
			_offset = (_view.name_txt.height-26)/2;
			_details.y = 20 + _offset;
			_view.name_txt.y = -_offset - 13;
			_view.name_txt.x = -_view.name_txt.width/2;
			getBookmarkIcon();
			addBookmarkListeners();
			showRemoteButtons(_bookmark.remote != null);
		}

		private function showRemoteButtons(b:Boolean):void
		{
			_details.pull_btn.visible = _details.push_btn.visible = b;
			_details.history_btn.x = b ? 58 : 20;
			_details.settings_btn.x = b ? -56 : -18;
		}

		private function addBookmarkListeners():void
		{
			_bookmark.addEventListener(BookmarkEvent.EDITED, onBookmarkEdited);			
			_bookmark.branch.addEventListener(BookmarkEvent.SUMMARY, onSummary);
		}
		
		private function removeBookmarkListeners():void
		{
			_bookmark.removeEventListener(BookmarkEvent.EDITED, onBookmarkEdited);			
			_bookmark.branch.removeEventListener(BookmarkEvent.SUMMARY, onSummary);
		}		

		private function onSummary(e:BookmarkEvent):void
		{
			_details.version_txt.text = 'Version #'+e.data.totalCommits as String;
			_details.lastSaved_txt.text = 'Last Saved : '+e.data.lastCommit.date;
		}

		private function onBookmarkEdited(e:BookmarkEvent):void
		{
			_view.name_txt.text = _bookmark.label;			
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

		private function onStatusReceived(e:BookmarkEvent):void
		{
			var m:uint = _bookmark.branch.modified;
			if (m > 0){
				_details.save_btn.over.alpha = 1;
				_details.save_btn.buttonMode = true;
				_details.save_btn.addEventListener(MouseEvent.CLICK, onSaveButton);
			}	else{
				_details.save_btn.over.alpha = 0;
				_details.save_btn.buttonMode = false;
				_details.save_btn.removeEventListener(MouseEvent.CLICK, onSaveButton);
			}
		}

	// button events //
		
		private function onSaveButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}		
		
		private function onHistoryButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_HISTORY));
			AppModel.proxies.history.getHistory();
		}
		
		private function onSettingsButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.EDIT_BOOKMARK, _bookmark));			
		}

	// TODO once we have remote integration //		
		private function onPushButton(e:MouseEvent):void 
		{ 
			trace("SummaryView.onPushButton(e)");
		}
		private function onPullButton(e:MouseEvent):void 
		{ 
			trace("SummaryView.onPullButton(e)");
		}
		
	}
	
}
