package view.modals {

	import model.proxies.ConfigProxy;
	import events.UIEvent;
	import model.AppModel;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class GitAbout extends ModalWindow {
		
		private static var _view:GitAboutMC = new GitAboutMC();		

		public function GitAbout()
		{
			addChild(_view);
			super.addCloseButton();			
			super.addButtons([_view.ok_btn]);
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void
		{
			var c:ConfigProxy = AppModel.proxies.config;
			_view.message_txt.text = '';	
			_view.message_txt.appendText('Version : '+c.gitVersion+'\n');
			_view.message_txt.appendText('Installed at : '+c.gitInstall+'\n');
			_view.message_txt.appendText('Loaded from cache : '+c.loadedFromCache+'\n');
		}
		
		private function onOkButton(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
