package view.windows.upload {

	import com.greensock.TweenLite;
	import events.UIEvent;
	import flash.display.Shape;
	import flash.events.Event;
	import view.windows.base.ParentWindow;
	import view.windows.base.ChildWindow;
	
	public class UploadWizard extends ParentWindow {

		private static var _mask			:Shape = new Shape();
		private static var _page			:ChildWindow;
		private static var _status			:StatusBadge = new StatusBadge();
		private static var _view			:UploadWizardMC = new UploadWizardMC();
		private static var _tweening		:Boolean = false;
		
	// sub-pages //	
		private static var _pickService		:PickService = new PickService();
		private static var _pickAccount		:PickAccount = new PickAccount();
		private static var _nameRmtRepo		:NameRmtRepo = new NameRmtRepo();
		private static var _confirmDetails	:ConfirmDetails = new ConfirmDetails();
		private static var _onBkmkAdded		:OnBkmkAdded = new OnBkmkAdded();
		private static var _addCollaborator	:AddCollaborator = new AddCollaborator();
		
		public function UploadWizard()
		{
			addChild(_view);
			addChild(_mask);
			drawMask(550, 300);
			_view.addChild(_status);
			super.addCloseButton();
			super.drawBackground(550, 300);
			addEventListener(UIEvent.WIZARD_PREV, onWizardPrev);
			addEventListener(UIEvent.WIZARD_NEXT, onWizardNext);
			addEventListener(UIEvent.ADD_COLLABORATOR, onAddCollaborator);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

	// page navigation //

		private function onWizardNext(e:UIEvent):void
		{
			if (_tweening) return;
			switch(e.target){
				case _pickService :
					_status.page = 2;
					_status.service = e.data as String;
					_pickAccount.service = e.data as String;
					nextPage(_pickAccount);
				break;
				case _pickAccount :
					_status.page = 3;
					nextPage(_nameRmtRepo);
				break;
				case _nameRmtRepo :
					_status.page = 4;
					nextPage(_confirmDetails);
				break;
				case _confirmDetails :
					_status.page = 5;
					nextPage(_onBkmkAdded);
					super.title = 'Success!';
				break;	
			}
		}
		
		private function onWizardPrev(e:UIEvent):void
		{
			if (_tweening) return;
			switch(e.target){
				case _addCollaborator :
					_status.page = 5;
					prevPage(_onBkmkAdded);
				break;
				case _confirmDetails :
					_status.page = 3;
					prevPage(_nameRmtRepo);
				break;					
				case _nameRmtRepo :
					_status.page = 2;
					prevPage(_pickAccount);
				break;
				case _pickAccount :
					_status.page = 1;
					prevPage(_pickService);
				break;
			}			
		}
		
		private function onAddCollaborator(e:UIEvent):void
		{
			nextPage(_addCollaborator);
			super.title = 'Add Collaborator';			
		}			

		private function nextPage(p:ChildWindow):void
		{
			_tweening = true;
			TweenLite.to(_page, .5, {x:-550, onCompleteParams:[_page], 
				onComplete:function(k:ChildWindow):void{_view.removeChild(k); _tweening = false; }});	
			_view.addChild(p); p.x = 550; TweenLite.to(p, .5, {x:0, onComplete:function():void{_page = p;}});
		}

		private function prevPage(p:ChildWindow):void
		{
			_tweening = true;
			TweenLite.to(_page, .5, {x:550, onCompleteParams:[_page], 
				onComplete:function(k:ChildWindow):void{_view.removeChild(k); _tweening = false; }});	
			_view.addChild(p); p.x = -550; TweenLite.to(p, .5, {x:0, onComplete:function():void{_page = p;}});
		}
		
	// added / removed from stage //	
		
		override protected function onAddedToStage(e:Event):void
		{
			_page = _pickService;
			_page.x = 0;
			_status.page = 1;
			_view.addChildAt(_page, 0);
			super.onAddedToStage(e);
			super.title = 'Link Online';
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
