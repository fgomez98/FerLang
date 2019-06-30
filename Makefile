LEX=scan.l
YACC=syntax.y
COMPILER=FerLang

.PHONY: clean

clean:
	rm -rf $(COMPILER) lex.yy.c y.tab.c y.tab.h
	rm -rf Ejemplos/redefinition.c  Ejemplos/inexistentVar.c  Ejemplos/wrongTypes.c
	rm -rf Ejemplos/factorial.c  Ejemplos/echo.c Ejemplos/pyramid.c Ejemplos/digitCount.c Ejemplos/primeNumbers.c Ejemplos/multiply.c
	rm -rf  Ejemplos/factorial  Ejemplos/echo Ejemplos/pyramid Ejemplos/digitCount Ejemplos/primeNumbers Ejemplos/multiply

all:
	yacc -d $(YACC)
	lex $(LEX)
	gcc -o $(COMPILER) lex.yy.c y.tab.c hashmap.c -ly

redefinitionError:
	./$(COMPILER) < Ejemplos/redefinition.fer > Ejemplos/redefinition.c

inexistentVarError:
	./$(COMPILER) < Ejemplos/inexistentVar.fer > Ejemplos/inexistentVar.c

wrongTypesError:
	./$(COMPILER) < Ejemplos/wrongTypes.fer > Ejemplos/wrongTypes.c

examples:
	./$(COMPILER) < Ejemplos/factorial.fer > Ejemplos/factorial.c
	    # gcc -S Ejemplos/factorial.c -o Ejemplos/factorial.s
	    gcc Ejemplos/factorial.c -o Ejemplos/factorial

	./$(COMPILER) < Ejemplos/echo.fer > Ejemplos/echo.c
		# gcc -S Ejemplos/echo.c -o Ejemplos/echo.s
	    gcc Ejemplos/echo.c -o Ejemplos/echo

	./$(COMPILER) < Ejemplos/pyramid.fer > Ejemplos/pyramid.c
		# gcc -S Ejemplos/pyramid.c -o Ejemplos/pyramid.s
	    gcc Ejemplos/pyramid.c -o Ejemplos/pyramid

	./$(COMPILER) < Ejemplos/digitCount.fer > Ejemplos/digitCount.c
		# gcc -S Ejemplos/digitCount.c -o Ejemplos/digitCount.s
	    gcc Ejemplos/digitCount.c -o Ejemplos/digitCount

	./$(COMPILER) < Ejemplos/primeNumbers.fer > Ejemplos/primeNumbers.c
		# gcc -S Ejemplos/primeNumbers.c -o Ejemplos/primeNumbers.s
	    gcc Ejemplos/primeNumbers.c -o Ejemplos/primeNumbers

	./$(COMPILER) < Ejemplos/multiply.fer > Ejemplos/multiply.c
		# gcc -S Ejemplos/multiply.c -o Ejemplos/multiply.s
	    gcc Ejemplos/multiply.c -o Ejemplos/multiply

compileBenchmarks:
	./$(COMPILER) < benchmarks/primesFLang.fer > benchmarks/primesFLang.c
	    gcc benchmarks/primesFLang.c -o benchmarks/primesFLang
			gcc benchmarks/primesC.c -o benchmarks/primesC
