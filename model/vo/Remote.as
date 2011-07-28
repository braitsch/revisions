package model.vo {

	public class Remote {

		private var _name	:String;
		private var _fetch	:String;
		private var _push	:String;

		public function Remote($name:String, $fetch:String, $push:String)
		{
			_name = $name;
			_fetch = $fetch;
			_push = $push;
			trace('_name:'+_name+'::');
			trace('_fetch:'+_fetch+'::');
			trace('_push:'+_push+'::');
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

	}
	
}