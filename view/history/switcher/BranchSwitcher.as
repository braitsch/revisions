package view.history.switcher {

	import model.AppModel;
	import model.vo.Branch;
	import com.firestarter.ScaleObject;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class BranchSwitcher extends Sprite {

		private static var _heading			:SwitcherHeading = new SwitcherHeading();
		private static var _dsPlate			:ScaleObject = new ScaleObject(new DropShadowPlate(), new Rectangle(19, 7, 200, 106));
		private static var _mask			:Shape = new Shape();
		private static var _branches		:Sprite = new Sprite();
		private static var _width			:uint;

		public function BranchSwitcher()
		{
			addChildren();
			this.visible = false;
			this.addEventListener(MouseEvent.ROLL_OUT, hideBranches);
			_heading.addEventListener(MouseEvent.ROLL_OVER, showBranches);
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		public function draw():void
		{
			_heading.setText();
			this.visible = true;
			while(_branches.numChildren) _branches.removeChildAt(0);
			_width = _heading.width;
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			for (var i:int = 0; i < b.length; i++) {
				if (b[i] == AppModel.branch) continue;
				var k:SwitcherOption = new SwitcherOption(b[i]);
					k.y = _branches.numChildren * (SwitcherItem.ITEM_HEIGHT + 2);
				if (k.width > _width) _width = k.width;
				_branches.addChild(k);
			}
			_width += 35; // padding //
			_heading.draw(_width);
			if (_branches.numChildren == 0){
				allowAlert(true);
				this.buttonMode = false;
			}	else{
				allowAlert(false);
				this.buttonMode = true;
				for (i = 0; i < _branches.numChildren; i++) SwitcherItem(_branches.getChildAt(i)).draw(_width - 1);
				drawBranchesBkgd();			
			}
		}
		
	// temporary //	
		private function allowAlert(b:Boolean):void
		{
			if (b){
				addEventListener(MouseEvent.CLICK, onClick);
			}	else{
				removeEventListener(MouseEvent.CLICK, onClick);
			}
		}

		private function onClick(e:MouseEvent):void
		{
			AppModel.alert('Select a saved version of this bookmark to create a new branch.');
		}
		
		private function drawBranchesBkgd():void
		{
			_dsPlate.x = -9;
			_dsPlate.width = _branches.width + 18;
			_dsPlate.height = _branches.height + 9;
			_branches.addChildAt(_dsPlate, 0);
			drawMask();			
		}
		
		private function drawMask():void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff0000, .2);
			_mask.graphics.drawRect(-10, 0, _branches.width, _branches.height);
			_mask.graphics.endFill();
		}

		private function addChildren():void
		{
			_mask.scaleY = 0;
			_branches.mask = _mask;
			_branches.y = _mask.y = 33;
			addChild(_heading);
			addChild(_branches); 
			addChild(_mask); 
		}
		
		private function showBranches(e:MouseEvent):void
		{
			TweenLite.to(_mask, .3, {scaleY:1});
		}
		
		private function hideBranches(e:MouseEvent):void
		{
			TweenLite.to(_mask, .3, {scaleY:0});
		}		
		
	}
	
}