package view.windows.modals.git {

	import events.UIEvent;
	import flash.events.Event;
	import model.AppModel;
	import model.proxies.local.ConfigProxy;
	import view.windows.base.ParentWindow;

	public class GitAbout extends ParentWindow {
		
		private static var _view:GitAboutMC = new GitAboutMC();		

		public function GitAbout()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 210);
			super.title = 'About Git';
			super.defaultButton = _view.ok_btn;
			addEventListener(UIEvent.ENTER_KEY, onOkButton);
		}

		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			var c:ConfigProxy = AppModel.proxies.config;
			_view.textArea.message_txt.text = '';	
			_view.textArea.message_txt.appendText('Version : '+c.gitVersion+'\n');
			_view.textArea.message_txt.appendText('Installed at : '+c.gitInstall+'\n');
			_view.textArea.message_txt.appendText('Loaded from cache : '+c.loadedFromCache+'\n');
		}
		
		private function onOkButton(e:Event):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
