package view.windows.base {

	import events.UIEvent;
	import view.btns.FormButton;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ChildWindow extends Sprite {

		private static var _file	:File = File.desktopDirectory;
		private var _okButton		:FormButton;
		private var _noButton		:FormButton;

		public function ChildWindow()
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

		protected function addOkButton(s:String = 'OK', x:uint = 0, y:uint = 0):void
		{
			_okButton = new FormButton(s);
			_okButton.x = x || this.width - _okButton.width - 34;
			_okButton.y = y || this.height - _okButton.height - 35;
			_okButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ dispatchEvent(new UIEvent(UIEvent.ENTER_KEY)); } );
			addChild(_okButton);
		}
		
		protected function addNoButton(s:String = 'Cancel', x:uint = 0, y:uint = 0):void
		{
			_noButton = new FormButton(s);
			_noButton.x = x || this.width - (_noButton.width * 2) - 44;
			_noButton.y = y || this.height - _noButton.height - 35;
			_noButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{ dispatchEvent(new UIEvent(UIEvent.NO_BUTTON)); } );				
			addChild(_noButton);			
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
		
		protected function onButtonRollOut(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .3, {alpha:0});
		}

		protected function onButtonRollOver(e:MouseEvent):void
		{
			TweenLite.to(e.target.over, .5, {alpha:1});
		}

		protected function get okButton():FormButton { return _okButton; }
		protected function get noButton():FormButton { return _noButton; }

	}
	
}
