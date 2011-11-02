package view.history.combos {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Branch;
	
	public class MergeCombo extends ComboGroup {

		private static var _branch	:Branch;

		public function MergeCombo()
		{
			super(BranchIcon, 20, false);
			addEventListener(UIEvent.COMBO_OPTION_CLICK, openMergePreview);
			addEventListener(UIEvent.COMBO_HEADING_CLICK, hideMergePreview);
		}

		public function draw():void
		{
			reset();
			var a:Vector.<String> = new Vector.<String>();
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			for (var i:int = 0; i < b.length; i++) if (b[i] != AppModel.branch) a.push(b[i].name);
			super.options = a;
		}
		
		private function openMergePreview(e:UIEvent):void
		{
			if (AppModel.bookmark.branches[e.data] != _branch) setBranch(e.data as uint);
		}
		
		private function setBranch(n:uint):void
		{
			_branch = AppModel.bookmark.branches[n];
			super.heading = 'Merging With : '+_branch.name;
			super.setHeadingIcon(SwitcherDelete, 20);
			dispatchEvent(new UIEvent(UIEvent.SHOW_MERGE_PREVIEW));
			AppModel.dispatch(AppEvent.GET_BRANCH_HISTORY, _branch);
		}
		
		private function reset():void
		{
			_branch = null;
			super.heading = 'Open Merge View';
			super.setHeadingIcon(OptionsArrow, 20);
		}
		
		private function hideMergePreview(e:UIEvent):void
		{
			if (_branch) {
				reset(); dispatchEvent(new UIEvent(UIEvent.HIDE_MERGE_PREVIEW));	
			}
		}

	}
	
}
