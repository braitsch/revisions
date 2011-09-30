package view.history.merger {

	import flash.display.Sprite;

	public class BranchMerger extends Sprite {

		private static var _heading			:MergerHeading = new MergerHeading();

		public function BranchMerger()
		{
			this.visible = false;
			addChild(_heading);
		}

		public function draw():void
		{
			this.visible = true;
		}
		
	}
	
}
