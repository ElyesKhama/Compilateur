%{
	#include <stdio.h>
	#include <stdlib.h>	
	#include <string.h>
	int yylex(void);
	int yyerror(char *);
	#include "table.c"
	int portee = 1;
	#define lignemax 150
 


	struct {
		char *o;
		int a;
		int b;
		int c;
	} tab_asm[lignemax];

	int indice = 0;
%}

%union{
	int nb;
	char* str; 
}

%token IF WHILE ELSE PRINTF MAIN OA CA CONST INT NOM PLUS MOINS MUL DIV EGALE OP CP LIGN PV QUOTE INT_PRINTF STRING_PRINTF FLOAT_PRINTF VIR NB STR INF SUP VOID RETURN
%left PLUS MOINS
%left MUL DIV

%left EGALE SUP INF

%type <str>	INT NOM MAIN VOID
%type <nb>	NB

%nonassoc IFREDUCE
%nonassoc ELSE

%%



main: INT MAIN OP CP body 					{pile_push($2,$1,portee); pile_print(); printf("\n");} ;

body_main :	instruction body_main
			|/*empty*/

instruction :declaration					
			|affectation
			|printf
			|ifElse
			|while
 
declaration : INT NOM PV							{ pile_push($2,$1,portee); pile_print(); printf("\n");}
			| INT NOM VIR decSuite  				{ pile_push($2,$1,portee); pile_print(); printf("\n");}
			| INT NOM EGALE expression PV			 {pile_print();}
			;

decSuite : NOM VIR decSuite {pile_push($1,"int",portee); pile_print(); printf("\n");}
		| NOM PV 			{pile_push($1,"int",portee); pile_print(); printf("\n");} 
		;

affectation : NOM EGALE expression PV  				

expression  : expression PLUS expression  	{tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = pile_last();
											tab_asm[indice].c = -1; 
											indice++;
											pile_pop();
											tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 1;
											tab_asm[indice].b = pile_last();
											tab_asm[indice].c = -1; 
											indice++;
											tab_asm[indice].o = "ADD";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = 0;
											tab_asm[indice].c = 1;
											indice++;
											tab_asm[indice].o = "STORE";
											tab_asm[indice].a = pile_last();
											tab_asm[indice].b = 0;
											tab_asm[indice].c = -1;
											indice++;};	
			| expression MOINS expression  	{tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = pile_last();
											tab_asm[indice].c = -1; 
											indice++;
											pile_pop();
											tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 1;
											tab_asm[indice].b = pile_last();
											tab_asm[indice].c = -1; 
											indice++;
											tab_asm[indice].o = "SOU";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = 0;
											tab_asm[indice].c = 1;
											indice++;
											tab_asm[indice].o = "STORE";	
											tab_asm[indice].a = pile_last();
											tab_asm[indice].b = 0;
											tab_asm[indice].c = -1; 
											indice++; };
			| expression MUL expression  	{tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = pile_last();
											tab_asm[indice].c = -1; 
											indice++;
											pile_pop();
											tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 1;
											tab_asm[indice].b = pile_last();
											tab_asm[indice].c = -1; 
											indice++;
											tab_asm[indice].o = "MUL";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = 0;
											tab_asm[indice].c = 1;
											indice++;
											tab_asm[indice].o = "STORE";
											tab_asm[indice].a = pile_last();
											tab_asm[indice].b = 0;
											tab_asm[indice].c = -1; 											
											indice++; };		
			| expression DIV expression  	{tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = pile_last();
											indice++;
											tab_asm[indice].c = -1; 
											pile_pop();
											tab_asm[indice].o = "LOAD";
											tab_asm[indice].a = 1;
											tab_asm[indice].b = pile_last();
											tab_asm[indice].c = -1; 
											indice++;
											tab_asm[indice].o = "DIV";
											tab_asm[indice].a = 0;
											tab_asm[indice].b = 0;
											tab_asm[indice].c = 1;
											indice++;
											tab_asm[indice].o = "STORE";;
											tab_asm[indice].a = pile_last();
											tab_asm[indice].b = 0;	
											tab_asm[indice].c = -1; 									
											indice++; };		
			| NOM					{pile_push("tmp","string",portee);
									pile_print(); printf("\n"); 
									tab_asm[indice].o = "LOAD";
									tab_asm[indice].a = 0;
									tab_asm[indice].b = get_addr($1);
									tab_asm[indice].c = -1; 
									indice++;
									tab_asm[indice].o = "STORE";
									tab_asm[indice].a = pile_last();
									tab_asm[indice].b = 0;
									tab_asm[indice].c = -1; 
									indice++;};
			| NB					{pile_push("tmp","int",portee); 
									pile_print(); printf("\n"); 
									tab_asm[indice].o = "AFC";
									tab_asm[indice].a = 0;
									tab_asm[indice].b = $1;
									tab_asm[indice].c = -1; 
									indice++;
									tab_asm[indice].o = "STORE";
									tab_asm[indice].a = pile_last();
									tab_asm[indice].b = 0;
									tab_asm[indice].c = -1; 
									indice++;}
			| OP expression CP
			;


printf: PRINTF OP body_printf CP PV	  {printf("printf \n");} ;

body_printf	: QUOTE STR QUOTE				
			| QUOTE INT_PRINTF QUOTE VIR NB
			| NOM 
			;

body : OA { portee++; } body_main CA { pop_portee(portee); portee--; } ;

