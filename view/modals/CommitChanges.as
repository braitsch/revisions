package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import flash.events.MouseEvent;

	public class CommitChanges extends ModalWindow {

		private static var _view		:CommitMC = new CommitMC();

		public function CommitChanges()
		{
			addChild(_view);
			super.addInputs(Vector.<TLFTextField>([_view.note_txt]));			
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
