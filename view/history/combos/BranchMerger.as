package view.history.combos {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.vo.Branch;
	
	public class BranchMerger extends ComboGroup {

		public function BranchMerger()
		{
			super(BranchIcon, 20, false);
			addEventListener(UIEvent.COMBO_OPTION_CLICK, openMergePreview);
		}

		public function draw():void
		{
			this.mergeActive = false;
			var a:Vector.<String> = new Vector.<String>();
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			for (var i:int = 0; i < b.length; i++) if (b[i] != AppModel.branch) a.push(b[i].name);
			super.options = a;			
		}
		
		public function reset():void
		{
			this.mergeActive = false;	
		}
		
		private function openMergePreview(e:UIEvent):void
		{
			this.mergeActive = true;
			dispatchEvent(new UIEvent(UIEvent.SHOW_MERGE_PREVIEW));
			AppModel.dispatch(AppEvent.GET_BRANCH_HISTORY, AppModel.bookmark.branches[e.data]);
		}
		
		private function set mergeActive(b:Boolean):void
		{
			if (b){
				super.heading = 'Close Merge View';
				super.setHeadingIcon(SwitcherDelete, 20);
				addEventListener(UIEvent.COMBO_HEADING_CLICK, onHeadingClick);
			}	else{
				super.heading = 'Open Merge View';
				super.setHeadingIcon(OptionsArrow, 20);
				removeEventListener(UIEvent.COMBO_HEADING_CLICK, onHeadingClick);
			}
		}
		
		private function onHeadingClick(e:UIEvent):void
		{
			this.mergeActive = false;
			dispatchEvent(new UIEvent(UIEvent.HIDE_MERGE_PREVIEW));	
		}

	}
	
}
