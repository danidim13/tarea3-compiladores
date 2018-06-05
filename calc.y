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
%token <dval> DOUBLE  /* a number */
%token <sval> STR
%token <sval> TIPO
%token <sval> IDEN
%token <sval> PACK
%token <ival> SIZE

/* Acciones que modifican el codigo*/
%token Importe Imprima Cree Compare Declare Asigne

/* Otras palabras reservadas */
%token CON ARRAY METHOD LVAR LTYPE LVALUE FOR LFROM LTO

%type <sval> exp action pack const

%left '-' '+' '.' 'a'
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
action:   Importe pack { $$ = String.format("import %s;", $2);}
        | Imprima STR     { $$ = String.format("System.out.println(%s)", $2);}
        | Cree METHOD IDEN       { $$ = String.format("void %s(){}", $3);}
        | Cree ARRAY IDEN SIZE LTYPE TIPO { $$ = String.format("%s %s[] = new %s[%d];", $6, $3, $6, $4);}
        | Cree FOR LFROM SIZE LTO SIZE {$$ = String.format("for (int i = %d; i < %d; i++){}", $4, $6);}
        | Compare IDEN CON IDEN {$$ = String.format("if (%s == %s) {}", $2, $4);}
        | Declare LVAR IDEN LTYPE TIPO {$$ = String.format("%s %s;", $5, $3);}
        | Asigne LVALUE const 'a' IDEN {$$ = String.format("%s = %s;", $5, $3);}
        ;

pack:     IDEN '.' pack  { $$ = String.format("%s.%s", $1, $3);}
        | IDEN '.' '*'   { $$ = String.format("%s.*", $1);}
        | IDEN           { $$ = $1;}
        ;

const:    STR       {$$ = $1;}
        | SIZE      {$$ = Integer.toString($1);}
        | DOUBLE    {$$ = Double.toString($1);}
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
