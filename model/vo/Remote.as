package model.vo {

	public class Remote {

		private var _name		:String;
		private var _fetch		:String;
		private var _push		:String;
		private var _branches	:Array = [];

		public function Remote($name:String, $fetch:String, $push:String)
		{
			_name = $name;
			_fetch = $fetch;
			_push = $push;
		//	trace("Remote.Remote($name, $fetch, $push)", _name, _fetch);
		}

		public function get name():String
		{
			return _name;
		}

		public function get fetch():String
		{
			return _fetch;
		}

		public function get push():String
		{
			return _push;
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
