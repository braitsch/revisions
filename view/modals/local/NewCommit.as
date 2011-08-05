package view.modals.local {

	import flash.text.TextFieldType;
	import events.AppEvent;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import view.modals.ModalWindow;

	public class NewCommit extends ModalWindow {

		private static var _view:CommitMC = new CommitMC();

		public function NewCommit()
		{
			addChild(_view);
			super.addCloseButton();	
			super.drawBackground(550, 230);			
			super.setTitle(_view, 'Save Version');
			super.setHeading(_view, 'Write a short message so we can easily find this version again later.');
			super.addButtons([_view.ok_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.textArea.message_txt]));
			_view.ok_btn.addEventListener(MouseEvent.CLICK, onCommit);
			_view.textArea.message_txt.type = TextFieldType.INPUT;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void
		{
			_view.textArea.message_txt.text = '';
		}

		override public function onEnterKey():void { onCommit(); }
		private function onCommit(e:MouseEvent = null):void 
		{
			if (_view.textArea.message_txt.text == ''){
				var m:String = 'Commit Message Cannot Be Empty.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));				
			}	else{
				AppModel.proxies.editor.commit(_view.textArea.message_txt.text);
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}
		
	}
	
}
