package view.history.combos {

	import com.firestarter.ScaleObject;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ComboGroup extends Sprite {

		private var _width				:uint;
		private var _icon				:Class;
		private var _iconX				:uint;
		private var _allowKill			:Boolean;
		private var _mask				:Shape = new Shape();
		private var _heading			:ComboHeading;
		private var _options			:Sprite = new Sprite();
		private var _dropShadow			:ScaleObject = new ScaleObject(new DropShadowPlate(), new Rectangle(19, 7, 200, 106));

		public function ComboGroup(oi:Class, ox:uint, ak:Boolean)
		{
			_heading = new ComboHeading();
			_icon = oi; _iconX = ox; _allowKill = ak;
			initialize();
		}
		
		public function set heading(s:String):void
		{
			_heading.setText(s);
			_width = _heading.width;
		}
		
		public function setHeadingIcon(hi:Class, x:uint):void
		{
			_heading.setIcon(hi, x);	
		}
		
		public function set options(v:Vector.<String>):void
		{
			while(_options.numChildren) _options.removeChildAt(0);
			for (var i:int = 0; i < v.length; i++) {
				var k:ComboItem = new ComboItem(v[i], _icon, _iconX, _allowKill);
					k.y = _options.numChildren * (ComboItem.ITEM_HEIGHT + 2);
				if (k.width > _width) _width = k.width;
				_options.addChild(k);
			}
			_width += 35; // padding //
			_heading.draw(_width);
			if (_options.numChildren == 0){
				this.buttonMode = false;
			}	else{
				this.buttonMode = true;
				for (i = 0; i < _options.numChildren; i++) ComboItem(_options.getChildAt(i)).draw(_width - 1);
				drawBkgdAndMask();			
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}		
		
		private function drawBkgdAndMask():void
		{
			_dropShadow.x = -9;
			_dropShadow.width = _options.width + 18;
			_dropShadow.height = _options.height + 9;
			_options.addChildAt(_dropShadow, 0);
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff0000, .2);
			_mask.graphics.drawRect(-10, 0, _options.width, _options.height);
			_mask.graphics.endFill();
		}
		
		private function initialize():void
		{
			_mask.scaleY = 0;
			_options.mask = _mask;
			_options.y = _mask.y = 33;
			addChild(_heading);
			addChild(_options); 
			addChild(_mask); 
			addEventListener(MouseEvent.ROLL_OUT, hideOptions);
			_heading.addEventListener(MouseEvent.ROLL_OVER, showOptions);
		}
		
		private function showOptions(e:MouseEvent):void
		{
			TweenLite.to(_mask, .3, {scaleY:1});
		}
		
		private function hideOptions(e:MouseEvent):void
		{
			TweenLite.to(_mask, .3, {scaleY:0});
		}		
		
	}
	
}