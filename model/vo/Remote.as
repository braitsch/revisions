package model.vo {

	public class Remote {

		private var _name		:String;
		private var _url		:String;
		private var _branches	:Array = [];

		public function Remote($name:String, $url:String)
		{
			_name = $name; _url = $url;
		}

		public function get name():String
		{
			return _name;
		}

		public function get url():String
		{
			return _url;
		}
		
		public function addBranch(s:String):void
		{
			_branches.push(s);
		}
		
		public function hasBranch(s:String):Boolean
		{
			for (var i:int = 0; i < _branches.length; i++) if (_branches[i] == s) return true;
			return false;
		}

	}
	
}
