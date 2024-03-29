package model.vo {

	public class Collaborator {

	// share props //	
		public var firstName			:String;
		public var lastName				:String;
		public var userName				:String;
		public var passWord				:String;
		public var userEmail			:String;
		public var avatarURL			:String;
		
	// beanstalk specific props //
		public var admin				:Boolean;
		public var owner				:Boolean;
		public var userId				:uint;		
		public var permissions			:Vector.<Permission>;
		
	}
	
}
