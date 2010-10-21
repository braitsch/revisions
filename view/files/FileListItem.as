package view.files {
	import model.proxies.StatusProxy;

	import view.layout.ListItem;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;

	public class FileListItem extends ListItem {

		private static var blue		:IconBallBlue = new IconBallBlue(15, 15);		private static var green	:IconBallGreen = new IconBallGreen(15, 15);		private static var grey		:IconBallGrey = new IconBallGrey(15, 15);		private static var orange	:IconBallOrange = new IconBallOrange(15, 15);
		
		private var _view			:FileItemMC = new FileItemMC();
		private var _label			:String;
		private var _icon			:Bitmap;

		public function FileListItem($file:File) 
		{
			super.file = $file;
			super.draw(440, 20);
			
			_view.label_txt.x = 25;
			_view.label_txt.autoSize = 'left';
			_view.label_txt.mouseEnabled = false;
			_label = super.file.url.substr(super.file.url.lastIndexOf('/') + 1).replace(/%20/g, ' ').replace('.app', '');
			_view.label_txt.text = _label;
			_view.mouseEnabled = false;			
			addChild(_view);
		}

		public function set status(s:int):void
		{
			if (_icon) _icon == null;
			var bmd:BitmapData;
			if (s==StatusProxy.M) bmd = orange as BitmapData; 
			if (s==StatusProxy.T) bmd = green as BitmapData;			if (s==StatusProxy.U) bmd = grey as BitmapData; 			
			if (s==StatusProxy.I) bmd = blue as BitmapData; 
			_icon = new Bitmap(bmd);
			_icon.x = 4;			_icon.y = 2.5;
			addChild(_icon);
		}		
		
	}
	
}
