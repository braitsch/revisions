package view.modals.base {

	import events.UIEvent;
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.GlowFilter;
	import flash.text.TextFieldAutoSize;

	public class ModalWindowBasic extends Sprite {

		public var locked			:Boolean;
		private var _bkgd			:Shape = new Shape();
		private static var _file	:File = File.desktopDirectory;
		private static var _glow	:GlowFilter = new GlowFilter(0x000000, .5, 20, 20, 2, 2);

		public function ModalWindowBasic()
		{
			addChild(_bkgd);
			_bkgd.filters = [_glow];
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

	// override this in any windows that should listen for the enter key //	
		public function onEnterKey():void { }

		protected function onAddedToStage(e:Event):void 
		{ 
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}	
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 13) onEnterKey();
		}		

		protected function setTitle(view:*, s:String):void
		{
			view.pageBadge.label_txt.text = s;
		}
		
		protected function setHeading(view:*, s:String):void
		{
			view.heading.label_txt.autoSize = TextFieldAutoSize.LEFT;
			view.heading.label_txt.htmlText = s;
		}
		
		protected function drawBackground(w:uint, h:uint):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginFill(0xFFFFFF);
			_bkgd.graphics.drawRect(0, 0, w, h);
			_bkgd.graphics.endFill();
			_bkgd.graphics.beginBitmapFill(new LtGreyPattern());
			_bkgd.graphics.drawRect(4, 4, w-8, h-8);
			_bkgd.graphics.endFill();
		}

		protected function set defaultButton(b:Sprite):void
		{
			b['over'].alpha = 1;
			b.buttonMode = true;
			b.mouseChildren = false;
		}
		
		protected function addButtons(a:Array):void
		{
			for (var i:int=0; i < a.length; i++) {
				a[i]['over'].alpha = 0;
				a[i].mouseChildren = false;
				enableButton(a[i], true);
			}
		}
		
		protected function enableButton(b:Sprite, on:Boolean):void
		{
			if (on){
				b.alpha = 1;
				b.buttonMode = true;
				b.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				b.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			}	else{
				b.alpha = .5;
				b.buttonMode = false;
				b.removeEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				b.removeEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);				
			}
		}
		
		protected function browseForFile($msg:String):void
		{
			_file.browseForOpen($msg);	
			_file.addEventListener(Event.SELECT, onSelect);			
		}

		protected function browseForDirectory($msg:String):void 
		{
			_file.browseForDirectory($msg);	
			_file.addEventListener(Event.SELECT, onSelect);			
		}

		protected function onSelect(e:Event):void 
		{
			dispatchEvent(new UIEvent(UIEvent.FILE_BROWSER_SELECTION, e.target as File));
		}
		
		protected function onButtonRollOut(e:MouseEvent):void {TweenLite.to(e.target.over, .3, {alpha:0});}
		protected function onButtonRollOver(e:MouseEvent):void {TweenLite.to(e.target.over, .5, {alpha:1});}

	}
	
}
