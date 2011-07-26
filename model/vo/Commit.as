package model.vo {

	public class Commit {
	
		private var _sha1	:String;
		private var _date	:String;
		private var _author	:String;
		private var _note	:String;
		private var _index	:uint;

		public function Commit(s:String, n:uint)
		{
			var a:Array = s.split('##');
			_sha1 	= a[0];
			_date 	= a[1];
			_author = a[2];
			_note 	= a[3];
			_index  = n;
			if (_date == '0 seconds ago') {
				_date = 'Just now';
			}	else if (_date.indexOf('1 year') != -1){
				_date = 'Over 1 year ago';
			}
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
		
		public function get index():uint
		{
			return _index;
		}		
		
	}
	
}
