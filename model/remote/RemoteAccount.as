package model.remote {

	public class RemoteAccount {
		
		public static const GITHUB		:String = 'github';
		public static const BEANSTALK	:String = 'beanstalk';
		public static const PRIVATE		:String = 'private';
		
		private static var _name		:String;
		private static var _pass		:String;
		private static var _type		:String;

		public function RemoteAccount(s:String)
		{
			_type = s;
		}
		
		public function get type():String { return _type; }

		public function get name():String { return _name; }
		public function set name(name:String):void { _name = name; }

		public function get pass():String { return _pass; }
		public function set pass(s:String):void { _pass = s; }
		
	}
	
}
