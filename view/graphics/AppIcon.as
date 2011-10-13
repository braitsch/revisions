package view.graphics {

	import model.AppModel;
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	
	public class AppIcon {

		private static var _iconMdMC	:AppIconMD = new AppIconMD();
		private static var _iconLgMC	:AppIconLG = new AppIconLG();
		private static var _iconMdK		:BitmapData = new BitmapData(64, 64, true, 0x000000);
		private static var _iconLgK		:BitmapData = new BitmapData(128, 128, true, 0x000000);	
		private static var _iconMdX		:AppIconMDX = new AppIconMDX();	
		private static var _iconLgX		:AppIconLGX = new AppIconLGX();	

		public static function setApplicationIcon():void
		{
			if (AppModel.branch.remoteStatus >= 0){
				NativeApplication.nativeApplication.icon.bitmaps = [_iconMdX, _iconLgX];
			}	else{
				_iconMdMC.num.text = _iconLgMC.num.text = Math.abs(AppModel.branch.remoteStatus).toString();
				_iconMdK.draw(_iconMdMC); _iconLgK.draw(_iconLgMC);		
				NativeApplication.nativeApplication.icon.bitmaps = [_iconMdK, _iconLgK];
			}
		}
		
		
	}
	
}
