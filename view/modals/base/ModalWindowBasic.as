package view.modals.base {

	import events.UIEvent;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextFieldAutoSize;

	public class ModalWindowBasic extends Sprite {

		private static var _file	:File = File.desktopDirectory;

		public function ModalWindowBasic()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onAddedToStage(e:Event):void 
		{ 
			stage.focus = this;
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}	
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 13 && stage.focus == this) dispatchEvent(new UIEvent(UIEvent.ENTER_KEY));
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
		
		protected function set defaultButton(b:Sprite):void
		{
			b['over'].alpha = 1;
			b.buttonMode = true;
			b.mouseChildren = false;
			b.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ dispatchEvent(new UIEvent(UIEvent.ENTER_KEY)); } );
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
