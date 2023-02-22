import basic;

enum words=["one", "two", "three", "four","five", "six", "seven", "eight"];
File o;
int tab=0;
void w(string s){
	foreach(i;0..tab){
		s="	"~s;}
	o.writeln(s);
}

void main(string[] s){
	import color;
	import linkfile;
	pokerange;
	
	if(s.length>=2){
		inputfile=s[1];
	}
	if(s.length>=3){
		theme=s[2];
	}
	string pic;
	if(s.length>=4){
		if(s[3]!="none"){
			pic=s[3];
	}}
	string file="index.html";
	if(s.length>=5){
		file=s[4];
	}
	o=File(file, "w");
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
	".top {".w;
	"	position:absolute;".w;
	"	top: 15vh;".w;
	"	max-height:40vh;".w;
	"	max-width:33vw;".w;
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
	("<img src="~pic~" class='top'>").w;
	"<div class='bot'>".w;tab++;
	"<div><p></div>".w;
	"<div class='flex-container'>".w; tab++;
	static foreach(i,e;words){{
		string lable;
		string[] links;
		string[] humannames;
		handlefile(lable,links,humannames);
		if(lable.length>0){
			("<div class='"~e~"'>").w;tab++;
			
			
			("<h2>"~lable~"</h2>").w;tab++;
			foreach(i;0..links.length){
				("<p><a href="~links[i]~">"~humannames[i]~"</a></p>").w;
			} tab--;
			tab--;"</div>".w;
	}}}
	tab--;"</div>".w;
	tab--;"</div>".w;
	tab--;"</div>".w;
	"</body>".w;
	"</html>".w;
}