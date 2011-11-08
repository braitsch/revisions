package view.history.combos {

	import events.AppEvent;
	import events.UIEvent;
	import model.AppModel;
	import model.proxies.AppProxies;
	import model.vo.Branch;
	import flash.utils.setTimeout;
	
	public class SyncCombo extends ComboGroup {

		private static var _branch	:Branch;

		public function SyncCombo()
		{
			super.optionIcon = BranchIcon;
			addEventListener(UIEvent.COMBO_OPTION_CLICK, openMergePreview);
			AppModel.engine.addEventListener(AppEvent.HIDE_SYNC_VIEW, resetMergeView);
		}

		public function draw():void
		{
			resetMergeView();
			var a:Vector.<String> = new Vector.<String>();
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			for (var i:int = 0; i < b.length; i++) if (b[i] != AppModel.branch) a.push(b[i].name);
			super.options = a;
		}
		
		private function resetMergeView(e:AppEvent = null):void
		{
			_branch = null;
			super.headingText = 'Sync Branches';
			super.headingIcon = OptionsArrow;			
		}		
		
		private function openMergePreview(e:UIEvent):void
		{
			if (AppModel.bookmark.branches[e.data] != _branch) setBranch(e.data as uint);
		}
		
		private function setBranch(n:uint):void
		{
			_branch = AppModel.bookmark.branches[n];
			super.headingText = 'Syncing With : '+_branch.name;
			super.headingIcon = SwitcherDelete;
			AppModel.showLoader('Comparing Branches');
	// add slight delay so we have time to display the preloader //				
			setTimeout(function():void{ AppProxies.merge.getBranchHistory(_branch); }, 500);
		}
		
	}
	
}
