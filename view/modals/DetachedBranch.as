package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import model.AppModel;
	import flash.events.MouseEvent;

	public class DetachedBranch extends ModalWindow {

		private static var _view		:DetachedBranchMC = new DetachedBranchMC();

		public function DetachedBranch()
		{
			addChild(_view);
			super.addInputs(Vector.<TLFTextField>([_view.name_txt]));				
			super.addButtons([_view.discard_btn, _view.branch_btn]);
			
			_view.branch_btn.addEventListener(MouseEvent.CLICK, onBranch);			
			_view.discard_btn.addEventListener(MouseEvent.CLICK, onDiscard);
		}

		private function onBranch(e:MouseEvent):void 
		{
			AppModel.proxies.checkout.addBranch(_view.name_txt.text);
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));		}
		private function onDiscard(e:MouseEvent):void 
		{
			AppModel.proxies.checkout.discardUnsavedChanges();
			dispatchEvent(new UIEvent(UIEvent.CLOSE_MODAL_WINDOW, this));
		}
		
	}
}
