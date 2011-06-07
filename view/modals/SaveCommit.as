package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class SaveCommit extends ModalWindow {

		private static var _view		:SaveCommitMC = new SaveCommitMC();

		public function SaveCommit()
		{
			addChild(_view);
			_view.save_btn.addChild(new Bitmap(new LabelOk()));			
			_view.save_btn.addEventListener(MouseEvent.CLICK, onCommit);			
			super.addButtons([_view.save_btn]);
			super.addInputs(Vector.<TLFTextField>([_view.note_txt]));
			_view.note_txt.text = 'Final edits to client presentation. Ready for Peer Review.';
		}

		private function onCommit(e:MouseEvent):void 
		{
			AppModel.proxies.editor.commit(_view.note_txt.text, false);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}
		
	}
	
}
