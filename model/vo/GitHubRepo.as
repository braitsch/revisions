package model.vo {

	import model.remote.HostingAccount;

	public class GitHubRepo extends Repository {

		private var _obj:Object;

		public function GitHubRepo(o:Object)
		{
			_obj = o;
			super(HostingAccount.GITHUB +'-'+ o.name, o.ssh_url);
			super.lastUpdated = o.updated_at;
		}
		
		public function get description():String
		{
			return _obj.description;
		}
		
	}
	
}

//	pushed_at 2011-08-31T18:13:48Z
//	watchers 1
//	url https://api.github.com/repos/braitsch/revisions-bash
//	svn_url https://svn.github.com/braitsch/revisions-bash
//	size 124
//	description bash source for revisions
//	private true
//	owner [object Object]
//	forks 0
//	fork false
//	updated_at 2011-09-06T22:15:58Z
//	clone_url https://github.com/braitsch/revisions-bash.git
//	language Shell
//	master_branch null
//	created_at 2011-08-11T23:07:06Z
//	open_issues 0
//	name revisions-bash
//	git_url git://github.com/braitsch/revisions-bash.git
//	id 2194323
//	html_url https://github.com/braitsch/revisions-bash
//	ssh_url git@github.com:braitsch/revisions-bash.git
//	homepage null
