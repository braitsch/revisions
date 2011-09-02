package view.modals.upload {

	import events.AppEvent;
	import view.modals.base.ModalWindow;
	import flash.events.Event;
	
	public class UploadWizard extends ModalWindow {

		private static var _status			:StatusBadge = new StatusBadge();
		private static var _view			:UploadWizardMC = new UploadWizardMC();
		private static var _chooseService	:ChooseService = new ChooseService();
		private static var _service			:String;
		
//		private static var _addBkmkToAcct		:AddBkmkToAccount = new AddBkmkToAccount();	
//		private static var _onBkmkAddedToAcct	:OnBkmkAddedToAcct = new OnBkmkAddedToAcct();		
//		AppModel.engine.addEventListener(AppEvent.BKMK_ADDED_TO_ACCOUNT, onBkmkAddedToAccount);

		public function UploadWizard()
		{
			addChild(_view);
			_view.addChildAt(_status, 0);
			super.addCloseButton();
			super.drawBackground(550, 300);
			super.addButtons([_view.cancel_btn, _view.next_btn]);
			super.setTitle(_view, 'Link To Account');
			_chooseService.addEventListener(AppEvent.SERVICE_SELECTED, onServiceSelected);
		}

		private function onServiceSelected(e:AppEvent):void
		{
			_status.page = 2;
			_service = _status.service = e.data as String;
		}

		override protected function onAddedToStage(e:Event):void
		{
			reset();
			_status.reset();
			super.onAddedToStage(e);
		}

		private function reset():void
		{
			_status.page = 1;
			addChild(_chooseService);
		}
		
	}
	
}
