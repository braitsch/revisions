package model.remote {

	import model.vo.Avatar;
	import model.vo.Collaborator;
	import model.vo.Repository;
	import flash.events.EventDispatcher;
	
	public class HostingAccount extends EventDispatcher {
		
		public static const GITHUB		:String = 'GitHub';
		public static const BEANSTALK	:String = 'Beanstalk';
		
		private var _acct				:String;
		private var _type				:String;
		private var _user				:String;
		private var _pass				:String;
		private var _sshKeyId			:uint;
		
		private var _avatar				:Avatar;
		private var _fullName			:String;
		private var _location			:String;
		private var _repository			:Repository;
		private var _repositories		:Vector.<Repository> = new Vector.<Repository>();
		private var _collaborators		:Vector.<Collaborator>; // beanstalk only //

		public function HostingAccount(o:Object)
		{
			_acct = o.acct;
			_type = o.type;
			_user = o.user;
			_pass = o.pass;
			_sshKeyId = o.sshKeyId;
		}
		
		public function set loginData(o:Object):void
		{
			_fullName = o.name;
			_location = o.location;
			_avatar = new Avatar(o.email);
		}

		public function get acctName()		:String 	{ return _acct; 		}
		public function get type()			:String 	{ return _type; 		}
		public function get user()			:String 	{ return _user; 		}
		public function get pass()			:String 	{ return _pass; 		}
		
		public function get avatar()		:Avatar 	{ return _avatar; 		}
		public function get fullName()		:String 	{ return _fullName; 	}
		public function get location()		:String 	{ return _location; 	}
		
		public function set sshKeyId(n:uint):void 		{ _sshKeyId = n; 		}
		public function get sshKeyId()		:uint 		{ return _sshKeyId;		}
		
		public function addRepository(rpo:Repository):void
		{
			_repository = rpo;
			_repositories.push(rpo);
			_repositories = sortByName(_repositories);
		}
		
		public function set repositories(v:Vector.<Repository>):void 	{ _repositories = sortByName(v);}
		public function get repositories():Vector.<Repository> 			{ return _repositories;	}

		public function set repository(r:Repository):void 				{ _repository = r; 		}
		public function get repository():Repository 					{ return _repository; 	}

		public function set collaborators(v:Vector.<Collaborator>):void { _collaborators = v; 	}
		public function get collaborators():Vector.<Collaborator> 		{ return _collaborators;}
		
		public function addCollaborator(o:Object):void
		{
		// avoids requesting list when adding collab from account view //
			if (_collaborators) _collaborators.push(o);	
		}
		
		private function sortByName(v:Vector.<Repository>):Vector.<Repository>
		{
			var a:Array = [];
			for (var i:int = 0; i < v.length; i++) a[i] = v[i];
				a.sortOn('repoName', Array.CASEINSENSITIVE);
			return Vector.<Repository>(a);
		}

	}
	
}
