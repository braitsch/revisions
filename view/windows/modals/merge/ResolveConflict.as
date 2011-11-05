package view.windows.modals.merge {

	import view.windows.modals.system.Alert;
	import flash.events.MouseEvent;

	public class ResolveConflict extends Alert {
		
		private static var _commitA		:CommitItem = new CommitItem();
		private static var _commitB		:CommitItem = new CommitItem();

		public function ResolveConflict()
		{
			super.drawBackground(600, 400);
			super.title = 'Please Choose';
			addCommits();
			addOkButton();
			addNoButton();
		}
		
		protected function setCommitObjects(a:Array, b:Array):void
		{
			_commitA.attachAvatar(a[2]);
			_commitB.attachAvatar(b[2]);
			_commitA.setText(a[0], a[1]);
			_commitB.setText(b[0], b[1]);
			_commitA.selected = a[4] > b[4];
			_commitB.selected = a[4] < b[4];
		}

		private function addCommits():void
		{
			_commitA.y = 140;
			_commitB.y = 230;
			_commitA.x = _commitB.x = 25;
			_commitA.addEventListener(MouseEvent.CLICK, onCommitClick);
			_commitB.addEventListener(MouseEvent.CLICK, onCommitClick);
			addChild(_commitA); addChild(_commitB);
		}

		private function onCommitClick(e:MouseEvent):void
		{
			if (e.currentTarget == _commitA){
				_commitA.selected = true;
				_commitB.selected = false;
			}	else if (e.currentTarget == _commitB){
				_commitB.selected = true;
				_commitA.selected = false;
			}
		}
		
		protected function get commitA():CommitItem { return _commitA; }
		protected function get commitB():CommitItem { return _commitB; }		
		
	}
	
}

