import std;
enum filename="base-16.csv";
struct color{
	int r;
	int g;
	int b;
	string tohex(){
		string o="#";
		enum chars=['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
		o~=chars[r/16];
		o~=chars[r%16];
		o~=chars[g/16];
		o~=chars[g%16];
		o~=chars[b/16];
		o~=chars[b%16];
		return o;
	}
}
auto rebase(T)(T a, T min, T max){
	if(a>=min&&a<=max){
		return a-min;
	}
	alias S=typeof(T.init-T.init);
	return S.max-11;//hack
}
int hextoint(char c){
	return min(
		c.rebase('0','9'),
		c.rebase('a','f')+10,
		c.rebase('A','F')+10,
	);
}
color tocolor(string s){
	return color(
		s[0].hextoint*16+s[1].hextoint,
		s[2].hextoint*16+s[3].hextoint,
		s[4].hextoint*16+s[5].hextoint,
	);
}
enum color[16][string] base16=(){
	color[16][string] o;
	foreach(s;import(filename).split('\n')){
		auto a=s.splitter(',').array.to!(string[]);
		o[a[0]]=a[1..$].filter!(a=>a.length==6).map!tocolor.staticArray!16;
	}
	return o;
}();
//enum color[16][string] base16=(){return __base16;}();
enum colornames=["background","brightbackground","selection","hightlight",
		"darktext","text","brighttext","brightwhite",
		"red","good","yellow","green",
		"cyan","blue","purple","evil"];

string theme="solarized-dark";
static foreach(i,s;colornames){
	mixin("color "~s~"(){ return base16[theme]["~i.to!string~"];}");
}
color[16] colors(){ return base16[theme];}