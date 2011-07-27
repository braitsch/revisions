package view.modals {

	import events.AppEvent;
	import flash.events.Event;
	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import flash.events.MouseEvent;

	public class NewCommit extends ModalWindow {

		private static var _view		:WindowCommitMC = new WindowCommitMC();

		public function NewCommit()
		{
			addChild(_view);
			super.addCloseButton();			
			super.addButtons([_view.save_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.note_txt]));
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_view.save_btn.addEventListener(MouseEvent.CLICK, onCommit);
		}

		private function onAddedToStage(e:Event):void
		{
			_view.note_txt.text = '';
		}

		override public function onEnterKey():void { onCommit(); }
		private function onCommit(e:MouseEvent = null):void 
		{
			if (_view.note_txt.text == ''){
				var m:String = 'Commit Message Cannot Be Empty.';
				AppModel.engine.dispatchEvent(new AppEvent(AppEvent.SHOW_ALERT, m));				
			}	else{
				AppModel.proxies.editor.commit(_view.note_txt.text);
				dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));
			}
		}
		
	}
	
}
