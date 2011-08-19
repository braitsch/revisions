package model.remote {

	import flash.events.EventDispatcher;
	public class Account extends EventDispatcher {
		
		public static const GITHUB		:String = 'GitHub';
		public static const BEANSTALK	:String = 'Beanstalk';
		
		private var _type				:String;
		private var _user				:String;
		private var _pass				:String;
		private var _sshKeyId			:uint;
		
		private var _fullName			:String;
		private var _location			:String;
		private var _avatarURL			:String;
		private var _repositories		:Array;

		public function Account(o:Object)
		{
			_type = o.type;
			_user = o.user;
			_pass = o.pass;
			_sshKeyId = o.sshKeyId;
		}
		
		public function set loginData(o:Object):void
		{
			_fullName = o.name;
			_location = o.location;
			_avatarURL = o.avatar_url;
		}

		public function get type()			:String 	{ return _type; 		}
		public function get user()			:String 	{ return _user; 		}
		public function get pass()			:String 	{ return _pass; 		}
		
		public function get fullName()		:String 	{ return _fullName; 	}
		public function get location()		:String 	{ return _location; 	}
		public function get avatarURL()		:String 	{ return _avatarURL; 	}
		
		public function set repositories(a:Array):void 	{ _repositories = a;	}
		public function get repositories()	:Array  	{ return _repositories;	}
		
		public function set sshKeyId(n:uint):void 		{ _sshKeyId = n; 		}
		public function get sshKeyId()		:uint 		{ return _sshKeyId;		}

	}
	
}
