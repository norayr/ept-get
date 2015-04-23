Unit args;

interface

Uses StrUtils;
TYPE strings = ARRAY OF STRING;
CONST NotFound = 'Not found';

FUNCTION ArgsCount () : BYTE;
FUNCTION IsThereArgs() : BOOLEAN;
FUNCTION MainModule() : STRING;
FUNCTION ParamValue (key : STRING) : STRING;
FUNCTION GetFileWithExtention (key : STRING) : STRING;
FUNCTION IsThere ( s : STRING) : BOOLEAN;
FUNCTION GetParams (i,j : INTEGER) : strings;

implementation

FUNCTION ArgsCount () : BYTE;
BEGIN

ArgsCount := ParamCount;

END {GetArgsCount};

FUNCTION IsThereArgs() : BOOLEAN;
BEGIN
IsThereArgs := FALSE;
IF ParamCount > 0 THEN IsThereArgs := TRUE {ENDIF};
END {IsThereArgs};

FUNCTION ParamValue (key : STRING) : STRING;
VAR i : INTEGER;
BEGIN
FOR i := 1 TO (ParamCount-1) DO
   BEGIN
   IF ParamStr(i) = key THEN 
                         BEGIN
			 ParamValue := ParamStr(i+1);
			 exit;
			 END {IF};

   END {FOR};
   ParamValue := args.NotFound;
END {ParamValue};


FUNCTION IsThere ( s : STRING) : BOOLEAN;
VAR i : INTEGER;
BEGIN
IsThere := FALSE;
FOR i := 1 TO ParamCount Do
   BEGIN
   IF ParamStr(i) = s THEN BEGIN IsThere := TRUE; exit; END;
   
   END;

END;

FUNCTION MainModule() : STRING;

BEGIN

MainModule := ParamStr(1);


END {MainModule};


FUNCTION GetFileWithExtention (key : STRING) : STRING;
VAR i : INTEGER;
a : STRING;
BEGIN
FOR i := 1 to ParamCount DO
   BEGIN
   a := RightStr(ParamStr(i), 4 );
   IF a = '.' + key THEN
                                          BEGIN
			                   GetFileWithExtention :=  ParamStr(i);
					   exit;		  
					  END {IF};
   END {FOR};
GetFileWithExtention  := args.NotFound;
END {GetFileWithExtention};

FUNCTION GetParams (i,j : INTEGER) : strings;
VAR s : strings;
k : INTEGER;
BEGIN
k := j+1-i;
SetLength( s, k);
FOR k := 0 TO HIGH(s) DO
BEGIN
s[k] := ParamStr(i+k);
END;
GetParams := s;
END{GetParams};

BEGIN





END {args}.
