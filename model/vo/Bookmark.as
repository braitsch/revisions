package model.vo {

	import events.BookmarkEvent;
	import model.AppEngine;
	import model.AppModel;
	import system.StringUtils;
	import com.adobe.crypto.MD5;
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;

	public class Bookmark extends EventDispatcher {

		public static const	FILE		:String = 'file';
		public static const	FOLDER		:String = 'folder';

		private var _label				:String;	// user generated name of bookmark //
		private var _path				:String;	// local file path to the thing we're tracking //
		private var _type				:String; 	// is either FILE or FOLDER //
		private var _gitdir				:String;	// location of the actual .git directory	
		private var _active				:Boolean;
		private var _autosave			:uint;	
		
		private var _file				:File;		// for internal use only //
		private var _timer				:Timer;
		private var _icon32				:Bitmap;
		private var _icon128			:Bitmap;
		private var _stash				:Array = [];
		private var _branch				:Branch;	// the currently active branch //
		private var _remotes			:Vector.<Remote> = new Vector.<Remote>();
		private var _branches			:Array = [];

		public function Bookmark(o:Object)
		{
			_type = o.type;
			_active = o.active;
			_autosave = o.autosave;
			this.path = o.path;
			this.label = o.label;
			if (_autosave) initAutoSave();
		//	trace('New Bookmark Created :: '+_label); 
		}

		public function get branch():Branch { return _branch; }		
		public function set branch(b:Branch):void { _branch = b; }
		public function get active():Boolean { return _active; }
		public function set active(b:Boolean):void { _active = b; }
		public function set autosave(n:uint):void { _autosave = n; }
		public function get autosave():uint { return _autosave; }

		public function get icon32():Bitmap { return _icon32; }
		public function get icon128():Bitmap { return _icon128; }
		public function get type():String { return _type; }
		public function get exists():Boolean { return _file.exists; }
		public function get gitdir():String { return _gitdir;}
		public function get worktree():String { return _file.parent.nativePath; }
		public function get branches():Array { return _branches; }
		
		public function get label():String { return _label; }		
		public function set label(s:String):void
		{
			_label = s;
			dispatchEvent(new BookmarkEvent(BookmarkEvent.EDITED));
		}
		public function get path():String { return _path; }
		public function set path(p:String):void
		{
			_path = p;
			if (_type == Bookmark.FOLDER){
				 _gitdir = _path;
			}	else{
				 _gitdir = File.applicationStorageDirectory.nativePath+'/'+MD5.hash(_path);			
			}
			_file = new File('file://'+_path);			
			getFileSystemIcons();
		}
		
		public function get stash():Array { return _stash; }
		public function set stash(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				var n:String = a[i].replace(/stash@\{[0-9]*}: WIP on /, '');
				_stash.push(n.substring(0, n.indexOf(':')));	
			}
		}
		
		private function getFileSystemIcons():void
		{
			var icons:Array = _file.icon.bitmaps;
			for (var i:int = 0; i < icons.length; i++) {
				if (icons[i].width == 32) _icon32 = new Bitmap(icons[i]);
				if (icons[i].width == 128) _icon128 = new Bitmap(icons[i]);
			}
		}
		
		public function parseRemotes(a:Array):void
		{
			var n:String = a[0];
			var f:String = a[1].substr(0, a[1].search(/\s/));
			var p:String = a[3].substr(0, a[3].search(/\s/));
			_remotes.push(new Remote(n, f, p));
		}
		
		public function addRemote(r:Remote):void
		{
			_remotes.push(r);
		}
		
		public function get remotes():Vector.<Remote>
		{
			return _remotes;
		}			
		
		public function getRemoteByProp($prop:String, $value:String):Remote
		{
			for (var i:int = 0; i < _remotes.length; i++) if (_remotes[i][$prop] == $value) return _remotes[i];
			return null;
		}
		
	// branches //	
			
		public function attachBranches(a:Array):void
		{
			for (var i:int = 0; i < a.length; i++) {
				var s:String = a[i];
					s = StringUtils.trim(s);
				if (s.indexOf('*') == 0){
					s = s.substr(2);
					_branch = new Branch(s);
					_branches.push(_branch);
				}	else{
					_branches.push(new Branch(s));
				}
			}
			sortBranches();
		}
		
		private function sortBranches():void
		{
		// ensure master is always the first in the list //	
			var m:Branch = getBranchByName('master');
			_branches.splice(_branches.indexOf(m), 1);
			_branches.unshift(m);
		}
		
		private function getBranchByName(n:String):Branch 
		{
			for (var i:int = 0;i < _branches.length; i++) if (n == _branches[i].name) break;
			return _branches[i];
		}
		
		private function initAutoSave():void
		{
			_timer = new Timer(_autosave * 60 * 1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
			_timer.start();
		}

		private function onTimerEvent(e:TimerEvent):void
		{
			AppModel.proxies.status.autoSave(this);
		}
		
	// static validation function //
	
		public static function validate(n:String, p:String, b:Bookmark = null):String
		{
			if (n == '') {
				return 'Project name cannot be empty.';
			}
			if (p == '') {
				return 'Selected target is not valid.';
			}
			if (p == '/') {
				return 'Sorry, tracking the ENTIRE file system is not supported.';
			}			
			var f:File = new File('file://'+p);
			if (!f.exists){
				return 'Target not found.\nPlease check the file path.';
			}
			if (f.isPackage){
				return 'Tracking Applications & binaries is not supported.';
			}
			if (p.indexOf('/Applications') == 0){
				return 'Tracking Applications & binaries is not supported.';
			}			
			if (p.indexOf('/Volumes') == 0){
				return 'Sorry, tracking files on external volumes is not yet supported.';
			}			
			var i:int;
			var v:Vector.<Bookmark> = AppEngine.bookmarks;
		// check names //	
			for (i = 0; i < v.length; i++) {
				if (n == v[i].label) {
					if (b == null){
						return 'The name "'+v[i].label+'" is already taken.\nPlease choose something else.';
					} else if (n != b.label){
						return 'The name "'+v[i].label+'" is already taken.\nPlease choose something else.';
					}
				}
			}
		// check paths //	
			for (i = 0; i < v.length; i++) {
				if (MD5.hash(p) == MD5.hash(v[i].path)){
					var w:String = p.substr(p.lastIndexOf('/')+1);
					var k:String = f.isDirectory ? 'folder' : 'file';
					if (b == null){
						return 'The '+k+' "'+w+'" is already being tracked by the bookmark "'+v[i].label+'".';
					}	else if (p != b.path){
						return 'The '+k+' "'+w+'" is already being tracked by the bookmark "'+v[i].label+'".';
					}				
				}
			}
			return '';
		}

	}
	
}
