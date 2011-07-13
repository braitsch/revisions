package view.modals {

	import events.AppEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import model.remote.RepositoryList;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;

	public class GitHub extends ModalWindow {

		private static var _view		:GitHubMC = new GitHubMC();
		private static var _badgeGlow	:GlowFilter = new GlowFilter(0x000000, .5, 20, 10, 1, 3);
		private static var _labelGlow	:GlowFilter = new GlowFilter(0x000000, .3, 5, 5, 1, 3);
		private static var _pages		:Vector.<RepositoryList> = new <RepositoryList>[];
		private static var _maxPerPage	:uint = 5;
		private static var _pageIndex	:uint = 0;
		private static var _model		:RemoteAccount;
		private static var _activePage	:RepositoryList;

		public function GitHub()
		{
			addChild(_view);	
			_view.badgePage.page_txt.text = 'My Github';
			_view.badgePage.page_txt.filters = [_badgeGlow];
			_view.badgePage.filters = _view.badgeUser.filters = [_badgeGlow];
			_view.nav.pageCounter_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.nav.pageCounter_txt.filters = _view.repositories_txt.filters = [_labelGlow];
			setupCustomURLField();
		//	createTempData();
			AppModel.proxies.github.addEventListener(AppEvent.GITHUB_READY, onGithubData);
		}

		private function onGithubData(e:AppEvent):void
		{
			_model = AccountManager.github;
			if (_model.avatar) {
				attachAvatar();
			}	else{
				_model.addEventListener(AppEvent.AVATAR_LOADED, attachAvatar);
			}
			attachRepositories();
			_view.badgeUser.user_txt.text = _model.realName+' - '+_model.location;
		}

		private function attachAvatar(e:AppEvent = null):void
		{
			_model.avatar.y = -15;
			_model.avatar.x = -198;
			_view.badgeUser.addChild(_model.avatar);			
		}

		private function attachRepositories():void
		{
			var k:Array = [];
			var a:Array = _model.repositories;
			for (var i:int = 0; i < a.length; i++) {
				if (i % _maxPerPage == 0) k = [];
				k.push(a[i]);
				if (k.length == _maxPerPage) _pages.push(new RepositoryList(k));
			}
			_pages.push(new RepositoryList(k));
			onRepositoriesReady();
		}
		
		private function onRepositoriesReady():void
		{
			showPage(0);
			positionURLAndNav();
			drawBackground();
			super.addCloseButton();			
		}

		private function showPage(n:uint):void
		{
			if (_activePage) _view.removeChild(_activePage);
			_pageIndex = n;
			_activePage = _pages[_pageIndex];
			_activePage.x = 251;
			_activePage.y = _view.repositories_txt.y + 40;
			_view.nav.pageCounter_txt.text = 'Page '+(_pageIndex+1)+' of '+_pages.length;			
			_pageIndex==0 ? enableButton(_view.nav.prev_btn, false) : enableButton(_view.nav.prev_btn, true);
			_pageIndex==_pages.length-1 ? enableButton(_view.nav.next_btn, false) : enableButton(_view.nav.next_btn, true);
			_view.addChild(_activePage);
		}

		private function positionURLAndNav():void
		{
			_view.nav.visible = _pages.length > 1;
			_view.nav.y = _view.repositories_txt.y = 68;
			_view.custom.y = _view.height + 10;
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
		
		private function drawBackground():void
		{
			var w:uint = 590;
			var h:uint = _view.height + 30;
			_view.graphics.beginFill(0xFFFFFF);
			_view.graphics.drawRect(0, 0, w, h);
			_view.graphics.endFill();
			_view.graphics.beginBitmapFill(new LtGreyPattern());
			_view.graphics.drawRect(4, 4, w-8, h-8);
			_view.graphics.endFill();
		}
		
		private function setupCustomURLField():void
		{
			_view.custom.label_txt.filters = [_labelGlow];
			_view.custom.clone_btn.buttonMode = true;
			_view.custom.clone_btn.addEventListener(MouseEvent.CLICK, onCloneClick);
			_view.custom.clone_btn.addEventListener(MouseEvent.ROLL_OVER, onCloneRollOver);
			_view.custom.clone_btn.addEventListener(MouseEvent.ROLL_OUT, onCloneRollOut);
			_view.custom.url_txt.addEventListener(MouseEvent.CLICK, onURLTextFocus);
		}

		private function onURLTextFocus(e:MouseEvent):void
		{
			_view.custom.url_txt.text = '';	
			_view.custom.url_txt.removeEventListener(MouseEvent.CLICK, onURLTextFocus);
		}

		private function onCloneClick(e:MouseEvent):void
		{
			trace("GitHub.onCloneClick(e)", _view.custom.url_txt.text);
		}		
		
		private function onCloneRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		private function onCloneRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}		

		
//		private function createTempData():void
//		{
//			var a:Array = [];
//			for (var i:int = 0; i < 87; i++) {
//				var o:Object = {};
//				o.name = 'repository # '+(i+1);
//				o.description = 'this is description : '+(i+1);
//				o.url = 'some remote url '+(i+1);
//				a.push(o);
//			}
//			temp(a);
//			_view.badgeUser.user_txt.text = 'Michael Jackson - San Francisco, CA';
//		}	
//		
//		private function temp(a:Array):void
//		{
//			var k:Array = [];
//			for (var i:int = 0; i < a.length; i++) {
//				if (i % _maxPerPage == 0) k = [];
//				k.push(a[i]);
//				if (k.length == _maxPerPage) _pages.push(new RepositoryList(k));
//			}
//			_pages.push(new RepositoryList(k));
//			onRepositoriesReady();
//		}			
		
	}
	
}
