package model.remote {

	import flash.display.Bitmap;
	public class RemoteAccount {
		
		public static const GITHUB		:String = 'github';
		public static const BEANSTALK	:String = 'beanstalk';
		public static const PRIVATE		:String = 'private';
		
		private var _name		:String;
		private var _pass		:String;
		private var _type		:String;
		private var _avatar		:Bitmap;

		public function RemoteAccount(s:String, n:String, p:String, a:String)
		{
			_type = s;
			_name = n;
			_pass = p;
			loadAvatar(a);
		}

		public function get type():String { return _type; }
		public function get name():String { return _name; }
		public function get pass():String { return _pass; }
		public function get avatarURL():Bitmap { return _avatar; }
		
		private function loadAvatar(url:String):void
		{
			
		}		
		
	}
	
}
