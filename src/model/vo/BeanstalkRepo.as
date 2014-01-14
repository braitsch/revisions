package model.vo {

	import model.remote.HostingAccount;

	public class BeanstalkRepo extends Repository {

		private var _xml:XML;

		public function BeanstalkRepo(xml:XML, url:String)
		{
			_xml = xml;	
			super(HostingAccount.BEANSTALK +'-'+ xml.name, url);
			super.lastUpdated = _xml['last-commit-at'];
		}

		override public function get id():uint
		{
			return _xml['id'];
		}
		
	}
	
}

//</repository>
//    <account-id type="integer">43878</account-id>
//    <color-label>label-blue</color-label>
//    <created-at type="datetime">2011-09-06T12:25:00-11:00</created-at>
//    <default-branch>master</default-branch>
//    <id type="integer">255616</id>
//    <last-commit-at type="datetime">2011-09-09T04:38:32Z</last-commit-at>
//    <name>revisions-source</name>
//    <storage-used-bytes type="integer">1601536</storage-used-bytes>
//    <title>revisions-source</title>
//    <type>GitRepository</type>
//    <updated-at type="datetime">2011-09-08T17:39:21-11:00</updated-at>
//    <vcs>git</vcs>
// </repository>
