package view.windows.modals.local {

	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import view.type.TextHeading;
	import view.windows.base.ParentWindow;
	import view.windows.modals.system.Message;
	import flash.events.Event;
	import flash.text.TextFieldType;

	public class NewCommit extends ParentWindow {

		private static var _view	:CommitMC = new CommitMC();
		private static var _heading	:TextHeading;	

		public function NewCommit()
		{
			addChild(_view);
			super.addCloseButton();	
			super.drawBackground(550, 230);			
			super.title = 'Save Version';
			
			_heading = new TextHeading();
			addChild(_heading);
			
			addOkButton('Save');
			addEventListener(UIEvent.ENTER_KEY, onEnterKey);
			_view.textArea.message_txt.type = TextFieldType.INPUT;
		}
		
		public function set message(m:String):void
		{
			_heading.text = m;
		}

		override protected function onAddedToStage(e:Event):void
		{
			super.onAddedToStage(e);
			_view.textArea.message_txt.text = '';
			_view.textArea.message_txt.textFlow.interactionManager.setFocus();				
		}

		private function onEnterKey(e:UIEvent):void 
		{
			if (_view.textArea.message_txt.text == ''){
				AppModel.alert(new Message('Commit Message Cannot Be Empty.'));
			}	else{
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
				AppProxies.editor.commit(_view.textArea.message_txt.text);
			}
		}
		
	}
	
}
