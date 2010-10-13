package view.modals {
	import commands.UICommand;

	import model.AppModel;

	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class DetachedBranch extends ModalWindow {

		private static var _view		:DetachedBranchMC = new DetachedBranchMC();

		public function DetachedBranch()
		{
			addChild(_view);
			super.addInputs(Vector.<TextField>([_view.name_txt]));				
			super.addButtons([_view.discard_btn, _view.branch_btn]);
			
			_view.branch_btn.addEventListener(MouseEvent.CLICK, onBranch);			
			_view.discard_btn.addEventListener(MouseEvent.CLICK, onDiscard);
		}

		private function onBranch(e:MouseEvent):void 
		{
			AppModel.proxy.branch.addBranch(_view.name_txt.text);
			dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));		}
		private function onDiscard(e:MouseEvent):void 
		{
		//	AppModel.repos.history.discardUnsavedChanges();
			dispatchEvent(new UICommand(UICommand.CLOSE_MODAL_WINDOW, this));
		}
		
	}
}
