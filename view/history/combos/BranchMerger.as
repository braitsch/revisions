package view.history.combos {

	import events.AppEvent;
	import model.AppModel;
	import events.UIEvent;
	
	public class BranchMerger extends ComboGroup {

		public function BranchMerger()
		{
			super(OptionsArrow, BranchIcon, 20, false);
			addEventListener(UIEvent.COMBO_OPTION_CLICK, onOptionClick);
			addEventListener(UIEvent.COMBO_HEADING_CLICK, onHeadingClick);			
		}

		public function draw():void
		{
			super.heading = 'Open Merge View';
			super.options = new Vector.<String>();
		}
		
		private function onHeadingClick(e:UIEvent):void
		{
			dispatchEvent(new UIEvent(UIEvent.SHOW_MERGE_PREVIEW));
			AppModel.dispatch(AppEvent.GET_BRANCH_HISTORY, AppModel.bookmark.branches[1]);
		}

		private function onOptionClick(e:UIEvent):void
		{
			
		}
		
	}
	
}
