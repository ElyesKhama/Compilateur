#include <stdlib.h>
#include <stdio.h>
#include <string.h>


typedef struct pile{
	long addr;
	char* type;
	char* nom;
	int portee;
	struct pile *precedent; 
} Pile ;

Pile *pile = NULL;
int nb_elements = 0;


void pile_push(char *nom, char* type, int portee)
{
       Pile *p_nouveau = malloc(sizeof(Pile));
       if (p_nouveau != NULL)
       {
            p_nouveau->nom = nom;
			p_nouveau->addr = nb_elements++;
			p_nouveau->type = type;			
			p_nouveau->portee = portee;
			p_nouveau->precedent = pile;
            pile = p_nouveau;
       }
}

int pile_pop()   
{
	int ret = 1;
	if (pile != NULL)
	{
	    Pile *temporaire = pile->precedent;
	    free(pile);
	    pile = temporaire;
		nb_elements--;
	}
	return ret;
}

long get_addr(char* nom)
 {
		Pile * current = pile;  // Initialize current
 		while (current != NULL)
    	{
		    if (!strcmp(current->nom, nom)){
				return current->addr;
			}
		    current = current->precedent;
    	}
	return -1;
}

void pop_portee(int nb) {
	Pile * current = pile;  // Initialize current
 	while (current != NULL)
    {
		if(current->portee >= nb){
			pile_pop();			
		}
	current = current->precedent;
	}   	
}

void pile_print(void) {
	Pile * current = pile;  // Initialize current
 	while (current != NULL)
    {
		printf("@%2ld nom: %4s type: %s portee: %d \n", current->addr, current->nom, current->type, current->portee);
		current = current->precedent;
    }
}

long pile_last(void){
	return pile->addr;
}

/*int main(){
	//printf("@v1: %d\n", get_addr("v1"));
	pile_push("v1", "char", 1);
	//printf("@v1: %d\n", get_addr("v1"));
	pile_push("v2", "char", 1);
	pile_push("v3", "char", 2);
	pile_push("v4", "char", 2);
	//printf("@v1: %d\n", get_addr("v1"));
	pile_push("v1", "char", 2);
	pile_push("v2", "char", 3);
	pile_push("v5", "char", 4);
	//printf("@v1: %d\n", get_addr("v1"));
	pile_print();
	printf("last value : %ld",pile_last());
	//printf("@v1: %d\n", get_addr("v1"));
	return 0;
}  */
