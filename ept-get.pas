program eptget;

uses args, unixtools, unix, strutils, sysutils;

var s : string;

arr : unixtools.dynar;
arr2  : strings;

procedure showhelp;
begin
writeln ('ept-get tool for gentoo like systems version [25/11/2006] 1.6 ');
writeln ('resembles apt-get interface');
writeln ('author: Norayr Chilingaryan');
writeln;
writeln ('usage');
writeln ('ept-get update');
writeln ('ept-get install <package>');
writeln ('ept-get remove <package>');
writeln ('flags: --download-only or -d');
writeln;
writeln ('tool createed mostly because there are no recoursive remove tool for gentoo linux');
writeln ('thanks for usage');
writeln;
halt;
end;

procedure leaveonlypackagenames(var a : unixtools.dynar);
var i,k,m,n : integer;
s : string;
begin
i := 0;
repeat
s := a[i];
m := strutils.NPos ('/', s, 1);
k := length (a[i]);
n := strutils.RPosEx ('-',s,k);
   if {(s[n-1] in ['A'..'z']) and} (s[n+1] in ['0'..'9']) THEN begin {if something like media-libs/openal-20050504-r1 }
                            a[i] := copy (s, m+1, n-m-1); 
			    end
			   else
			    begin
			    k := n-1;
			    n := strutils.RPosEx ('-',s,k);
			    a[i] := copy (s, m+1, n-m-1);
			    end;
inc(i);
until i = length (a);



end {leaveonlypackagename};

procedure debug (a : unixtools.dynar);
var i : integer;
begin
writeln ('debugging');
for i := 0 to high(a) do begin writeln (a[i]); end;
end;

PROCEDURE findwhodependonpackage ( s : unixtools.dynar);
VAR a: unixtools.dynar;
i : INTEGER;
str : STRING;
BEGIN
i := 0;
   REPEAT
   IF unixtools.addtoarray(arr, s[i]) THEN BEGIN
                 str := 'epkg depends ' + s[i];
                 //WriteLn ('running "' + str +'"');
                 a := unixtools.getprogramoutput (str);
                 //debug (a);
	                                                IF a[0] <> '' THEN
	                                                BEGIN
                                                        leaveonlypackagenames(a);
	                                                //debug (a);
	                                                findwhodependonpackage(a);
	                                                END;
                 END;							
INC(i);
UNTIL i=LENGTH(s);
			    
END {findwhodependonpackage} ;
{
FUNCTION GetPackageSize (VAR sss : STRING) : INTEGER;
VAR a : unixtools.dynar;
ss : STRING;
t : INTEGER;
BEGIN WriteLn (sss); WriteLn ('aaa');
ss := 'epm -qi ' + sss + ' 2>&1';
a := unixtools.GetProgramOutput (ss); WriteLn ('a[5]',a[5]);
ss := (StrUtils.ExtractWord (3, a[5], [' '])); WriteLn (ss);
t := StrToInt (ss);
GetPackageSize := Round (t/1024); 
END;
}

FUNCTION IsINStalled ( a : STRING) : BOOLEAN;
VAR o : unixtools.dynar;
i : INTEGER;
BEGIN
IsINstalled := FALSE;
//writeln ('running epkg -l | grep ',a);
o := unixtools.getprogramoutput ('epkg -l | grep ' + a); //debug(o);
i := 0;
REPEAT
//writeln ('o[',i,']=',o[i]);
//writeln ('a=',a);
IF Copy (o[i],1,LENGTH(a)) = a THEN BEGIN 
					IsINstalled := TRUE;
					 exit;
					  END;
INC(i);
UNTIL i = LENGTH(o);
END;

PROCEDURE remove (ss : unixtools.dynar);
var a: unixtools.dynar;
i : INTEGER;
b : BOOLEAN;
h : CHAR;
BEGIN
Write ('Reading Package Lists... ');
FOR i := 0 TO HIGH(ss) DO BEGIN
b := IsINstalled (ss[i]);
IF b = FALSE THEN BEGIN WriteLn ('E: Couldn'+#39+'t find package ' + ss[i]); halt; END;
END{IF};
WriteLn ('Done');

a := ss;
SETLENGTH(arr,1);
arr[0] := '';
Write ('Building Dependency Tree... ');
findwhodependonpackage (a); WriteLn ('Done');
{if LENGTH(arr) = 1 then begin
                           writeln ('no other package depend on ', ss);
			   
			   //shell ('emerge -C ' + ss);
			   halt;
                            end
			   else}
			    begin
			    WriteLn ('The following packages will be REMOVED:');
			    FOR i := 0 TO HIGH (arr) DO BEGIN 
			       Write (arr[i], ' ');
			     END;
			      WriteLn;
			    Write ('Do you want to continue? [Y/n] ');
			    ReadLn (h);
			    IF UPCASE(h)<>'Y' THEN halt; 
			    FOR i := 0 TO HIGH (arr ) DO BEGIN Shell ('emerge --unmerge ' + arr[i]); END;                
			    end;



END {remove};

PROCEDURE install ( str : string);
VAR downloadonly : BOOLEAN;
sh : STRING;
BEGIN
IF args.IsThere('--download-only') OR args.IsThere('-d') THEN downloadonly := TRUE;

IF downloadonly = TRUE THEN BEGIN
                          sh := 'emerge -f -K ' + str;
			  END
			 ELSE
			  BEGIN
			  sh := 'emerge  -K ' + str;
			  END;


Shell (sh);

END {install};


PROCEDURE source ( str : STRING);
VAR downloadonly : BOOLEAN;
sh : STRING;
BEGIN
IF args.IsThere('--download-only') OR args.IsThere('-d') THEN downloadonly := TRUE;

IF downloadonly = TRUE THEN BEGIN
                          sh := 'emerge -f ' + str;
			  END
			 ELSE
			  BEGIN
			  sh := 'emerge  ' + str;
			  END;
Shell (sh);
END {source};

PROCEDURE update;
BEGIN
Shell ('emerge --sync');

END;


begin

if not args.isthereargs then showhelp;
IF args.IsThere ('-h') THEN BEGIN showhelp; halt; END;
IF args.IsThere ('--help') THEN BEGIN showhelp; halt; END;
IF args.IsThere ('update') THEN BEGIN update; halt; END;

s := args.paramvalue('remove');
if s <> args.NotFound then BEGIN  arr2 :=args.GetParams(2,args.argscount); 
				  remove(arr2); 
				  SetLength(arr2,0);
				  halt; 
				 END;
 s := args.paramvalue ('install');  
 if s <> args.NotFound then BEGIN install(s); halt; END;
 s := args.paramvalue ('source');  
 if s <> args.NotFound then BEGIN source(s); halt; END;
showhelp
end.
