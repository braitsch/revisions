package view.modals.bkmk {

	import view.ui.BasicButton;
	import model.remote.HostingAccount;
	import model.vo.Repository;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;

	public class RemoteItem extends Sprite {

		private var _remote	:Repository;
		private var _view	:RemoteItemMC = new RemoteItemMC();

		public function RemoteItem(rmt:Repository)
		{
			addChild(_view);
			_remote = rmt;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = rmt.acctName+' : '+rmt.repoName;
			_view.desc_txt.text = rmt.homePage;
			_view.name_txt.mouseEnabled = _view.name_txt.mouseChildren = false;
			_view.desc_txt.mouseEnabled = _view.desc_txt.mouseChildren = false;
			attachLogo();
			buttonMode = true;
			new BasicButton(_view.unlink);
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
			b.x = 10; b.y = 6;
			addChild(b);
		}

		private function onMouseClick(e:MouseEvent):void
		{
			if (e.target.name == 'unlink'){
				trace('unlinking');				
			}	else{
				navigateToURL(new URLRequest(_remote.homePage));
			}
		}
		
	}
	
}
