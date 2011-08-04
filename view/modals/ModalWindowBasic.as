package view.modals {

	import events.UIEvent;
	import fl.text.TLFTextField;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ModalWindowBasic extends Sprite {

		public var locked			:Boolean;
		protected var inputs		:Vector.<TLFTextField>;
		private static var _file	:File = File.desktopDirectory;
	
	// override this in any windows that should listen for the enter key //	
		public function onEnterKey():void { }
		
		protected function drawBackground(w:uint, h:uint):void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			graphics.beginBitmapFill(new LtGreyPattern());
			graphics.drawRect(4, 4, w-8, h-8);
			graphics.endFill();
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
		
		protected function addInputs(v:Vector.<TLFTextField>):void
		{
			inputs = v;
			for (var i:int=0; i < v.length; i++) v[i].tabIndex = i;
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
