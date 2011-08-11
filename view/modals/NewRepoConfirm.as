package view.modals {

	import events.UIEvent;
	import model.AppModel;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class NewRepoConfirm extends ModalWindow {

		private var _repository		:Object;
		private static var _view	:NewRepoConfirmMC = new NewRepoConfirmMC();

		public function NewRepoConfirm()
		{
			addChild(_view);
			super.addCloseButton();
			super.setTitle(_view, 'Success!');
			super.drawBackground(550, 210);
			super.addButtons([_view.viewOnGH]);
			super.defaultButton = _view.viewMyGH;
			_view.viewMyGH.addEventListener(MouseEvent.CLICK, onViewMyGH);
			_view.viewOnGH.addEventListener(MouseEvent.CLICK, onViewOnGH);
		}

		private function onViewOnGH(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(_repository.html_url));	
		}

		private function onViewMyGH(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.GITHUB_HOME));
		}

		public function set repository(o:Object):void
		{
			_repository = o;
			var m:String = 'You just pushed "'+AppModel.bookmark.label+'" up to a shiny new repository on GitHub! ';
			m+='As you work, be sure to keep your bookmark & repository in sync by selecting "Sync Remote" on the summary banner.';
			_view.textArea.message_txt.htmlText = m;
		}
		
	}
	
}
