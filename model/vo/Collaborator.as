package model.vo {

	public class Collaborator {

	// share props //	
		public var firstName			:String;
		public var lastName				:String;
		public var avatarURL			:String;
		public var userName				:String;
		public var passWord				:String;
		public var userEmail			:String;
		
	// beanstalk specific props //
		public var admin				:Boolean;
		public var owner				:Boolean;
		public var userId				:uint;		
		public var read					:Boolean = true;
		public var write				:Boolean;
		public var permissions			:Array = [];
		
	}
	
}
