/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Copyright (C) 2001 Gerwin Klein <lsf@jflex.de>                          *
 * All rights reserved.                                                    *
 *                                                                         *
 * This is a modified version of the example from                          *
 *   http://www.lincom-asg.com/~rjamison/byacc/                            *
 *                                                                         *
 * Thanks to Larry Bell and Bob Jamison for suggestions and comments.      *
 *                                                                         *
 * License: BSD                                                            *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

%{
  import java.io.*;
%}

%token NL          /* newline  */
%token <dval> NUM  /* a number */
%token <sval> STR
%token <sval> TIPO
%token <sval> IDEN
%token <ival> SIZE

/* Acciones de un argumento*/
%token Imprima Cree

/* Acciones de dos argumentos */
%token Compare

/* Otras palabras reservadas */
%token CON ARRAY METHOD LVAR

%type <sval> exp action

%left '-' '+'
%left '*' '/'
%left NEG          /* negation--unary minus */
%right '^'         /* exponentiation        */

%%

input:   /* empty string */
       | input line
       ;

line:    NL      { if (interactive) System.out.print("Expression: "); }
       | exp NL  { System.out.println($1);
                   if (interactive) System.out.print("Expression: "); }
       ;

exp:    action          {$$ = $1;}
        ;

       /*| NUM                { $$ = $1; }
       | exp '+' exp        { $$ = $1 + $3; }
       | exp '-' exp        { $$ = $1 - $3; }
       | exp '*' exp        { $$ = $1 * $3; }
       | exp '/' exp        { $$ = $1 / $3; }
       | '-' exp  %prec NEG { $$ = -$2; }
       | exp '^' exp        { $$ = Math.pow($1, $3); }
       | '(' exp ')'        { $$ = $2; }*/
        ;
action:   Imprima STR     { $$ = String.format("System.out.println(%s)", $2);}
        | Cree METHOD IDEN       { $$ = String.format("void %s(){}", $3);}
        | Cree ARRAY IDEN SIZE TIPO { $$ = String.format("%s %s[] = new %s[%d];", $5, $3, $5, $4);}
        | Compare IDEN CON IDEN {$$ = String.format("if (%s == %s) {}", $2, $4);}
        ;

%%

  private Yylex lexer;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal("");
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }


  static boolean interactive;

  public static void main(String args[]) throws IOException {
    System.out.println("BYACC/Java with JFlex Calculator Demo");

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {
      // interactive mode
      System.out.println("[Quit with CTRL-D]");
      System.out.print("Expression: ");
      interactive = true;
	    yyparser = new Parser(new InputStreamReader(System.in));
    }

    yyparser.yyparse();

    if (interactive) {
      System.out.println();
      System.out.println("Have a nice day");
    }
  }
