package view.ui {

	import fl.text.TLFTextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.greensock.TweenLite;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class DrawButton extends Sprite {

		private static const	WHITE	:uint = 0xffffff;
		private static const	DK_GREY	:uint = 0x888888;
		private static const	STROKE	:uint = 0xC0C0C0;
		private static const 	GLOW	:GlowFilter = new GlowFilter(0xffffff, 1, 6, 6, 2, BitmapFilterQuality.HIGH);				
		
		private var _width		:uint;
		private var _height		:uint;
		private var _over		:Shape = new Shape();
		private var _bkgd		:Shape = new Shape();
		private var _mtrx		:Matrix = new Matrix();
		private var _label		:TLFTextField;
		private var _format		:TextFormat = new TextFormat();

		public function DrawButton(w:uint, h:uint, s:String, n:uint = 14)
		{
			setup(w, h, n);
			drawBkgd();
			drawOver();
			drawStroke();
			addLabel(s);
			addEventListeners();
		}
		
		public function addIcon(b:BitmapData):void
		{
			var bmp:Bitmap = new Bitmap(b);
				bmp.x = 7;
				bmp.y = _height / 2 - bmp.height/2;
				bmp.filters = [GLOW];
			addChild(bmp);
		}
		
		public function set label(s:String):void
		{
			_label.text = s;
			_label.x = _width / 2 - _label.width / 2;
			_label.y = _height / 2 - _label.height / 2 + 1;
		}

		private function setup(w:uint, h:uint, n:uint):void
		{
			_width = w;
			_height = h;
			_format.size = n;	
			buttonMode = true;
			this.filters = [GLOW];
			_mtrx.createGradientBox(w, h, Math.PI / 2);
		}

		private function addEventListeners():void
		{
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}

		private function drawBkgd():void
		{
			_bkgd.graphics.beginGradientFill(GradientType.LINEAR, [WHITE, DK_GREY], [.3, .3], [80, 255], _mtrx);
			_bkgd.graphics.drawRect(0, 0, _width, _height);
			_bkgd.graphics.endFill();
			addChild(_bkgd);
		}

		private function drawOver():void
		{
			_over.graphics.beginGradientFill(GradientType.LINEAR, [DK_GREY, WHITE], [.3, .3], [0, 170], _mtrx);
			_over.graphics.drawRect(0, 0, _width, _height);
			_over.graphics.endFill();
			_over.alpha = 0;
			addChild(_over);
		}

		private function drawStroke():void
		{
			graphics.lineStyle(1, STROKE, 1, true, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();				
		}		
		
		private function addLabel(s:String):void
		{
			var bl:ButtonLabel = new ButtonLabel();
			_label = bl.label;
			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.mouseChildren = _label.mouseEnabled = false;
			_label.setTextFormat(_format);
			_label.filters = [GLOW];
			addChild(_label);
			this.label = s;
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:1});
			TweenLite.to(_bkgd, .3, {alpha:0});
		}	
			
		private function onRollOut(e:MouseEvent):void
		{
			TweenLite.to(_over, .3, {alpha:0});
			TweenLite.to(_bkgd, .3, {alpha:1});
		}
		
	}
	
}
