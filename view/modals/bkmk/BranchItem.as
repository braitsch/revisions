package view.modals.bkmk {

	import model.vo.Branch;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BranchItem extends Sprite {

		private var _branch	:Branch;
		private var _view	:BranchItemMC = new BranchItemMC();

		public function BranchItem(b:Branch)
		{
			_branch = b;
			addChild(_view);
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
			_view.label_txt.text = _branch.name;
			_view.label_txt.mouseEnabled = false;
			_view.label_txt.mouseChildren = false;
			if (_branch.name != 'master') addKillButton();
		}
		
		public function get branch():Branch { return _branch; }		
		
		public function set selected(on:Boolean):void
		{
			if (on){
				onRollOver();
				buttonMode = false;
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);				
			}	else{
				onRollOut();
				buttonMode = true;
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			}
		}
		
		private function onRollOut(e:MouseEvent = null):void
		{
			TweenLite.to(_view.over, .3, {alpha:0});
		}

		private function onRollOver(e:MouseEvent = null):void
		{
			TweenLite.to(_view.over, .3, {alpha:1});
		}
		
		private function addKillButton():void
		{
			var k:BranchItemDelete = new BranchItemDelete();
				k.x = 162; k.y = 5;
			addChild(k);
		}

	}
	
}
