package view.history {

	import model.vo.Branch;
	import flash.display.Sprite;

	public class HistorySnapshot extends Sprite {
		

		public function HistorySnapshot(b:Branch)
		{
			var n:uint = b.history.length > 25 ? 25 : b.history.length; 
			for (var i:int = 0; i < n; i++) {
				var k:HistoryItemSaved = new HistoryItemSaved();
					k.commit = b.history[i];
					k.y = HistoryList.ITEM_SPACING * i;
					k.mouseEnabled = k.mouseChildren = false;
				addChild(k);
			}
		}
		
		override public function set width(n:Number):void
		{
			for (var i:int = 0; i < numChildren; i++) {
				HistoryItem(getChildAt(i)).setWidth(n);
			}
		}
		
	}
	
}
