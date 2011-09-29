package view.history {

	import model.AppModel;
	import model.vo.Branch;
	import view.type.ColumnHeading;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class BranchSwitcher extends Sprite {

		private static var _arrow			:Bitmap = new Bitmap(new ComboArrow());
		private static var _text		 	:ColumnHeading = new ColumnHeading();
		private static var _heading			:Sprite = new Sprite();
		private static var _mask			:Shape = new Shape();
		private static var _branches		:Sprite = new Sprite();	
		
		public static const ITEM_HEIGHT		:uint = 28;

		public function BranchSwitcher()
		{
			addHeading();
			this.visible = false;
			this.buttonMode = true;
			addEventListener(MouseEvent.ROLL_OUT, hideBranches);
		}

		public function redraw():void
		{
			drawHeading();
			drawBranches();
			this.visible = true;
		}
		
		private function drawHeading():void
		{
			_heading.graphics.clear();
			_text.text = 'On Branch "'+ AppModel.branch.name+'"';	
			_arrow.x = _text.width + 15;
			var w:uint = _heading.width + 20;
			_heading.graphics.beginFill(0x333333, .6);
			_heading.graphics.drawRect(0, 0, w, 32);
			_heading.graphics.beginFill(0x000000, 1);
			_heading.graphics.drawRect(0, 32, w, 1);
			_heading.graphics.endFill();
		}
		
		private function drawBranches():void
		{
			while(_branches.numChildren) _branches.removeChildAt(0);
			var b:Vector.<Branch> = AppModel.bookmark.branches;
			for (var i:int = 0; i < b.length; i++) {
				if (b[i] == AppModel.branch) continue;
				var k:BranchItem = new BranchItem(b[i], _heading.width);
					k.y = _branches.numChildren * (ITEM_HEIGHT + 1);
				_branches.addChild(k);	
			}
			_branches.graphics.clear();
			_branches.graphics.beginFill(0x555555);
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

		private function addHeading():void
		{
			_text.y = 12; _arrow.y = 12;
			_heading.addChild(_arrow); _heading.addChild(_text);
			_heading.addEventListener(MouseEvent.ROLL_OVER, showBranches);
			addChild(_heading);
			
			_mask.scaleY = 0;
			_branches.mask = _mask;
			_branches.y = _mask.y = 33;
			addChild(_branches); addChild(_mask); 
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

import model.AppModel;
import model.vo.Branch;
import view.history.BranchSwitcher;
import view.type.TextHeading;
import flash.display.Sprite;
import flash.events.MouseEvent;

class BranchItem extends Sprite {

	private var _branch		:Branch;
	private var _text		:TextHeading;

	public function BranchItem(b:Branch, w:uint)
	{
		_branch	= b;
		graphics.beginFill(0xCCCCCC);
		graphics.drawRect(0, 0, w, BranchSwitcher.ITEM_HEIGHT);
		graphics.endFill();
		_text = new TextHeading(_branch.name);
		_text.y = 6;
		_text.color = 0x555555;
		addChild(_text);
		addEventListener(MouseEvent.CLICK, onMouseClick);
	}

	private function onMouseClick(e:MouseEvent):void
	{
		if (AppModel.branch.isModified){
			AppModel.alert('Please save your changes before moving to a new branch.');					
		}	else{
			AppModel.proxies.editor.changeBranch(_branch);
		}
	}

}
