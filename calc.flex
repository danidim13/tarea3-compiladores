/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright (C) 2000 Gerwin Klein <lsf@jflex.de>                          *
 * All rights reserved.                                                    *
 *                                                                         *
 * Thanks to Larry Bell and Bob Jamison for suggestions and comments.      *
 *                                                                         *
 * License: BSD                                                            *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

%%

%byaccj

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

DOUBLE = "-"?[0-9]+ "." ([0-9]+)?
NL  = \n | \r | \r\n
STR = \"[^\"]*\"
IMPORTE = "importe"
IMPRIMA = "imprima"
CREE = "cree"
DECLARE = "declare"
COMPARE = "compare"
ASIGNE = "asigne"
TIPO = "String" | "int" | "double" | "char"
IDEN = [a-zA-Z_][a-zA-Z0-9_]*
SIZE = "-"?[1-9][0-9]*

%%

/* operators */

"." |
"a" |
"*"   { return yycharat(0);}

"+" |
"-" |
"*" |
"/" |
"^" |
"(" |
")"    { return (int) yycharat(0); }

/*Otras palabras reservadas*/
"con"  { return Parser.CON;}

"arreglo" { return Parser.ARRAY;}
"metodo"  { return Parser.METHOD;}
"variable" { return Parser.LVAR;}
"tipo"    { return Parser.LTYPE;}
"valor"     { return Parser.LVALUE;}
"for"       { return Parser.FOR;}
"desde"     { return Parser.LFROM;}
"hasta"     { return Parser.LTO;}


/* newline */
{NL}   { return Parser.NL; }

/* Acciones */
{IMPORTE} {return Parser.Importe;}
{IMPRIMA} {return Parser.Imprima;}

{CREE}  {return Parser.Cree;}
{DECLARE} {return Parser.Declare;}

{COMPARE} {return Parser.Compare;}
{ASIGNE}  {return Parser.Asigne;}

/* Variables */
{TIPO}  { yyparser.yylval = new ParserVal(yytext()); return Parser.TIPO; }

{IDEN}  { yyparser.yylval = new ParserVal(yytext()); return Parser.IDEN; }

{SIZE}  { yyparser.yylval = new ParserVal(Integer.parseInt(yytext())); return Parser.SIZE;}

/* Strings */
{STR}   { yyparser.yylval = new ParserVal(yytext()); return Parser.STR; }

/* float */

{DOUBLE}  { yyparser.yylval = new ParserVal(Double.parseDouble(yytext())); return Parser.DOUBLE;}


/* whitespace */
[ \t]+ { }

\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]    { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }
