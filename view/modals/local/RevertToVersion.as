package view.modals.local {

	import events.UIEvent;
	import flash.events.MouseEvent;
	import model.AppModel;
	import model.vo.Commit;
	import view.modals.ModalWindow;

	public class RevertToVersion extends ModalWindow {

		private static var _view		:RevertMC = new RevertMC();
		private static var _commit		:Commit;

		public function RevertToVersion()
		{
			addChild(_view);
			super.addCloseButton();	
			super.drawBackground(500, 243);		
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
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
		}

		private function onRevert(e:MouseEvent):void
		{
			AppModel.proxies.checkout.revert(_commit.sha1);			
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW));			
		}
		
	}
	
}
