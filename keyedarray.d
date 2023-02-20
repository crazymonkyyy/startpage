struct keyarray(T,S){
	T[] keys;
	S[] values;
	void opIndexAssign(S v,T k){
		keys~=k;
		values~=v;
	}
	ref S opIndex(T k){
		import std;
		auto i=keys.countUntil(k);
		if(i==-1){
			keys~=k;
			values~=S.init;
			return values[$-1];
		}
		return values[i];
	}
}
unittest{
	keyarray!(int,int) foo;
	foreach(i;0..3){
		foo[i*2]=i*3;
	}
	assert(foo[4]==6);
}
unittest{
	enum foo=(){
		keyarray!(string,int[]) o;
		o["foo"]=[1,2,3];
		o["bar"]=[0];
		o["foobar"]=[];
		return o;
	}();
	assert(foo["bar"]==[0]);
	assert(foo["ohno"]==[]);
}