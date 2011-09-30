package view.windows.editor {

	import events.UIEvent;
	import model.remote.HostingAccount;
	import model.vo.Repository;
	import view.btns.FormButton;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;

	public class AccountItem extends Sprite {

		private var _repo	:Repository;
		private var _view	:AccountItemMC = new AccountItemMC();
		private var _unlink	:FormButton = new FormButton('Unlink');

		public function AccountItem(rmt:Repository)
		{
			addChild(_view);
			_repo = rmt;
			_view.name_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.desc_txt.autoSize = TextFieldAutoSize.LEFT;
			_view.name_txt.text = rmt.acctName+' : '+rmt.repoName;
			_view.desc_txt.text = rmt.homePage;
			_view.name_txt.mouseEnabled = _view.name_txt.mouseChildren = false;
			_view.desc_txt.mouseEnabled = _view.desc_txt.mouseChildren = false;
			attachLogo();
			buttonMode = true;
			attachUnlinkBtn();
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function attachLogo():void
		{
			var b:Bitmap;
			if (_repo.acctType == HostingAccount.GITHUB){
				b = new Bitmap(new GitHub30());
			}	else if (_repo.acctType == HostingAccount.BEANSTALK){
				b = new Bitmap(new Beanstalk30());
			}
			b.x = 10; b.y = 6;
			addChild(b);
		}
		
		private function attachUnlinkBtn():void
		{
			_unlink.y = 6;
			_unlink.x = 454;			
			addChild(_unlink);
		}

		private function onMouseClick(e:MouseEvent):void
		{
			if (e.target != _unlink){
				navigateToURL(new URLRequest(_repo.homePage));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.UNLINK_ACCOUNT, _repo));
			}
		}
		
	}
	
}
