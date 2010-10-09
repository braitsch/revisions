package view.layout {
	import commands.UICommand;

	public class NestedList extends SimpleList {	

		public function NestedList()
		{
			addEventListener(UICommand.TOGGLE_OPEN_DIRECTORY, onToggleSubItems);			
		}

		private function onToggleSubItems(e:UICommand):void 
		{
			super.activeItem = e.target as ListItem;
			var n:uint = super.container.getChildIndex(super.activeItem);
			var d:Vector.<ListItem> = e.data.subdirs;
			var h:uint = d[0].height;
			if (e.data.open==true){
				insertIntoList(n, d, h);
			}	else{
				removeFromList(n, h);
			}			
		}
		
		private function insertIntoList(n:uint, d:Vector.<ListItem>, h:Number):void 
		{
			for (var i : int = 0; i < d.length; i++) {
				d[i].x = super.activeItem.x+24;
				d[i].y = super.activeItem.y+h+(h*i);
				super.container.addChildAt(d[i], n+i+1);
			}			
			for (var j : int = n+i+1; j < super.container.numChildren; j++) {
				var k:ListItem = super.container.getChildAt(j) as ListItem;
				k.y+=(h*d.length);
			}
		}		

		private function removeFromList(n:uint, h:Number):void 
		{	
			var d:Vector.<ListItem> = new Vector.<ListItem>();
			for (var i : int = n+1; i < super.container.numChildren; i++) {
				var k:ListItem = super.container.getChildAt(i) as ListItem;
				if (k.x <= super.activeItem.x) break;
				d.push(k);
			}			
			for (var j : int = 0; j < d.length; j++) super.container.removeChild(d[j]);
			for (var w : int = n+1; w < super.container.numChildren; w++) {
				var o:ListItem = super.container.getChildAt(w) as ListItem;
				o.y-=(h*d.length);
			}				
		}

	}
	
}
