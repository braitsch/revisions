package view.history {

	import model.vo.Commit;
	import flash.display.Sprite;

	public class HistorySnapshot extends Sprite {
		

		public function HistorySnapshot(o:Vector.<Commit>, n:Vector.<Commit> = null)
		{
			if (n) attach(n, false); attach(o, true);
		}
		
		private function attach(v:Vector.<Commit>, shared:Boolean):void
		{
			for (var i:int = 0; i < v.length; i++) {
				var k:HistoryItemSaved = new HistoryItemSaved(shared ? new DkGreyPattern() : new HistoryItemBkgd());
					k.commit = v[i];
					k.y = HistoryList.ITEM_SPACING * numChildren;
					k.mouseEnabled = k.mouseChildren = false;
				addChild(k);
			}			
		}
		
		override public function set width(n:Number):void
		{
			for (var i:int = 0; i < numChildren; i++) HistoryItem(getChildAt(i)).setWidth(n);
		}
		
	}
	
}
