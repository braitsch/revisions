package view.windows.modals.merge {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Branch;
	import model.vo.Commit;
	import view.type.TextHeading;
	import view.ui.ModalCheckbox;
	import view.windows.modals.system.Alert;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;

	public class SyncPreview extends Alert {

		private static var _view			:SyncLocalMC = new SyncLocalMC();
		private static var _heading			:TextHeading = new TextHeading();
		private static var _check			:ModalCheckbox = new ModalCheckbox(false);
		private static var _iconA			:Bitmap;	
		private static var _iconB			:Bitmap;	
		private static var _branchA			:Branch;
		private static var _branchB			:Branch;
	//	private static var _windowX			:uint;
	//	private static var _windowY			:uint;
		private static var _branchesInSync	:Boolean;

		public function SyncPreview(a:Branch, b:Branch, au:uint, bu:uint, ac:Commit, bc:Commit)
		{
			_branchA = a; _branchB = b; 
			_branchesInSync = au == 0 && bu == 0;
			_view.textMeasure.autoSize = TextFieldAutoSize.LEFT;
			super.title = 'Sync Branches';
			super.drawBackground(getWindowWidth(a, b), 360);
			addOkButton(); addNoButton();
			addChild(_view); addChild(_heading);
			drawBranches(au, bu, ac, bc); addIcons(); addCheckBox(); setHeading();
		//	addEventListener(MouseEvent.MOUSE_DOWN, onMouseDrag);
		}
		
		private function getWindowWidth(a:Branch, b:Branch):uint
		{
			var w:uint = 0; var n:uint = 0; 
			var m:uint = 240;
			_view.textMeasure.visible = false;
			_view.textMeasure.text = a.name;
				w = _view.textMeasure.width;
			if (w - m > n) n = w - m;
			_view.textMeasure.text = b.name;
				w = _view.textMeasure.width;
		// cut max width to 130 to ensure branch name fits in checkbox //
			if (_branchesInSync == false) m = 130;
			if (w - m > n) n = w - m;
				w = 580 + n;
			_view.branchB.x = w - 240; 
			_view.syncIcon.x = w / 2;
			_view.syncIcon.graphics.clear();
			_view.syncIcon.graphics.beginFill(0x000000, .1);
			_view.syncIcon.graphics.drawRect(-(w/2 - 240), -40, (w/2 - 240)*2, 80);
			_view.syncIcon.graphics.endFill();
			return w;	
		}

		private function drawBranches(au:uint, bu:uint, ac:Commit, bc:Commit):void
		{
			_view.branchA.name_txt.text = _branchA.name;
			_view.branchA.time_txt.text = 'Last Saved : '+ac.date;
			_view.branchB.name_txt.text = _branchB.name;
			_view.branchB.time_txt.text = 'Last Saved : '+bc.date;
			_view.branchA.syncCount.num.text = au;
			_view.branchB.syncCount.num.text = bu;
			_view.branchA.syncCount.visible = au != 0;
			_view.branchB.syncCount.visible = bu != 0;
			_view.branchA.name_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.branchA.time_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.branchB.name_txt.autoSize = TextFieldAutoSize.CENTER;
			_view.branchB.time_txt.autoSize = TextFieldAutoSize.CENTER;
		}
		
		private function setHeading():void
		{
			if (_branchesInSync == false){
				_heading.text = 'Would you like to sync these two branches together?';
			}	else {
				_heading.text = 'It appears that both of these branches are already in sync.';
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
			_check.y = 320; 
			_check.label = 'Delete branch '+_branchB.name+' after syncing';	
			addChild(_check);
		}
		
		
		override protected function onOkButton(e:Event):void
		{
			if (_branchesInSync){
				closeWindow(e);
			}	else{
				AppProxies.merge.syncLocalBranches(_branchB);
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
			AppModel.dispatch(AppEvent.HIDE_SYNC_VIEW);
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
