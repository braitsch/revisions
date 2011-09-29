package view.history.switcher {

	import model.AppModel;
	import model.vo.Branch;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	public class BranchSwitcher extends Sprite {

		private static var _manage			:SwitcherManage = new SwitcherManage();
		private static var _heading			:SwitcherHeading = new SwitcherHeading();
		private static var _mask			:Shape = new Shape();
		private static var _branches		:Sprite = new Sprite();	
		private static var _dkGlow			:GlowFilter = new GlowFilter(0x000000, .3, 4, 4, 3, 3);				

		public function BranchSwitcher()
		{
			addChildren();
			this.visible = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.ROLL_OUT, hideBranches);
			_heading.addEventListener(MouseEvent.ROLL_OVER, showBranches);
		}

		public function redraw():void
		{
			_heading.draw();
			drawBranches();
			this.visible = true;
		}
		
		private function drawBranches():void
		{
			while(_branches.numChildren) _branches.removeChildAt(0);
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			var w:uint = _manage.width > _heading.width ? _manage.width : _heading.width;
			for (var i:int = 0; i < b.length; i++) {
				if (b[i] == AppModel.branch) continue;
				var k:SwitcherOption = new SwitcherOption(b[i]);
					k.y = _branches.numChildren * (SwitcherItem.ITEM_HEIGHT + 2);
				if (k.width > w) w = k.width + 20;
				_branches.addChild(k);
			}
			_manage.y = _branches.numChildren * (SwitcherItem.ITEM_HEIGHT + 2);
			_branches.addChild(_manage);
			for (i = 0; i < _branches.numChildren; i++) SwitcherItem(_branches.getChildAt(i)).draw(w);
			drawBranchesBkgd();
		}
		
		private function drawBranchesBkgd():void
		{
			_branches.graphics.clear();
			_branches.graphics.beginFill(0xFFFFFF);
			_branches.graphics.drawRect(0, 0, _branches.width, _branches.height);
			_branches.graphics.endFill();
			drawMask();			
		}
		
		private function drawMask():void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff0000, .2);
			_mask.graphics.drawRect(0, 0, _branches.width, _branches.height);
			_mask.graphics.endFill();
		}

		private function addChildren():void
		{
			_mask.scaleY = 0;
			_branches.mask = _mask;
			_branches.y = _mask.y = 33;
			_branches.filters = [_dkGlow];
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