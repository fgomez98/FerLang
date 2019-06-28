LEX=scan.l
YACC=syntax.y
COMPILER=PataSucia

.PHONY: clean	

clean: 	
	rm -rf $(COMPILER) lex.yy.c y.tab.c y.tab.h	

all: 
	yacc -d $(YACC)
	lex $(LEX)
	gcc -o $(COMPILER) lex.yy.c y.tab.c -ly

compileExamples:
	./$(COMPILER) < Ejemplos/factorial.pts > Ejemplos/factorial.c
	    # gcc -S Ejemplos/factorial.c -o Ejemplos/factorial.s
	    gcc Ejemplos/factorial.c -o Ejemplos/factorial

	./$(COMPILER) < Ejemplos/echo.pts > Ejemplos/echo.c
		# gcc -S Ejemplos/echo.c -o Ejemplos/echo.s
	    gcc Ejemplos/echo.c -o Ejemplos/echo

	./$(COMPILER) < Ejemplos/pyramid.pts > Ejemplos/pyramid.c
		# gcc -S Ejemplos/pyramid.c -o Ejemplos/pyramid.s
	    gcc Ejemplos/pyramid.c -o Ejemplos/pyramid

	./$(COMPILER) < Ejemplos/digitCount.pts > Ejemplos/digitCount.c
		# gcc -S Ejemplos/digitCount.c -o Ejemplos/digitCount.s
	    gcc Ejemplos/digitCount.c -o Ejemplos/digitCount

	./$(COMPILER) < Ejemplos/primeNumbers.pts > Ejemplos/primeNumbers.c
		# gcc -S Ejemplos/primeNumbers.c -o Ejemplos/primeNumbers.s
	    gcc Ejemplos/primeNumbers.c -o Ejemplos/primeNumbers

	./$(COMPILER) < Ejemplos/multiply.pts > Ejemplos/multiply.c
		# gcc -S Ejemplos/multiply.c -o Ejemplos/multiply.s
	    gcc Ejemplos/multiply.c -o Ejemplos/multiply



