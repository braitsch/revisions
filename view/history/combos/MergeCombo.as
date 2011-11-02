package view.history.combos {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Branch;
	import flash.utils.setTimeout;
	
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
			var a:Vector.<String> = new Vector.<String>();
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			for (var i:int = 0; i < b.length; i++) if (b[i] != AppModel.branch) a.push(b[i].name);
			super.options = a;
		}
		
		public function reset():void
		{
			_branch = null;
			super.heading = 'Open Merge View';
			super.setHeadingIcon(OptionsArrow, 20);
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
			AppModel.showLoader('Comparing Branches');
	// add slight delay so we have time to display the preloader //				
			setTimeout(function():void{ AppModel.dispatch(AppEvent.GET_BRANCH_HISTORY, _branch); }, 500);
		}
		
		private function hideMergePreview(e:UIEvent):void
		{
			if (_branch) dispatchEvent(new UIEvent(UIEvent.HIDE_MERGE_PREVIEW));
		}

	}
	
}
