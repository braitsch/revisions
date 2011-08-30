package view.modals.git {

	import events.UIEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.proxies.local.ConfigProxy;
	import view.modals.base.ModalWindow;

	public class GitAbout extends ModalWindow {
		
		private static var _view:GitAboutMC = new GitAboutMC();		

		public function GitAbout()
		{
			addChild(_view);
			super.addCloseButton();
			super.drawBackground(550, 210);
			super.setTitle(_view, 'About Git');
			super.defaultButton = _view.ok_btn;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onOkButton);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		override protected function onAddedToStage(e:Event):void
		{
			var c:ConfigProxy = AppModel.proxies.config;
			_view.textArea.message_txt.text = '';	
			_view.textArea.message_txt.appendText('Version : '+c.gitVersion+'\n');
			_view.textArea.message_txt.appendText('Installed at : '+c.gitInstall+'\n');
			_view.textArea.message_txt.appendText('Loaded from cache : '+c.loadedFromCache+'\n');
		}
		
		override public function onEnterKey():void { onOkButton(); }			
		private function onOkButton(e:MouseEvent = null):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
		}
		
	}
	
}
