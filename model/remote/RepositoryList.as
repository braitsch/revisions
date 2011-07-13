package model.remote {

	import flash.display.Sprite;

	public class RepositoryList extends Sprite {

		private static var _spacing:uint = 5;

		public function RepositoryList(a:Array)
		{
			for (var i:int = 0; i < a.length; i++) {
				var rp:RepositoryItem = new RepositoryItem(a[i]);
				rp.y = (rp.height+_spacing) * i;
				addChild(rp);
			}	
		}

	}
	
}
