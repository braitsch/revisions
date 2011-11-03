package view.windows.modals.local {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Branch;
	import model.vo.Commit;
	import view.type.TextHeading;
	import view.ui.ModalCheckbox;
	import view.windows.modals.system.Alert;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class MergeLocal extends Alert {

		private static var _view			:MergeLocalMC = new MergeLocalMC();
		private static var _heading			:TextHeading = new TextHeading();
		private static var _check			:ModalCheckbox = new ModalCheckbox(false);
		private static var _iconA			:Bitmap;	
		private static var _iconB			:Bitmap;	
		private static var _branchA			:Branch;
		private static var _branchB			:Branch;
	//	private static var _windowX			:uint;
	//	private static var _windowY			:uint;
		private static var _branchesInSync	:Boolean;

		public function MergeLocal(a:Branch, b:Branch, au:uint, bu:uint, ac:Commit, bc:Commit)
		{
			addChild(_view);
			super.drawBackground(550, 350);
			super.title = 'Sync Branches';
			addOkButton();
			addNoButton();
			addChild(_heading);
			_branchA = a; _branchB = b; 
			_branchesInSync = au == bu;
			drawBranches(au, bu, ac, bc); addIcons(); addCheckBox(); setHeading();
		//	addEventListener(MouseEvent.MOUSE_DOWN, onMouseDrag);
		}

		private function drawBranches(au:uint, bu:uint, ac:Commit, bc:Commit):void
		{
			_view.branchA.name_txt.text = _branchA.name;
			_view.branchA.time_txt.text = 'Last Saved : '+ac.date;
			_view.branchB.name_txt.text = _branchB.name;
			_view.branchB.time_txt.text = 'Last Saved : '+bc.date;
			_view.branchA.syncCount.num.text = au;
			_view.branchB.syncCount.num.text = bu;
			_view.branchB.syncCount.visible = au != 0;
			_view.branchA.syncCount.visible = bu != 0;
			_view.branchA.name_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.branchA.time_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.branchB.name_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.branchB.time_txt.autoSize = TextFieldAutoSize.CENTER;
		}
		
		private function setHeading():void
		{
			if (_branchesInSync){
				_heading.text = 'It appears that both of these branches are already in sync.';
			}	else {
				_heading.text = 'Would you like to sync these two branches together?';
			}			
			super.noButton.visible = _check.visible = _branchesInSync == false;
		}		
		
		private function addIcons():void
		{
			if (_iconA) _view.branchA.removeChild(_iconA);
			if (_iconB) _view.branchB.removeChild(_iconB);
			_iconA = new Bitmap(AppModel.bookmark.icon128);
			_iconB = new Bitmap(AppModel.bookmark.icon128);
			_iconA.scaleX = _iconA.scaleY = _iconB.scaleX = _iconB.scaleY = .75;
			_iconA.x = _iconB.x = 70 - _iconA.width / 2;
			_iconA.y = _iconB.y = 90 - _iconA.height / 2;
			_iconA.smoothing = _iconB.smoothing = true;
			_view.branchA.addChildAt(_iconA, 1);
			_view.branchB.addChildAt(_iconB, 1);
			_view.branchA.syncCount.x = _iconA.x + _iconA.width - 5;
			_view.branchA.syncCount.y = _iconA.y + _iconA.height - 10;
			_view.branchB.syncCount.x = _iconB.x + _iconB.width - 5;
			_view.branchB.syncCount.y = _iconB.y + _iconB.height - 10;		
		}
		
		private function addCheckBox():void
		{
			_check.y = 310; 
			_check.label = 'Delete branch '+_branchB.name+' after merging';
			addChild(_check);
		}
		
		override protected function onOkButton(e:Event):void
		{
			if (_branchesInSync){
				closeWindow(e);
			}	else{
				trace("MergeLocal.onOkButton(e)", _branchA.name, _branchB.name);
			}
		}		

		override protected function onNoButton(e:UIEvent):void
		{
			closeWindow(e);
		}
		
		override protected function onCloseClick(e:MouseEvent):void 
		{
			closeWindow(e);
		}
		
		private function closeWindow(e:Event):void
		{
			super.onOkButton(e);
			AppModel.dispatch(AppEvent.HIDE_MERGE_VIEW);						
		}
		
	// window dragging //	
		
//		private function onMouseDrag(e:MouseEvent):void
//		{
//			_windowX = uint(stage.stageWidth / 2 - this.width / 2);
//			_windowY = uint((stage.stageHeight - 50) / 2 - this.height / 2 + 50);
//			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//		}
//
//		private function onMouseMove(e:MouseEvent):void
//		{
//			TweenLite.to(this, .3, {x:e.stageX - this.width / 2, y:e.stageY - this.height / 2});
//		}
//
//		private function onMouseUp(e:MouseEvent):void
//		{
//			TweenLite.to(this, .5, {x:_windowX, y:_windowY});
//			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
//		}

	}
	
}
