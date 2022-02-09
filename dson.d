auto toplevelcommaspilt(string s_){//probaly should be stress tested with truely awful nested strings
	struct range{
		string s;
		int si=0;int sj=0;
		bool inquotes=false;
		bool excaped=false;
		int parens=0;
		void checkparens(char c){
			if(inquotes){return;}
			if(
				'('==c ||
				'['==c ||
				'{'==c
			){parens++;}
			if(
				')'==c ||
				']'==c ||
				'}'==c
			){parens--;}
		}
		void checkexcaped(char c){
			excaped=c=='\\';
		}
		void checkquote(char c){
			if(c=='"'&& ! excaped){inquotes= ! inquotes;}
		}
		string front(){return s[si%$..sj%($+1)];}
		auto empty(){return sj>s.length;}
		auto empty_(){return sj>=s.length;}
		void popFront(){
			sj++;
			si=sj;
			l:if(empty_){return;}
			checkparens(s[sj]);
			checkquote(s[sj]);
			checkexcaped(s[sj]);
			if(s[sj]!=','|| parens!=0||inquotes){sj++;goto l;}
		}
		void init(){
			popFront();
			si=0;
		}
	}
	auto o=range(s_); o.init;
	return o;
}
unittest{
	import std;
	//"hello,(,,,),T!*[x,x,x],hi".toplevelcommaspilt.each!writeln;
}
struct cerial(P){//T is needed internally
	P payload;
	auto ready(T:char)(string s){//todo char and string should be far more complex for excaped chars... but the spec for strings is over the top and I dont use most of it
		assert(s[0]=='\'');
		assert(s[2]=='\'');
		payload=s[1];
	}
	string writey(T:char)(){
		return ['\'',payload,'\''];
	}
	auto ready(T:string)(string s){
		assert(s[0]=='"');
		assert(s[$-1]=='"');
		payload=s[1..$-1];
	}
	string writey(T:string)(){
		return "\""~payload~"\"";
	}
	auto ready(T:int)(string s){
		import std.conv;
		payload=s.to!T;
	}
	string writey(T:int)(){
		import std.conv;
		return payload.to!string;
	}
	auto ready(T:float)(string s){
		import std.conv;
		payload=s.to!T;
	}
	string writey(T:float)(){
		import std.conv;
		return payload.to!string;
	}
	/*
		auto ready(T:)(string s){
		import std.conv;
		payload=s.to!T;
	}
	string writey(T:)(){
		import std.conv;
		return payload.to!string;
	}
	*/
	//----
	void readstruct(T)(string s){
		enum name=T.stringof;
		if(s.length < name.length+2){return;}
		assert(s[0..name.length]==name,"mismatched name");
		assert(s[name.length]=='('&& s[$-1]==')',"() mismatch");
		import std.traits;
		enum string[] fields=[FieldNameTuple!T];
		//import std; fields.writeln;
		string[] store; store.reserve(fields.length);
		foreach(s_;s[name.length+1..$-1].toplevelcommaspilt){
			store~=s_;}
		static foreach(i,f;fields){ { //double scope so alias works
			if(store.length==i){store~="";}
			alias S=typeof(mixin("T()."~f));
			//import std; S.stringof.writeln;
			mixin("payload."~f)=cerial!S().read(store[i]).payload;
		} }
	}
	string writestruct(T)(){
		string o=T.stringof;
		o~='(';
		enum string[] fields=[FieldNameTuple!T];
		static foreach(i,f;fields){ {
			alias S=typeof(mixin("T()."~f));
			o~=cerial!S(mixin("payload."~f)).write;
			if(i!=fields.length-1){o~=',';}
		} }
		o~=')';
		return o;
	}
	void readarray(T)(string s){
		assert(s[0]=='[' && s[$-1]==']',"arrays are [] >:(");
		foreach(e;toplevelcommaspilt(s[1..$-1])){
			payload~=cerial!(typeof(payload[0]))().read(e).payload;
		}
	}
	string writearray(T)(){
		string o="[";
		foreach(i,e;payload){
			o~=cerial!(typeof(payload[0]))(e).write;
			if(i!=payload.length-1){o~=',';}
		}
		o~=']';
		return o;
	}
	//----
	import std.traits;
	auto read(string s){
		static if(is(P==struct)){
			readstruct!P(s);
		}else{static if(isArray!P && !is(P==string)){//aghh supporting dstring and the other one will be annoying
			readarray!P(s);
		}else{
			ready!P(s);
		}}
		return this;//I kept writing inline reads.... may as well make it work
	}
	string write(){
		static if(is(P==struct)){
			return writestruct!P;
		}else{static if(isArray!P && !is(P==string)){
			return writearray!P;
		}else{
			return writey!P();
	}}}
	//----
	void assert_(){
		typeof(this) temp;
		temp.read(write());
		assert(temp.payload==payload);
		import std; temp.write.writeln;
	}
}
unittest{
	cerial!char('a').assert_;
	cerial!char('Z').assert_;
	cerial!string("foo").assert_;
	cerial!string("\"").assert_;
	cerial!int(1).assert_;
	cerial!int(100).assert_;
	struct vec2{int x; int y;}
	import std;
	cerial!vec2(vec2(1,2)).assert_;
	cerial!(vec2[])([vec2(1,2),vec2(3,4),vec2(5,6)]).assert_;
	struct foo{vec2[] HHBNLKJBHVY;}
	struct bar{foo a; foo b;}
	cerial!bar().assert_;
}