package view.remote {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.remote.AccountManager;
	import model.remote.RemoteAccount;
	import view.modals.ModalWindow;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class GitHub extends ModalWindow {

		private static var _view		:GitHubMC = new GitHubMC();
		private static var _pages		:Vector.<Sprite> = new <Sprite>[];
		private static var _maxPerPage	:uint = 5;
		private static var _pageIndex	:uint = 0;
		private static var _model		:RemoteAccount;
		private static var _activePage	:Sprite;
		private static var _cloneURL	:String;

		public function GitHub()
		{
			addChild(_view);	
			_view.badgePage.page_txt.text = 'My Github';
			setupCustomURLField();
			addEventListener(UIEvent.CLONE, onCloneClick);		
			addEventListener(UIEvent.FILE_BROWSER_SELECTION, onBrowserSelection);
			AppModel.proxies.githubApi.addEventListener(AppEvent.GITHUB_READY, onGithubData);
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
			_model.avatar.y = 7;
			_model.avatar.x = -198;
			_view.badgeUser.addChild(_model.avatar);			
		}

		private function attachRepositories():void
		{
			var k:Array = [];
			var a:Array = _model.repositories;
			a.sortOn('name', Array.CASEINSENSITIVE);
			for (var i:int = 0; i < a.length; i++) {
				k.push(a[i]);
				if (k.length == _maxPerPage) {
					_pages.push(buildPage(k)); k = [];
				}
			}
			if (k.length > 0) _pages.push(buildPage(k));
			onRepositoriesReady();
		}
		
		private function buildPage(a:Array):Sprite
		{
			var p:Sprite = new Sprite();
			for (var i:int = 0; i < a.length; i++) {
				var rp:RepositoryItem = new RepositoryItem(a[i]);
				rp.y = 53 * i;
				p.addChild(rp);
			}
			return p;	
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
			_activePage.x = 10;
			_activePage.y = 90;
			_view.nav.pageCounter_txt.text = (_pageIndex+1)+' / '+_pages.length;			
			_pageIndex==0 ? enableButton(_view.nav.prev_btn, false) : enableButton(_view.nav.prev_btn, true);
			_pageIndex==_pages.length-1 ? enableButton(_view.nav.next_btn, false) : enableButton(_view.nav.next_btn, true);
			_view.addChild(_activePage);
		}

		private function positionURLAndNav():void
		{
			_view.nav.visible = _pages.length > 1;
			_view.custom.y = _activePage.y + _activePage.height + 10;
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
			_view.custom.clone_btn.buttonMode = true;
			_view.custom.clone_btn.addEventListener(MouseEvent.CLICK, onCustomClick);
			_view.custom.clone_btn.addEventListener(MouseEvent.ROLL_OVER, onCloneRollOver);
			_view.custom.clone_btn.addEventListener(MouseEvent.ROLL_OUT, onCloneRollOut);
			_view.custom.url_txt.addEventListener(MouseEvent.CLICK, onURLTextFocus);
		}

		private function onURLTextFocus(e:MouseEvent):void
		{
			_view.custom.url_txt.text = '';	
			_view.custom.url_txt.removeEventListener(MouseEvent.CLICK, onURLTextFocus);
		}

		private function onCloneClick(e:UIEvent):void
		{
			_cloneURL = e.data as String;
			showFileBrowser();
		}					
		
		private function onCustomClick(e:MouseEvent):void
		{
			if (!validate()) return;
			_cloneURL = _view.custom.url_txt.text;
			showFileBrowser();
		}

		private function validate():Boolean
		{
			var url:String = _view.custom.url_txt.text;
			if (url.indexOf('https://') != -1){
				var m:String = "Cloning over HTTP is not supported, please enter a url that starts with 'git@github.com' or 'git://'";
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));
				return false;
			}
			if (url.indexOf('git@github.com') == -1 && url.indexOf('git://') == -1){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, "Invalid URL : URL's should start with 'git@github.com' or 'git://'"));
				return false;				
			}
			return true;
		}

		private function showFileBrowser():void
		{
			super.browseForDirectory('Select a location to clone to');
		}

		private function onBrowserSelection(e:UIEvent):void
		{
			RemoteClone.getFromGitHub(_cloneURL, File(e.data).nativePath);
			AppModel.proxies.githubApi.addEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}

		private function onCloneComplete(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
			AppModel.proxies.githubApi.removeEventListener(AppEvent.CLONE_COMPLETE, onCloneComplete);			
		}
		
		private function onCloneRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		private function onCloneRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}		
		
	}
	
}
