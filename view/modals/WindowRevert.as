package view.modals {

	import events.UIEvent;
	import model.AppModel;
	import model.Commit;
	import flash.events.MouseEvent;

	public class WindowRevert extends ModalWindow {

		private static var _view		:WindowRevertMC = new WindowRevertMC();
		private static var _commit		:Commit;

		public function WindowRevert()
		{
			addChild(_view);
			super.addButtons([_view.revert_btn, _view.cancel_btn]);
			_view.revert_btn.addEventListener(MouseEvent.CLICK, onRevert);
			_view.cancel_btn.addEventListener(MouseEvent.CLICK, onCancel);
		}
		
		public function set commit(cmt:Commit):void
		{
			_commit = cmt;
			_view.message_txt.text = 'Are you sure you want to revert "'+AppModel.bookmark.label;
			_view.message_txt.text+= '" back to revision "'+_commit.note+'" aka what it looked like '+_commit.date+' ago?';
		}

		private function onCancel(e:MouseEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));			
		}

		private function onRevert(e:MouseEvent):void
		{
			trace("WindowRevert.onRevert(e) ------ revert!!!!");
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));			
		}
		
	}
	
}
