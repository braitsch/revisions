package view.ui {

	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextFormat;

	public class Tooltip extends Sprite {

		private static var _bold		:Font = new HelveticaBold() as Font;
		private static var _labelFormat	:TextFormat = new TextFormat();
						   _labelFormat.color = 0x666666;
						   _labelFormat.letterSpacing = .7;
						   _labelFormat.size = 10;
						   _labelFormat.bold = _bold.fontName;	
	//	private static var _glowBox		:GlowFilter = new GlowFilter(0x000000, .2, 5, 5, 3, 3);
		private static var _dropBox		:DropShadowFilter = new DropShadowFilter(3, 90, 0, .5);
		private static var _glowLabel	:GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 3, 3);		
		
		private var _view				:TooltipMC = new TooltipMC();
	
		public function Tooltip(label:String)
		{
			addChild(_view);
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
			_view.label_txt.autoSize = 'center';
			_view.label_txt.defaultTextFormat = _labelFormat;
			_view.label_txt.y = -16;
			_view.label_txt.text = label;
			_view.label_txt.filters = [_glowLabel];
			var w:uint = _view.label_txt.width + 10;
			_view.graphics.beginFill(0xE6E6E6);
		//	_view.graphics.beginBitmapFill(new LtGreyPattern());
			_view.graphics.drawRoundRect(-w/2, -20, w, 20, 3);
			_view.graphics.drawTriangles(Vector.<Number>([-7,0, 7,0, 0,6]));
			_view.graphics.endFill();
			_view.filters = [_dropBox];
		}
		
	}
	
}
