package view.modals {

	import events.UIEvent;
	import model.remote.RepositoryList;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;

	public class GitHub extends ModalWindow {

		private static var _view		:GitHubMC = new GitHubMC();
		private static var _page		:GlowFilter = new GlowFilter(0x000000, .5, 15, 15, 2, 3);
		private static var _labels		:GlowFilter = new GlowFilter(0x000000, .3, 5, 5, 1, 3);
		private static var _pages		:Vector.<RepositoryList> = new <RepositoryList>[];
		private static var _maxPerPage	:uint = 5;
		private static var _pageIndex	:uint = 0;
		private static var _activePage	:RepositoryList;

		public function GitHub()
		{
			addChild(_view);	
			super.addButtons([_view.ok_btn]);	
			_view.page_txt.text = 'My Github';
			_view.page_txt.filters = [_page];
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			_view.nav.pageCounter_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.nav.pageCounter_txt.filters = _view.repositories_txt.filters = [_labels];
		// temp //	
			createTempData();
		}

		private function createTempData():void
		{
			var a:Array = [];
			for (var i:int = 0; i < 132; i++) {
				var o:Object = {};
				o.name = 'repository # '+(i+1);
				o.description = 'this is description : '+(i+1);
				o.url = 'some remote url '+(i+1);
				a.push(o);
			}
			this.repositories = a;
			this.user = 'Michael Jackson - San Francisco, CA';
		}
		
		public function set user(s:String):void
		{
			_view.user_txt.text = s;
		}
		
		public function set repositories(a:Array):void
		{
			var k:Array = [];
			for (var i:int = 0; i < a.length; i++) {
				if (i % _maxPerPage == 0) k = [];
				k.push(a[i]);
				if (k.length == _maxPerPage) _pages.push(new RepositoryList(k));
			}
		// whatever's left over //	
			_pages.push(new RepositoryList(k));
		// add the first page /
			showPage(_pageIndex);
			positionNav();
			drawBackground(500, 130+_activePage.height+20);
			super.addCloseButton();
		}

		private function positionNav():void
		{
			_view.nav.visible = _pages.length > 1;
			_view.nav.pageCounter_txt.text = 'Page 1 of '+_pages.length;
			var w:uint = _view.nav.pageCounter_txt.width;
			_view.nav.next_btn.x = w/2 + 20;
			_view.nav.prev_btn.x = -w/2 - 18;
			_view.nav.pageCounter_txt.x = -w/2;			
		}

		private function showPage(n:uint):void
		{
			if (_activePage) removeChild(_activePage);
			_pageIndex = n;
			_activePage = _pages[_pageIndex];
			_activePage.x = 250;
			_activePage.y = 110;
			_view.nav.pageCounter_txt.text = 'Page '+(_pageIndex+1)+' of '+_pages.length;			
			_pageIndex==0 ? enableButton(_view.nav.prev_btn, false) : enableButton(_view.nav.prev_btn, true);
			_pageIndex==_pages.length-1 ? enableButton(_view.nav.next_btn, false) : enableButton(_view.nav.next_btn, true);
			addChild(_activePage);
		}
		
		override protected function enableButton(btn:Sprite, b:Boolean):void
		{
			if (b){
				btn.alpha = 1;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, onNavClick);
			}	else{
				btn.alpha = .5;
				btn.buttonMode = false;
				btn.removeEventListener(MouseEvent.CLICK, onNavClick);				
			}
		}	
		
		private function onNavClick(e:MouseEvent):void
		{
			if (e.target.name == 'next_btn'){
				showPage(++_pageIndex);
			}	else if (e.target.name == 'prev_btn'){
				showPage(--_pageIndex);
			}
		}
		
		private function drawBackground(w:int, h:int):void
		{
			_view.graphics.beginFill(0xFFFFFF);
			_view.graphics.drawRect(0, 0, w, h);
			_view.graphics.endFill();
			_view.graphics.beginBitmapFill(new LtGreyPattern());
			_view.graphics.drawRect(2, 2, w-4, h-4);
			_view.graphics.endFill();
			_view.ok_btn.y = _view.nav.y = h - 20 - 10;
		}
		
		override public function onEnterKey():void { onOkButton(); }		
		private function onOkButton(e:MouseEvent = null):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}	
		
	}
	
}