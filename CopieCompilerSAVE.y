%{
	#include <stdio.h>
	#include <stdlib.h>	
	#include <string.h>
	int yylex(void);
	int yyerror(char *);
	#include "table.c"
	int portee = 1;
	#define lignemax 20
	#define colonnemax 4
	char* tab_asm[lignemax][colonnemax];
	int indice = 0;
	char val[20];
%}

%union{
	int nb;
	char* str;
}

%token IF WHILE ELSE PRINTF MAIN OA CA CONST INT NOM PLUS MOINS MUL DIV EGALE OP CP LIGN PV QUOTE INT_PRINTF STRING_PRINTF FLOAT_PRINTF VIR NB STR INF SUP
%left PLUS MOINS
%left MUL DIV

%type <str>	INT NOM MAIN
%type <nb>	NB

%%


main: INT MAIN OP CP body 					{pile_push($2,$1,portee); pile_print(); printf("\n");} ;

body_main :	instruction body_main
			|/*empty*/

instruction :	declaration					
			|affectation
			|printf
			|ifElse
			|while
 
declaration : INT NOM PV							{ pile_push($2,$1,portee); pile_print(); printf("\n");}
			| INT NOM VIR decSuite  				{ pile_push($2,$1,portee); pile_print(); printf("\n");}
			| INT NOM EGALE expression PV			{ pile_pop();
													pile_push($2,$1,portee); 
													pile_print(); printf("\n"); 
													tab_asm[indice][0] = "LOAD";
													tab_asm[indice][1] = "r0"; 
													sprintf(val,"%ld",pile_last()); 
													tab_asm[indice][2] = val; 
													indice++; tab_asm[indice][0] = "STORE" ; 
													sprintf(val,"%ld",pile_last()); 
													tab_asm[indice][1] = val;  
													tab_asm[indice][2] = "r0 ";}
			;

decSuite : NOM VIR decSuite {pile_push($1,"int",portee); pile_print(); printf("\n");}
		| NOM PV 			{pile_push($1,"int",portee); pile_print(); printf("\n");} 
		;

affectation : NOM EGALE expression PV  				{tab_asm[indice][0] = "LOAD"; 
													tab_asm[indice][1] = "r0";
													sprintf(val,"%ld",pile_last());
													tab_asm[indice][2] = val;
													indice++;
													pile_pop();
													




printf("LOAD r0 %ld \n", pile_last()); pile_pop(); printf("STORE %ld r0\n", get_addr($1)); } ;

expression  : expression PLUS expression  	{printf("LOAD r0 %ld \n",pile_last()); pile_pop(); printf("LOAD r1 %ld \n",pile_last()); printf("ADD r0 r0 r1 \n"); printf("STORE %ld r0 \n",pile_last()); };		
			| expression MOINS expression  	{printf("LOAD r0 %ld \n",pile_last()); pile_pop(); printf("LOAD r1 %ld \n",pile_last()); printf("SOU r0 r0 r1 \n"); printf("STORE %ld r0 \n",pile_last()); };
			| expression MUL expression  	{printf("LOAD r0 %ld \n",pile_last()); pile_pop(); printf("LOAD r1 %ld \n",pile_last()); printf("MUL r0 r0 r1 \n"); printf("STORE %ld r0 \n",pile_last()); };		
			| expression DIV expression  	{printf("LOAD r0 %ld \n",pile_last()); pile_pop(); printf("LOAD r1 %ld \n",pile_last()); printf("DIV r0 r0 r1 \n"); printf("STORE %ld r0 \n",pile_last()); };		
			| NOM					{pile_push("tmp","string",portee); pile_print(); printf("\n"); printf("LOAD r0 %ld \n",get_addr($1)); printf("STORE %ld r0 \n",pile_last());};
			| NB					{pile_push("tmp","int",portee); pile_print(); printf("\n"); printf("AFC r0 %d \n", $1); printf("STORE %ld r0 \n",pile_last());}
			| OP expression CP
			;


printf: PRINTF OP body_printf CP PV	  {printf("printf \n");} ;

body_printf	: QUOTE STR QUOTE				
			| QUOTE INT_PRINTF QUOTE VIR NB
			| NOM 
			;

body : OA body_main CA;

ifElse : IF OP test CP { portee++; } body  { pop_portee(portee); portee--; } ifElseNext ;
ifElseNext :
	|  ELSE { portee++; }  body { pop_portee(portee); portee--; } {printf("if + else \n"); } ;


test	: NOM    	{printf("test \n");} ;
		| NB		{printf("test \n");} ;
		| NOM comparateur NB		{printf("test \n");} ;
		| NOM comparateur NOM		{printf("test \n");} ;

comparateur : EGALE EGALE			
			| SUP
			| INF
			| SUP EGALE
			| INF EGALE

while	: WHILE OP test CP {portee++;} body { pop_portee(portee); portee--; } {printf("while \n");} ;



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

	for(int i =0; i<5; i++)
	{
		for(int j=0; j<4;j++){
			if(tab_asm[i][j] != NULL)	
			printf("%s \t",tab_asm[i][j]);		
		}
		printf("\n");
	}
	printf("\n");
}
