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

NUM = [0-9]+ ("." [0-9]+)?
NL  = \n | \r | \r\n
STR = \"[^\"]*\"
IMPRIMA = "imprima"
CREE = "cree"
COMPARE = "compare"
TIPO = "String" | "int" | "double" | "char"
IDEN = [a-zA-Z_][a-zA-Z0-9_]*
SIZE = [1-9][0-9]*

%%

/* operators */

"+" |
"-" |
"*" |
"/" |
"^" |
"(" |
")"    { return (int) yycharat(0); }

/*Otras palabras*/
"con"  { return Parser.CON;}

"arreglo" { return Parser.ARRAY;}
"metodo"  { return Parser.METHOD;}
"variable" { return Parser.LVAR;}


/* newline */
{NL}   { return Parser.NL; }

/* Acciones */
{IMPRIMA} {return Parser.Imprima;}

{CREE}  {return Parser.Cree;}

{COMPARE} {return Parser.Compare;}

/* Variables */
{TIPO}  { yyparser.yylval = new ParserVal(yytext()); return Parser.TIPO; }

{IDEN}  { yyparser.yylval = new ParserVal(yytext()); return Parser.IDEN; }

{SIZE}  { yyparser.yylval = new ParserVal(Integer.parseInt(yytext())); return Parser.SIZE;}

/* Strings */
{STR}   { yyparser.yylval = new ParserVal(yytext()); return Parser.STR; }

/* float */

//{NUM}  { yyparser.yylval = new ParserVal(Double.parseDouble(yytext()));
         //return Parser.NUM; }


/* whitespace */
[ \t]+ { }

\b     { System.err.println("Sorry, backspace doesn't work"); }

/* error fallback */
[^]    { System.err.println("Error: unexpected character '"+yytext()+"'"); return -1; }
