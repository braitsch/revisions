package view.history.combos {

	import events.UIEvent;
	import model.AppModel;
	import view.windows.modals.system.Message;
	
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
			super.options = [];
		}
		
		private function onHeadingClick(e:UIEvent):void
		{
			AppModel.alert(new Message('Coming Soon.'));
		}

		private function onOptionClick(e:UIEvent):void
		{
			
		}
		
	}
	
}
