package view.modals {
	import events.UIEvent;

	import model.AppModel;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class CommitChanges extends ModalWindow {

		private static var _view		:CommitMC = new CommitMC();

		public function CommitChanges()
		{
			addChild(_view);
			super.cancel = _view.cancel_btn;	
			super.addInputs(Vector.<TextField>([_view.note_txt]));			
			super.addButtons([_view.save_btn, _view.cancel_btn]);
			_view.save_btn.addEventListener(MouseEvent.CLICK, onCommit);			
		}

		private function onCommit(e:MouseEvent):void 
		{
			AppModel.proxies.editor.commit(_view.note_txt.text, false);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}
		
	}
	
}
