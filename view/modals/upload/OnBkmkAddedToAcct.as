package view.modals.upload {

	import events.UIEvent;
	import model.AppModel;
	import model.remote.HostingAccount;
	import model.vo.BookmarkRemote;
	import system.StringUtils;
	import view.modals.base.ModalWindow;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class OnBkmkAddedToAcct extends ModalWindow {

		private static var _remote	:BookmarkRemote;
		private static var _view	:OnBkmkAddedToAcctMC = new OnBkmkAddedToAcctMC();
		private static var _home	:String;
		private static var _site	:String;
		
		public function OnBkmkAddedToAcct()
		{
			addChild(_view);
			super.addCloseButton();
			super.setTitle(_view, 'Nice Work!');
			super.drawBackground(550, 210);
			super.addButtons([_view.viewOnGH, _view.viewOnBS]);
			_view.viewMyGH.addEventListener(MouseEvent.CLICK, viewMyAcct);
			_view.viewMyBS.addEventListener(MouseEvent.CLICK, viewMyAcct);
			_view.viewOnGH.addEventListener(MouseEvent.CLICK, gotoMySite);
			_view.viewOnBS.addEventListener(MouseEvent.CLICK, gotoMySite);
		}
		
		public function set remote(r:BookmarkRemote):void
		{
			_remote = r;
			showButtons();
			showMessage();
		}

		private function showMessage():void
		{
			var a:String = StringUtils.capitalize(_remote.acctType);
			var m:String = 'You just pushed "'+AppModel.bookmark.label+'" up to a shiny new repository on '+a+'! ';
				m+='As you work, be sure to keep your bookmark & repository in sync by selecting ';
				m+='"Sync Remote" on the summary banner.';
			_view.textArea.message_txt.htmlText = m;
		}

		private function showButtons():void
		{
			if (_remote.acctType == HostingAccount.GITHUB){
				_home = UIEvent.GITHUB_HOME;
				_view.viewMyGH.visible = _view.viewOnGH.visible = true;
				super.defaultButton = _view.viewMyGH;
			}	else if (_remote.acctType == HostingAccount.BEANSTALK){
				_home = UIEvent.BEANSTALK_HOME;
				_view.viewMyGH.visible = _view.viewOnGH.visible = false;
				super.defaultButton = _view.viewMyBS;
			}
			_site = _remote.homePage;
		}
		
		override public function onEnterKey():void { viewMyAcct(); }
		private function viewMyAcct(e:MouseEvent = null):void
		{
			dispatchEvent(new UIEvent(_home));
		}
		
		private function gotoMySite(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(_site));
		}		

	}
	
}
