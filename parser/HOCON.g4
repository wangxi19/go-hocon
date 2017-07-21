
/** Taken from "The Definitive ANTLR 4 Reference" by Terence Parr */

// Derived from http://json.org
grammar HOCON;


COMMENT
   : '#' ~( '\r' | '\n' )* -> skip
   ;

NUMBER
   : '-'? INT '.' [0-9] + EXP? | '-'? INT EXP | '-'? INT
   ;

STRING
   : '"' (ESC | ~ ["\\])* '"'
   | '\'' (ESC | ~ ['\\])* '\''
   ;

PATHELEMENT
   : (ALPHANUM|'-')+
   ;

REFERENCE
   : '${' PATHELEMENT ('.' PATHELEMENT)* '}'
   ;

KV : [=:]
   ;

WS
   : [ \t\n\r] + -> skip
   ;

fragment ESC
   : '\\' (["\\/bfnrt] | UNICODE)
   ;


fragment UNICODE
   : 'u' HEX HEX HEX HEX
   ;

fragment ALPHANUM
   : ('0' .. '9') | ('a'..'z') | ('A' .. 'Z')
   ;

fragment HEX
   : [0-9a-fA-F]
   ;

fragment INT
   : '0' | [1-9] [0-9]*
   ;

// no leading zeros

fragment EXP
   : [Ee] [+\-]? INT
   ;

// \- since - means "range" inside [...]

//======================================================================================

path
   : PATHELEMENT ('.' PATHELEMENT)*
   ;

key
   : path
   | STRING
   ;

hocon
   : value*
   | property*
   ;

obj
   : object_begin property (','? property)* object_end
   | object_begin object_end
   ;

property
   : object_data
   | array_data
   | string_data
   | reference_data
   | number_data
   ;

rawstring
   : (PATHELEMENT|'-')+
   ;

string_value
   : STRING
   | rawstring
   ;

// object data

object_begin
   : '{'
   ;

object_end
   : '}'
   ;

object_data
   : key KV? obj
   ;

array_data
   : key KV array
   ;

string_data
   : key KV string_value
   ;

reference_data
   : key KV REFERENCE
   ;

number_data
   : key KV NUMBER
   ;

// array data

array_begin
   : '['
   ;

array_end
   : ']'
   ;

array
   : array_begin value (','? value)* array_end
   | array_begin array_end
   ;


value
   : STRING
   | REFERENCE
   | NUMBER
   | obj
   | array
   ;