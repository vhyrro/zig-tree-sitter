treesitter:
	cd tree-sitter; \
	make libtree-sitter.a; \
	mv libtree-sitter.a ../tree-sitter.a;

json: # TODO: expand to support any parser (including ones with a scanner)
	cc -c -o parser.o -I tree-sitter-json/src tree-sitter-json/src/parser.c
