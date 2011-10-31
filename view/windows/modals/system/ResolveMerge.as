package view.windows.modals.system {

	import model.AppModel;
	import view.type.TextHeading;
	import view.ui.ModalCheckbox;
	import flash.events.MouseEvent;

	public class ResolveMerge extends Alert {
		
		private static var _heading		:TextHeading = new TextHeading();
		private static var _ask			:ModalCheckbox = new ModalCheckbox(true);
		private static var _mine		:ModalCheckbox = new ModalCheckbox(false);
		private static var _recent		:ModalCheckbox = new ModalCheckbox(false);
		private static var _commitA		:ResolveCommit = new ResolveCommit();
		private static var _commitB		:ResolveCommit = new ResolveCommit();
		private static var _options		:Vector.<ModalCheckbox> = new <ModalCheckbox>[_ask, _mine, _recent];

		public function ResolveMerge()
		{
			super.drawBackground(600, 400);
			super.title = 'Resolve Merge';
			setHeading();
			addOkButton();
			addNoButton();
			addCommits();
			addCheckboxes();
		}
		
		public function set commits(a:Array):void
		{
			var cA:Array = a[0].split('-#-');
			var cB:Array = a[1].split('-#-');
			_commitA.attachAvatar(cA[2]);
			_commitB.attachAvatar(cB[2]);
			_commitA.setText(cA[0], cA[1]);
			_commitB.setText(cB[0], cB[1]);
			_commitA.selected = true;
			_commitB.selected = false;
			_commitA.heading = 'Your latest version, created by '+cA[3];
			_commitB.heading = 'Their latest version, created by '+cB[3];
			_commitA.selected = cA[4] > cB[4];
			_commitB.selected = cA[4] < cB[4];
			trace("ResolveMerge.commits(a) a="+cA[4], 'b='+cB[4]);
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
				AppModel.proxies.editor.mergeOurs();
			}	else if (e.currentTarget == _commitB){
				AppModel.proxies.editor.mergeTheirs();
			}
		}
		
		private function setHeading():void
		{
			var m:String = 'Hmm... I was unable to auto-merge your latest version with what\'s on the server.\n';
				m+='Please choose whose version should be the latest that everyone will sync with.';
			_heading.text = m;			
			addChild(_heading);
		}
		
		private function addCheckboxes():void
		{
			for (var i:int = 0; i < _options.length; i++) {
				_options[i].y = 320 + (20 * i);
				_options[i].addEventListener(MouseEvent.CLICK, onCheckboxSelection);
				addChild(_options[i]);
			}
			_ask.label = 'Always prompt me to choose';
			_mine.label = 'Always pick mine';
			_recent.label = 'Always pick the most recent version';
		}

		private function onCheckboxSelection(e:MouseEvent):void
		{
			for (var i:int = 0; i < _options.length; i++) {
				if (e.currentTarget != _options[i]) _options[i].selected = false;
			}
		}
		
	}
	
}







