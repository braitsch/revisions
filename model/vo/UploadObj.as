package model.vo {

	public class UploadObj {
		
		public var service		:String; 	// github or beanstalk //
		public var repoId		:uint;		// beanstalk only //
		public var repoName		:String;
		public var repoDesc		:String;	// github only  //
		public var repoURL		:String;
		public var repoPrivate	:Boolean;	// github only //
		
	// the newly created repo & collab on success //	
		public var repository	:Repository;
		public var collaborator	:Collab;
		
	}
	
}
