prog : testing.l testing.y lex.yy.c syntax_tree.c testing.tab.c
	bison -d testing.y
	flex testing.l
	gcc lex.yy.c syntax_tree.c testing.tab.c -o prog