ifAction :
	{	tab_asm[indice].o="LOAD";
		tab_asm[indice].a = 0;
		tab_asm[indice].b = pile_last();
		tab_asm[indice].c= -1;
		indice++;
		pile_pop();
		tab_asm[indice].o = "JMPC";
		tab_asm[indice].a = -2;
		tab_asm[indice].b = 0;
		tab_asm[indice].c = -1;
		indice++;
		$<nb>$=indice-1;
	} ;

ifElse :IF OP test CP ifAction body
			{	tab_asm[$<nb>5].a= indice;
				printf("if");
			}
			%prec IFREDUCE	
		| IF OP test CP ifAction body ELSE
			{	tab_asm[$<nb>5].a= indice+1;
				tab_asm[indice].o = "JMP";
				tab_asm[indice].a = -2;
				tab_asm[indice].b = -1;
				tab_asm[indice].c = -1;
				indice++;
				$<nb>2=indice-1;
			}
			body {tab_asm[$<nb>2].a = indice; printf("if + else \n"); } ;

test	: NOM 					 	{pile_push("tmp","string",portee);
									pile_print(); printf("\n"); 
									tab_asm[indice].o = "LOAD";
									tab_asm[indice].a = 0;
									tab_asm[indice].b = get_addr($1);
									tab_asm[indice].c = -1; 
									indice++;;
									tab_asm[indice].o = "STORE";
									tab_asm[indice].a = pile_last();
									tab_asm[indice].b = 0;
									tab_asm[indice].c = -1; 
									indice++;} ;  
			| NB					{pile_push("tmp","int",portee); 
									pile_print(); printf("\n"); 
									tab_asm[indice].o = "AFC";
									tab_asm[indice].a = 0;
									tab_asm[indice].b = $1;
									tab_asm[indice].c = -1; 
									indice++;
									tab_asm[indice].o = "STORE";
									tab_asm[indice].a = pile_last();
									tab_asm[indice].b = 0;
									tab_asm[indice].c = -1; 
									indice++;} ;
		| test EGALE EGALE test			{tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 0;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 1;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;					
										tab_asm[indice].o="EQU";
										tab_asm[indice].a = 4;
										tab_asm[indice].b = 0;
										tab_asm[indice].c= 1;
										indice++;
										pile_push("tmp","int",portee); 
										pile_print(); printf("\n");}
		| test SUP test					{tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 0;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();
										tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 1;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();						
										tab_asm[indice].o="SUP";
										tab_asm[indice].a = 4;
										tab_asm[indice].b = 0;
										tab_asm[indice].c= 1;
										indice++;
										pile_push("tmp","int",portee); 
										pile_print(); printf("\n");}
		| test INF test					{tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 0;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();
										tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 1;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();						
										tab_asm[indice].o="INF";
										tab_asm[indice].a = 4;
										tab_asm[indice].b = 0;
										tab_asm[indice].c= 1;
										indice++;
										pile_push("tmp","int",portee); 
										pile_print(); printf("\n");}
		| test SUP EGALE test			{tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 0;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();
										tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 1;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();						
										tab_asm[indice].o="SUPE";
										tab_asm[indice].a = 4;
										tab_asm[indice].b = 0;
										tab_asm[indice].c= 1;
										indice++;}
		| test INF EGALE test			{tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 0;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();
										tab_asm[indice].o="LOAD";
										tab_asm[indice].a = 1;
										tab_asm[indice].b = pile_last();
										tab_asm[indice].c= -1;
										indice++;
										pile_pop();						
										tab_asm[indice].o="INFE";
										tab_asm[indice].a = 4;
										tab_asm[indice].b = 0;
										tab_asm[indice].c= 1;
										indice++;
										pile_push("tmp","int",portee); 
										pile_print(); printf("\n");}
		;

while	: 	WHILE	{$<nb>1=indice;}
			OP test CP {tab_asm[indice].o="LOAD";
						tab_asm[indice].a = 0;
						tab_asm[indice].b = pile_last();
						tab_asm[indice].c= -1;
						indice++;
						pile_pop();
						tab_asm[indice].o = "JMPC";
						tab_asm[indice].a = -2;
						tab_asm[indice].b = 0;
						tab_asm[indice].c = -1;
						indice++;
						$<nb>2=indice-1;}
			body		{
						tab_asm[indice].o = "JMP";
						tab_asm[indice].a = $<nb>1;
						tab_asm[indice].b = -1;
						tab_asm[indice].c = -1;
						indice++;		
						printf("while \n");
						tab_asm[$<nb>2].a= indice;} ; // ACTUALISE LE JMPC
 
%%

int main() {
	
	//FILE* fichier = NULL;
	yyparse();
	/*fichier = fopen("./asm.txt","w");
	if (fichier != NULL){
		fprintf(fichier,"test");
		//printf("<<<<<");
	fclose(fichier);
	}*/


	for(int i=0; i<150; i++)
	{
		if(tab_asm[i].o != NULL){
		printf("%d\t%s\t%d\t",i,tab_asm[i].o,tab_asm[i].a);
		if(tab_asm[i].b != -1){
		printf("%d\t",tab_asm[i].b);		
		}
		if(tab_asm[i].c != -1){
		printf("%d",tab_asm[i].c);		
		}
		else
		{
		printf("-");
		}
		printf("\n");
		}
	}
	printf("\n");
}
