package view.modals.upload {

	import events.UIEvent;
	import view.modals.base.ModalWindow;
	import view.modals.base.ModalWindowBasic;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class UploadWizard extends ModalWindow {

		private static var _status			:StatusBadge = new StatusBadge();
		private static var _view			:UploadWizardMC = new UploadWizardMC();
		private static var _service1		:Service1 = new Service1();
		private static var _account2		:Account2 = new Account2();
		private static var _repository3		:Repository3 = new Repository3();
		private static var _mask			:Shape = new Shape();
		private static var _page			:ModalWindowBasic;
		private static var _service			:String;
		
//		private static var _addBkmkToAcct		:AddBkmkToAccount = new AddBkmkToAccount();	
//		private static var _onBkmkAddedToAcct	:OnBkmkAddedToAcct = new OnBkmkAddedToAcct();		
//		AppModel.engine.addEventListener(AppEvent.BKMK_ADDED_TO_ACCOUNT, onBkmkAddedToAccount);

		public function UploadWizard()
		{
			addChild(_view);
			addChild(_mask);
			drawMask(550, 300);
			_view.addChild(_status);
			super.addCloseButton();
			super.drawBackground(550, 300);
			super.setTitle(_view, 'Link To Account');
			addEventListener(UIEvent.WIZARD_PREV, onWizardPrev);
			addEventListener(UIEvent.WIZARD_NEXT, onWizardNext);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

	// page navigation //

		private function onWizardNext(e:UIEvent):void
		{
			switch(e.target){
				case _service1 : 
					_status.page = 2;
					nextPage(_account2);
					setService(e.data as String);
				break;	
				case _account2 : 
					_status.page = 3;
					nextPage(_repository3);
				break;
			}
		}

		private function setService(s:String):void
		{
			_service = _status.service = s;
			_account2.service = _repository3.service = s;
		}

		private function onWizardPrev(e:UIEvent):void
		{
			switch(e.target){
				case _account2 : 
					_status.page = 1;
					prevPage(_service1);
				break;	
			}			
		}
		
		private function nextPage(p:ModalWindowBasic):void
		{
			TweenLite.to(_page, .5, {x:-550, onCompleteParams:[_page], 
				onComplete:function(k:ModalWindowBasic):void{_view.removeChild(k);}});	
			_view.addChild(p); p.x = 550; TweenLite.to(p, .5, {x:0, onComplete:function():void{_page = p;}});
		}

		private function prevPage(p:ModalWindowBasic):void
		{
			TweenLite.to(_page, .5, {x:550, onCompleteParams:[_page], 
				onComplete:function(k:ModalWindowBasic):void{_view.removeChild(k);}});	
			_view.addChild(p); p.x = -550; TweenLite.to(p, .5, {x:0, onComplete:function():void{_page = p;}});
		}
		
	// added / removed from stage //	
		
		override protected function onAddedToStage(e:Event):void
		{
			_page = _service1;
			_page.x = 0;
			_status.page = 1;
			_view.addChildAt(_page, 0);
			super.onAddedToStage(e);
		}

		private function onRemovedFromStage(e:Event):void
		{
			_status.page = 1;
			_view.removeChild(_page);
		}		
		
		private function drawMask(w:uint, h:uint):void
		{
			_mask.x = 0;
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(4, 0, w-8, h-4);
			_mask.graphics.endFill();
			_view.mask = _mask;
		}		
		
	}
	
}
