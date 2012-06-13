package view.layout {
	import com.greensock.TweenLite;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ListItem extends Sprite {

		private var _file				:File;
		private var _active				:Boolean;
		private var _bkgd				:Shape = new Shape();	

		public function ListItem()
		{
			_bkgd.alpha = .5;
			addChildAt(_bkgd, 0);	
			
			buttonMode = true;
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}
		
	// public setters / getters 	
		
		public function draw(w:uint, h:uint = 20):void
		{
			_bkgd.graphics.clear();
			_bkgd.graphics.beginFill(0xffffff);
			_bkgd.graphics.drawRect(0, 0, w, h);			_bkgd.graphics.endFill();
		}
		
		public function set file($f:File):void
		{
			_file = $f;
		}
		
		public function get file():File
		{
			return _file;
		}	
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active($on:Boolean):void
		{
			_active = $on;
			TweenLite.to(_bkgd, .3, {alpha:_active ? 1 : .5});		
		}
		
		public function get index():uint
		{
			return this.parent.getChildIndex(this);
		}
		
	// mouse events //

		private function onRollOver(e:MouseEvent):void 
		{
			if (_active) return;
			TweenLite.to(_bkgd, .3, {alpha:1});
		}
		
		private function onRollOut(e:MouseEvent):void 
		{
			if (_active) return;
			TweenLite.to(_bkgd, .3, {alpha:.5});
		}
		
//		protected function getFileSystemIcon(bmd:BitmapData):Bitmap 
//		{
//			var bmp:Bitmap = new Bitmap(bmd);
//				bmp.y = 2; 
//				bmp.x = 4;
//			bmp.width = bmp.height = 16;			
//			return(bmp);	
//		}		
		
	}
	
}
