package view.modals.bkmk {

	import model.remote.HostingAccount;
	import model.vo.BookmarkRemote;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;

	public class RemoteItem extends Sprite {

		private var _remote	:BookmarkRemote;
		private var _view	:RemoteItemMC = new RemoteItemMC();

		public function RemoteItem(rmt:BookmarkRemote)
		{
			addChild(_view);
			_remote = rmt;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = rmt.acctName+' : '+rmt.repoName.substr(0, -4);
			_view.desc_txt.text = 'last updated : info not available';
			attachLogo();
			buttonMode = true; mouseChildren = false;
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function attachLogo():void
		{
			var b:Bitmap;
			if (_remote.acctType == HostingAccount.GITHUB){
				b = new Bitmap(new GitHub30());
			}	else if (_remote.acctType == HostingAccount.BEANSTALK){
				b = new Bitmap(new Beanstalk30());
			}
			b.x = 11; b.y = 6;
			addChild(b);
		}

		private function onMouseClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(_remote.homePage));
		}
		
	}
	
}
