import basic;
static foreach(i;0..8){
	mixin("string grouplable"~i.to!string~";");
	mixin("string[] grouplinks"~i.to!string~";");
}
enum words=["one", "two", "three", "four","five", "six", "seven", "eight"];
File o;
int tab=0;
void w(string s){
	foreach(i;0..tab){
		s="	"~s;}
	o.writeln(s);
}
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

void main(string[] s){
	import colorswap;
	mixin makecolors!();
	loaddefualtcolors;
	//colors.writeln;
	//import settingv2;  // doesnt handle comma seperated urls correctly
	//mixin setup!"links";
	//reload!"links";
	mixin(import("links.mix"));
	
	grouplinks1.writeln;
	
	o=File("index.html", "w");
	"<!DOCTYPE html>".w;
	"<html>".w;
	"<head>".w;
	"<style>".w; tab++;
	"body {".w;
	"	display: flex;".w;
	"	align-items: center;".w;
	"	justify-content: center;".w;
	("	background-color:"~background.tohex~";").w;
	"}".w;
	".bot{".w;
	"	display: flex;".w;
	"	position: fixed;".w;
	"	bottom: 0;".w;
	"	align-items: center;".w;
	"	justify-content: center;".w;
	"}".w;
	".flex-container {".w;
	"	display: flex;".w;
	("	background-color:"~hightlight.tohex~";").w;
	"	align-content: 'flex-end';".w;
	"	align-items: center;".w;
	"	flex-wrap: wrap;".w;
	"	justify-content: center;".w;
	"	align-self: flex-end;".w;
	"}".w;
	
	foreach(i,e;words){
		("."~e~"{").w;tab++;
		("background-color:"~brightbackground.tohex~";").w;
		("color:"~colors[8+i].tohex~";").w;
		"margin: 10px;".w;
		"padding: 20px;".w;
		"border-style: solid;".w;
		tab--; "}".w;
		
		("."~e~" a {").w;tab++;
		("color:"~colors[8+i].tohex~";").w;
		//("background-color:"~background.tohex~";").w;
		tab--;"}".w;
	}
	
	tab--;"</style>".w; "<head>".w; "<body>".w;
	//"<h1> this is a startpage</h1>".w;
	"<div class='bot'>".w;tab++;
	"<div><p></div>".w;
	"<div class='flex-container'>".w; tab++;
	static foreach(i,e;words){{
		string lable=mixin("grouplable"~i.to!string);
		string[] links=mixin("grouplinks"~i.to!string);
		if(lable.length>0){
			("<div class='"~e~"'>").w;tab++;
			
			
			("<h2>"~lable~"</h2>").w;tab++;
			foreach(link;links){
				("<p><a href="~link~">"~humanname(link)~"</a></p>").w;
			} tab--;
			tab--;"</div>".w;
	}}}
	tab--;"</div>".w;
	tab--;"</div>".w;
	tab--;"</div>".w;
	"</body>".w;
	"</html>".w;
}