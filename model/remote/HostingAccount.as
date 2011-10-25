package model.remote {

	import flash.events.EventDispatcher;
	import model.vo.Collaborator;
	import model.vo.Repository;
	import view.avatars.Avatar;
	import view.avatars.Avatars;
	
	public class HostingAccount extends EventDispatcher {
		
		public static const GITHUB		:String = 'GitHub';
		public static const BEANSTALK	:String = 'Beanstalk';
		
		private var _user				:String;
		private var _pass				:String;
		private var _acctName			:String;
		private var _acctType			:String;
		private var _sshKeyId			:uint;
		
		private var _avatar				:Avatar;
		private var _fullName			:String;
		private var _location			:String;
		private var _repository			:Repository;
		private var _repositories		:Vector.<Repository> = new Vector.<Repository>();
		private var _collaborators		:Vector.<Collaborator>; // beanstalk only //

		public function HostingAccount(o:Object)
		{
			_user = o.user;
			_pass = o.pass;
			_acctName = o.acct;
			_acctType = o.type;
			_sshKeyId = o.sshKeyId;
		}
		
		public function set loginData(o:Object):void
		{
			_fullName = o.name;
			_location = o.location;
			_avatar = Avatars.getAvatar(o.email);
		}

		public function get user()			:String 	{ return _user; 		}
		public function get pass()			:String 	{ return _pass; 		}
		public function get acctName()		:String 	{ return _acctName; 	}
		public function get acctType()		:String 	{ return _acctType; 	}
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
		
		public function addCollaborator(o:Collaborator):void
		{
		// avoids requesting list when adding collab from account view //
			if (_collaborators) _collaborators.push(o);	
		}
		
		public function killCollaborator(o:Collaborator):void
		{
		// avoids requesting list when removing collab from account view //
			for (var i:int = 0; i < _collaborators.length; i++) if (o == _collaborators[i]) break;
			_collaborators.splice(i, 1);
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
