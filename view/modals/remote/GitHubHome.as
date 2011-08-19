package view.modals.remote {

	import events.AppEvent;
	import events.UIEvent;
	import model.proxies.remote.AccountProxy;
	import model.remote.Account;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class GitHubHome extends AccountHome {

		private static var _view		:GitHubMC = new GitHubMC();
		private static var _proxy		:AccountProxy;

		public function GitHubHome(p:AccountProxy)
		{
			super(_view);
			_proxy = p;
			_view.badgePage.label_txt.text = 'My Github';
			_view.logOut.addEventListener(MouseEvent.CLICK, onLogOutClick);
			_proxy.addEventListener(AppEvent.LOGIN_SUCCESS, onLoginSuccess);	
			_proxy.addEventListener(AppEvent.LOGOUT_SUCCESS, onLogoutSuccess);	
		}

		private function onLoginSuccess(e:AppEvent):void
		{
			super.model = e.data as Account;
			if (e.data.avatarURL) loadAvatar(e.data.avatarURL);
		}
		
		private function loadAvatar(url:String):void
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onAvatarLoaded);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onAvatarFailure);
			ldr.load(new URLRequest(url));
		}	
		
		private function onAvatarLoaded(e:Event):void
		{
			var b:Bitmap = e.currentTarget.content as Bitmap;
				b.smoothing = true;
				b.x = b.y = 2;
				b.width = b.height = 26;
			var s:Sprite = new Sprite();
				s.addChild(b);
				s.graphics.beginFill(0x959595);
				s.graphics.drawRect(0, 0, 30, 30);
				s.graphics.endFill();
			super.avatar = s; 
		}
		
		private function onAvatarFailure(e:IOErrorEvent):void
		{
			trace("--------RemoteAccount.onAvatarFailure(e)--------");
		}						
		
		private function onLogOutClick(e:MouseEvent):void
		{
			_proxy.logout();
		}	
		
		private function onLogoutSuccess(e:AppEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}			
		
	}
	
}
