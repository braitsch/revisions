package view.bookmarks {

	public class Branch {

		private var _name		:String;
		private var _history	:Array;
		private var _modified	:Boolean;

		public function Branch($n:String) 
		{
			_name = $n;
			trace('new branch created, name='+_name, _name.length);
		}
		
		public function get name():String
		{
			return _name;
		}		
		
		public function get history():Array
		{
			return _history;
		}
		
		public function set history($a:Array):void
		{
			_history = $a;
		}
		
		public function get modified():Boolean
		{
			return _modified;
		}
		
		public function set modified($m:Boolean):void
		{
			_modified = $m;
		}
		
	}
	
}