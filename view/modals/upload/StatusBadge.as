package view.modals.upload {

	import model.remote.HostingAccount;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class StatusBadge extends Sprite {

		private static var _mask	:Shape = new Shape();
		private static var _view	:StatusBadgeMC = new StatusBadgeMC();
		private static var _page	:Bitmap;
		private static var _total	:Bitmap = new Bitmap(new Status5());

		public function StatusBadge()
		{
			drawMask();
			addChild(_view);
			addChild(_mask);
			_view.addChild(_total);
			_total.x = 84; _total.y = 12;
			_view.beanstalk.visible = _view.github.visible = false;
		}
		
		private function reset():void
		{
			TweenLite.to(_view, .5, {x:133, onComplete:function():void{_view.beanstalk.visible = _view.github.visible = false;}});
		}
		
		public function set page(n:uint):void
		{
			if (n == 1) this.reset();
			if (_page) _view.removeChild(_page);
			switch(n){
				case 1 : _page = new Bitmap(new Status1()); break;
				case 2 : _page = new Bitmap(new Status2()); break;
				case 3 : _page = new Bitmap(new Status3()); break;
				case 4 : _page = new Bitmap(new Status4()); break;
				case 5 : _page = new Bitmap(new Status5()); break;
				case 5 : _page = new Bitmap(new Status6()); break;
			}
			_view.addChild(_page);
			_page.x = 45; _page.y = 12;
		}
		
		public function set service(s:String):void
		{
			if (s == HostingAccount.GITHUB){
				_view.github.visible = true;
				_view.beanstalk.visible = false;
			}	else if (s == HostingAccount.BEANSTALK){
				_view.github.visible = false;
				_view.beanstalk.visible = true;
			}
			TweenLite.to(_view, .3, {x:166});
		}
		
		private function drawMask():void
		{
			_mask.x = 166;
			_mask.graphics.beginFill(0xff0000, .3);
			_mask.graphics.drawRect(0, 0, 130, 60);
			_mask.graphics.endFill();
			_view.mask = _mask;
		}
		
	}
	
}
