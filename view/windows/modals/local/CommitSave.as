package view.windows.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import model.AppModel;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Message;

	public class CommitSave extends ParentWindow {

		private static var _view:CommitMC = new CommitMC();

		public function CommitSave()
		{
			addChild(_view);
			super.addCloseButton();	
			super.drawBackground(550, 230);			
			super.title = 'Save Version';
			super.setHeading(_view, 'Write a short message so we can easily find this version again later.');
			super.addButtons([_view.ok_btn]);
			_view.textArea.message_txt.type = TextFieldType.INPUT;
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onCommit);
		}

		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			_view.textArea.message_txt.text = '';
			_view.textArea.message_txt.textFlow.interactionManager.setFocus();				
		}

		private function onCommit(e:MouseEvent):void 
		{
			if (_view.textArea.message_txt.text == ''){
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, new Message('Commit Message Cannot Be Empty.')));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				AppModel.proxies.editor.commit(_view.textArea.message_txt.text);
			}
		}
		
	}
	
}
