package view.windows.modals.merge {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AppModel;
	import view.type.TextHeading;
	import view.windows.modals.system.Alert;

	public class ResolveConflict extends Alert {
		
		private static var _heading		:TextHeading = new TextHeading();
		private static var _commitA		:CommitItem = new CommitItem();
		private static var _commitB		:CommitItem = new CommitItem();
		private static var _mergeMode	:String;

		public function ResolveConflict()
		{
			super.drawBackground(600, 400);
			super.title = 'Please Choose';
			setHeading();
			addOkButton();
			addNoButton();
			addCommits();
		}
		
		public function set mode(s:String):void
		{
			_mergeMode = s;
		}
		
		public function set commits(a:Array):void
		{
			var cA:Array = a[0].split('-#-');
			var cB:Array = a[1].split('-#-');
			_commitA.attachAvatar(cA[2]);
			_commitB.attachAvatar(cB[2]);
			_commitA.setText(cA[0], cA[1]);
			_commitB.setText(cB[0], cB[1]);
			_commitA.heading = 'Your latest version, authored by '+cA[3];
			_commitB.heading = 'Their latest version, authored by '+cB[3];
			_commitA.selected = cA[4] > cB[4];
			_commitB.selected = cA[4] < cB[4];
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
		
		private function setHeading():void
		{
			var m:String = 'Hmm... I was unable to auto-merge your latest version with what\'s on the server.\n';
				m+='Please choose whose version should be the latest that everyone will sync from.';
			_heading.text = m;			
			addChild(_heading);
		}
		
		override protected function onOkButton(e:Event):void
		{
			super.onOkButton(e);
			if (_commitA.selected){
				if (_mergeMode == 'local'){
			//		AppModel.proxies.editor.mergeLocal();
				}	else{	
					AppModel.proxies.editor.mergeOurs();
				}
			}	else if (_commitB.selected){
				AppModel.proxies.editor.mergeTheirs();
			}
		}
		
	}
	
}

