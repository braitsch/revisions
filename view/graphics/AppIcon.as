package view.graphics {

	import model.AppModel;
	import flash.desktop.NativeApplication;
	
	public class AppIcon {

		private static var _iconRedLG	:AppIconRed = new AppIconRed();
		private static var _iconGrnLG	:AppIconGreen = new AppIconGreen();
		private static var _iconClnLG	:AppIconClean = new AppIconClean();

		public static function setApplicationIcon():void
		{
			if (AppModel.bookmark == null){
				NativeApplication.nativeApplication.icon.bitmaps = [_iconClnLG];
			} 	else if (AppModel.bookmark.remotes.length == 0){
				NativeApplication.nativeApplication.icon.bitmaps = [_iconClnLG];
			}	else if (AppModel.branch.remoteStatus >= 0){
				NativeApplication.nativeApplication.icon.bitmaps = [_iconGrnLG];
			}	else{
				NativeApplication.nativeApplication.icon.bitmaps = [_iconRedLG];
			}
		}
		
	}
	
}
