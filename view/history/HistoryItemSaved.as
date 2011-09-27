package view.history {

	import model.vo.Commit;
	import view.Box;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class HistoryItemSaved extends Sprite {

		private var _bkgd			:Box;
		private var _strk			:Box;
		private var _text			:TextDoubleMC = new TextDoubleMC();
		private var _commit			:Commit;

		public function HistoryItemSaved(c:Commit)
		{
			_commit = c;
			drawShapes();
			addTextDetails();
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, onItemSelection);
		}
		
		private function addTextDetails():void
		{
			_text.x = 50; _text.y = 8;
			_text.line1.text = _commit.note;
			_text.line2.text = _commit.date;
			_text.line1.mouseEnabled = _text.line1.mouseChildren = false; 
			_text.line2.mouseEnabled = _text.line2.mouseChildren = false; 
			addChild(_text);
		}
		
		private function drawShapes():void
		{
			_bkgd = new Box(500, 40, Box.GRADIENT);
			_bkgd.scalable = true;
			_bkgd.scaleOffset = 210;
			_strk = new Box(500, 40, Box.STROKE);
			_strk.scalable = true;
			_strk.scaleOffset = 210;
			addChild(_bkgd); addChild(_strk);
		}
		
		private function onItemSelection(e:MouseEvent):void
		{
			trace("HistoryItemSaved.onItemSelection(e)", _commit);
		}

	}
	
}
