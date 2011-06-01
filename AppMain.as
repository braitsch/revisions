package {

	import model.AppModel;
	import view.ui.AirContextMenu;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	[SWF(backgroundColor="#ffffff", frameRate="31", width=800, height=600)]

	public class AppMain extends Sprite {
	
		private static var _model		:AppModel = new AppModel();
		private static var _view		:AppView = new AppView();
		
		public function AppMain()
		{	
			addChild(_view);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			AirContextMenu.initialize(stage);
		}
		
	}
	
}
