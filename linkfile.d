import std;
string humanname(string s){
	import std.ascii;
	auto range=s.splitter!(a=>!a.isAlphaNum)
		.filter!(a=>a.length>0)
		.filter!(a=>!a.startsWith("http"))
		.filter!(a=>!a.startsWith("html"))
		.filter!(a=>!a.startsWith("com"))
		.filter!(a=>!a.startsWith("mail"))
		.filter!(a=>!a.startsWith("www"))
		.filter!(a=>!a.startsWith("boards"))
		.array;
	if(range[0]==range[$-1]){return range[0];}
	return range[0]~"."~range[$-1];
}
string inputfile="example.lks";
File input;
typeof((){return input.byLineCopy;}()) r;
void pokerange(){
	input=File(inputfile);
	r=input.byLineCopy;
}
void handlefile(ref string lable,ref string[] links,ref string[] humannames){
	if(r.empty){return;}
	if(r.front[0..3]=="---"){
		lable=r.front[3..$];
		r.popFront;
	}
	while(!r.empty&&r.front[0..3]!="---"){
		if(r.front.canFind('|')){
			auto i=r.front.countUntil('|');
			humannames~=r.front[0..i];
			links~=r.front[i+1..$];
		} else {
			humannames~=humanname(r.front);
			links~=r.front;
		}
		r.popFront;
	}
}
unittest{
	pokerange;
	string lable;
	string[] links;
	string[] humannames;
	handlefile(lable,links,humannames);
	lable.writeln;
	links.writeln;
	humannames.writeln;
	handlefile(lable,links,humannames);
	lable.writeln;
	links.writeln;
	humannames.writeln;
}