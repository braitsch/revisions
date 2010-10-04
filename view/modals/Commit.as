package view.modals {
	import commands.UICommand;

	import model.AppModel;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Commit extends ModelWindow {

		private static var _view		:CommitMC = new CommitMC();

		public function Commit()
		{
			addChild(_view);
			super.cancel = _view.cancel_btn;	
			super.addInputs(Vector.<TextField>([_view.note_txt]));			
			super.addButtons([_view.save_btn, _view.cancel_btn]);
			_view.save_btn.addEventListener(MouseEvent.CLICK, onCommit);			
		}

		private function onCommit(e:MouseEvent):void 
		{
			AppModel.editor.commit(_view.note_txt.text);
			dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));
		}
		
	}
	
}
