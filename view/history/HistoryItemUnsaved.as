package view.history {

	import events.UIEvent;
	import model.AppModel;
	import model.vo.Commit;
	import view.btns.ButtonIcon;
	import view.graphics.Box;
	import view.graphics.SolidBox;
	import view.windows.modals.system.Confirm;
	import flash.events.MouseEvent;

	public class HistoryItemUnsaved extends HistoryItem {

		private var _bkgd			:SolidBox = new SolidBox(Box.WHITE, true);
		private var _kill			:ButtonIcon = new ButtonIcon(new TrashUnsaved());

		public function HistoryItemUnsaved()
		{
			addChild(_bkgd);
			setTrashIcon();
			super.attachAvatar('');
			super.setText('Working Version - Unsaved', 'Right Now');
			addEventListener(MouseEvent.CLICK, onSaveSelection);
		}
		
		private function setTrashIcon():void
		{
			_kill.y = 21;
			_kill.tint = 0x999999;
			_kill.addEventListener(MouseEvent.ROLL_OUT, onKillRollOut);
			_kill.addEventListener(MouseEvent.ROLL_OVER, onKillRollOver);			
			addChild(_kill);
		}

		override public function setWidth(w:uint):void
		{
			_kill.x = w - 38;
			_bkgd.draw(w, 41);
			super.setWidth(w);
		}		

		private function onSaveSelection(e:MouseEvent):void
		{
			if (e.target is TrashUnsaved){
				showPrompt();
			}	else{
				dispatchEvent(new UIEvent(UIEvent.COMMIT));
			}			
		}
		
		private function showPrompt():void 
		{
			var c:Commit = AppModel.branch.lastCommit;
			var m:String = 'Are you sure you want to toss your unsaved changes?\nThis will revert your files(s) back to how they looked ';
				m+= 'the last time you saved them inside Revisions.\n';
				m+= '['+c.note+' :: '+c.date+']';
			var k:Confirm = new Confirm(m);
				k.addEventListener(UIEvent.CONFIRM, onConfirm);
			AppModel.alert(k);	
		}

		private function onConfirm(e:UIEvent):void
		{
			if (e.data == true) AppModel.proxies.editor.trashUnsaved();
		}
		
		private function onKillRollOver(e:MouseEvent):void
		{
			_kill.tint = 0xEDC950;	
		}

		private function onKillRollOut(e:MouseEvent):void
		{
			_kill.tint = 0x999999;	
		}		
		
	}
	
}
