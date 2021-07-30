.PHONY: default

FILES_TO_DELETE = jsonValidator.tab.c jsonValidator.lex.c jsonValidator.output jsonValidatorV


default: jsonValidator_validator

jsonValidator_validator: jsonValidator.lex.c jsonValidator.tab.c jsonValidatorSymbolTable.c
	gcc -o jsonValidatorV jsonValidator.tab.c jsonValidatorSymbolTable.c -lfl

jsonValidator.lex.c: jsonValidator_lexer.l
	flex -s -ojsonValidator.lex.c jsonValidator_lexer.l

jsonValidator.tab.c : jsonValidator_parser.y
	bison -v -ojsonValidator.tab.c jsonValidator_parser.y

clean:
	 rm -f $(FILES_TO_DELETE)

clean-windows:
	cmd /c erase $(FILES_TO_DELETE)
