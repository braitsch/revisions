package view {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import system.StringUtils;
	import view.fonts.Fonts;
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
		private static var _bookmark	:Bookmark;
		private static var _locked		:Boolean;
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
			initButtons();
			initTextFields();
			this.filters = [new DropShadowFilter(5, 45, 0, .5, 10, 10)];
			AppModel.engine.addEventListener(AppEvent.REMOTE_SYNCED, onRemoteSynced);
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelected);
			AppModel.engine.addEventListener(BookmarkEvent.SUMMARY_RECEIVED, drawView);
			AppModel.engine.addEventListener(BookmarkEvent.HISTORY_RECEIVED, drawView);
			AppModel.engine.addEventListener(BookmarkEvent.MODIFIED_RECEIVED, enableSaveButton);
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
			var l:Array = ['Settings', 'Sync Remote', 'History'];
			var a:Array = [_details.settings_btn, _details.sync_btn, _details.history_btn];
			for (var i:int = 0; i < 3; i++) new SmartButton(a[i], new Tooltip(l[i]));
			_details.save_btn.over.alpha = 0;
			_details.sync_btn.addEventListener(MouseEvent.CLICK, onSyncButton);
			_details.history_btn.addEventListener(MouseEvent.CLICK, onHistoryButton);
			_details.settings_btn.addEventListener(MouseEvent.CLICK, onSettingsButton);
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
			onBookmarkEdited(e);
			addBookmarkListeners();
		}

		private function positionButtons(b:Boolean):void
		{
			_details.sync_btn.visible = b;
			_details.history_btn.x = b ? 40 : 20;
			_details.settings_btn.x = b ? -40 : -20;
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
			positionButtons(_bookmark.remotes.length > 0);
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

		private function drawView(e:BookmarkEvent):void
		{
		// ignore if we're not showing the bookmark that just updated //
			if (e.data != _bookmark) return;
			enableSaveButton();
			_details.version_txt.text = 'Version #'+_bookmark.branch.totalCommits as String;
			_details.lastSaved_txt.text = 'Last Saved : '+_bookmark.branch.lastCommit.date;
			_details.branch_txt.text = 'On Branch : '+StringUtils.capitalize(_bookmark.branch.name);			
		}
		
		private function enableSaveButton(a:BookmarkEvent = null):void
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
		
	// button events //
		
		private function onSyncButton(e:MouseEvent):void 
		{
			if (!_locked) syncRemote(); 
		}
				
		private function onSaveButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}		
		
		private function onHistoryButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_HISTORY));
		}
		
		private function onSettingsButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.EDIT_BOOKMARK, _bookmark));			
		}
		
		private function syncRemote():void
		{
			var m:String;
//			if (_bookmark.branch.modified){
//				m = 'Please saves your lastest changes before syncing with the server.';
//			}	else if (_bookmark.remotes.length != 1){
//				m = 'This bookmark has multiple remotes. A remote chooser is coming very soon.';
//			}
			if (m){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
			}	else{
				_locked = true;
				AppModel.proxies.remote.syncRemotes(_bookmark.remotes);
			}
		}

		private function onRemoteSynced(e:AppEvent):void { _locked = false; }
		
	}
	
}
