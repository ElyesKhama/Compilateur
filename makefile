all: compiler

lex.yy.c: compiler.l
	./flex compiler.l

compiler.tab.c: compiler.y
	bison -d -v compiler.y

compiler: compiler.tab.c lex.yy.c
	gcc -g -o compiler lex.yy.c compiler.tab.c libfl.a /usr/share/bison/liby.a

test: compiler 
	./compiler < test.c
