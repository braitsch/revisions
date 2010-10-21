package model {

	public class Commit {
	
		private var _sha1	:String;
		private var _index	:String;
		private var _date	:String;
		private var _author	:String;
		private var _note	:String;
		private var _branch	:Branch;

		public function Commit(o:Object)
		{
			_index 	= o.index;
			_sha1 	= o.sha1;
			_date 	= o.date;
			_author = o.author;
			_note 	= o.note;
			_branch = o.branch;
		}

		public function get index():String
		{
			return _index;
		}
		
		public function get sha1():String
		{
			return _sha1;
		}

		public function get date():String
		{
			return _date;
		}

		public function get author():String
		{
			return _author;
		}

		public function get note():String
		{
			return _note;
		}
		
		public function get branch():Branch
		{
			return _branch;
		}		

	}
	
}
