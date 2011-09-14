package view.ui {

	import system.AppSettings;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class Tooltip extends Sprite {

		private static var _timeout		:int = 500;
		private static var _bold		:Font = new HelveticaBold() as Font;
		private static var _labelFormat	:TextFormat = new TextFormat();
						   _labelFormat.color = 0x666666;
						   _labelFormat.letterSpacing = .7;
						   _labelFormat.size = 10;
						   _labelFormat.bold = _bold.fontName;	
		private static var _dropBox		:DropShadowFilter = new DropShadowFilter(3, 90, 0, .5);
		private static var _glowLabel	:GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 3, 3);
		
		private var _view				:TooltipMC = new TooltipMC();
		private var _timer				:Timer = new Timer(_timeout, 1);
		private var _button				:Sprite;
	
		public function Tooltip(label:String)
		{
			draw(label);
			_timer.addEventListener(TimerEvent.TIMER, onTimeout);
		}
		
		public function set button(s:Sprite):void
		{
			_button = s;
		}		
		
		public function show():void
		{
			if (AppSettings.getSetting(AppSettings.SHOW_TOOL_TIPS)) startTimeout();
		}
		
		public function hide():void
		{
			_timer.stop();
			if (this.stage) stage.removeChild(this);
		}
		
		private function startTimeout():void
		{
			_timer.reset();
			_timer.start();
		}	
		
		private function onTimeout(e:TimerEvent):void
		{
			var p:Point = _button.parent.localToGlobal(new Point(_button.x, _button.y));
			this.x = p.x;
			this.y = p.y - 20; 
			_button.stage.addChild(this);
		}						
		
		private function draw(s:String):void
		{
			addChild(_view);
			_view.mouseEnabled = false;
			_view.mouseChildren = false;
			_view.label_txt.autoSize = 'center';
			_view.label_txt.defaultTextFormat = _labelFormat;
			_view.label_txt.y = -16;
			_view.label_txt.text = s;
			_view.label_txt.filters = [_glowLabel];
			var w:uint = _view.label_txt.width + 10;
			_view.graphics.beginFill(0xE6E6E6);
			_view.graphics.drawRoundRect(-w/2, -20, w, 20, 3);
			_view.graphics.drawTriangles(Vector.<Number>([-7,0, 7,0, 0,6]));
			_view.graphics.endFill();
			_view.filters = [_dropBox];
		}

	}
	
}
