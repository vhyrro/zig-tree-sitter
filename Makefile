treesitter:
	cc -c -o tree-sitter.o -I tree-sitter/lib/src -I tree-sitter/lib/include tree-sitter/lib/src/lib.c

json: # TODO: expand to support any parser (including ones with a scanner)
	cc -c -o parser.o -I tree-sitter-json/src tree-sitter-json/src/parser.c
