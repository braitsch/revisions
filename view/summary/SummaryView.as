package view.summary {

	import events.AppEvent;
	import events.BookmarkEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Bookmark;
	import view.btns.DrawButton;
	import view.graphics.PatternBox;
	import view.type.Fonts;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SummaryView extends Sprite {

		private static var _icon		:Bitmap;
		private static var _bkgd		:PatternBox = new PatternBox(new SummaryBkgdPattern());
		private static var _offset		:int;
		private static var _saveBtn		:DrawButton = new DrawButton(184, 35, 'Save Version');
		private static var _details		:MovieClip;
		private static var _view		:SummaryViewMC = new SummaryViewMC();
		private static var _options		:SummaryOptions = new SummaryOptions(_view.details.options);
		private static var _fringe		:Bitmap = new Bitmap(new SummaryBkgdBottom());
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
			addListeners();
			addSaveButton();
			initTextFields();
			this.filters = [new DropShadowFilter(5, 45, 0, .5, 10, 10)];
		}

		public function resize(h:uint):void
		{
			_view.y = h / 2;
			_fringe.y = h;
			_bkgd.draw(350, h);
		}		
		
		private function initTextFields():void
		{
			_tformat.letterSpacing = 2;
			_view.name_txt.width = 200;
			_view.name_txt.wordWrap = true;
			_view.name_txt.multiline = true;
			_view.name_txt.filters = [_glowLarge];
			_details.version_txt.filters = [_glowSmall];
			_details.lastSaved_txt.filters = [_glowSmall]; 
			_view.name_txt.defaultTextFormat = _tformat;
			_details.version_txt.defaultTextFormat = Fonts.helveticaBold;
			_details.lastSaved_txt.defaultTextFormat = Fonts.helveticaBold;
			_view.name_txt.autoSize = TextFieldAutoSize.CENTER;
			_details.version_txt.autoSize = TextFieldAutoSize.CENTER;
			_details.lastSaved_txt.autoSize = TextFieldAutoSize.CENTER;
		}
		
		private function addSaveButton():void
		{
			_saveBtn.y = 100;
			_saveBtn.x = -_saveBtn.width / 2;
 			_details.addChild(_saveBtn);
			_saveBtn.addEventListener(MouseEvent.CLICK, onSaveButton);
		}
		
		private function addListeners():void
		{
			AppModel.engine.addEventListener(BookmarkEvent.SELECTED, onSelected);
			AppModel.engine.addEventListener(AppEvent.SUMMARY_RECEIVED, drawView);
			AppModel.engine.addEventListener(AppEvent.MODIFIED_RECEIVED, drawView);
		}

		private function onSelected(e:BookmarkEvent):void
		{
			setTextFields();
			getBookmarkIcon();
		}

		private function setTextFields():void
		{
			_view.name_txt.text = AppModel.bookmark.label;
			_offset = (_view.name_txt.height - 26) / 2;
			_details.y = 20 + _offset;
			_view.name_txt.y = -_offset - 13;
			_view.name_txt.x = -_view.name_txt.width / 2;
		}
		
		private function getBookmarkIcon():void
		{
			if (_icon) _view.removeChild(_icon);
			_icon = AppModel.bookmark.icon128;
			_icon.x = -64;
			_icon.y = -140 - _offset;
			_view.addChild(_icon);
			if (AppModel.bookmark.type == Bookmark.FILE) _icon.y -= 10;
		}
		
		private function drawView(e:AppEvent):void
		{
			if (this.visible == false) return;
			_saveBtn.enabled = AppModel.branch.isModified;
			_details.version_txt.text = 'Version #'+AppModel.branch.totalCommits as String;
			_details.lastSaved_txt.text = 'Last Saved : '+AppModel.branch.lastCommit.date;
		}
		
		private function onSaveButton(e:MouseEvent):void
		{
			if (_saveBtn.enabled) dispatchEvent(new UIEvent(UIEvent.COMMIT));
		}		
		
	}
	
}
