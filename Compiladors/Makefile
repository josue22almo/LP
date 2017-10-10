all: parser scan gcc  

parser: *.g 
	antlr -gt *.g
scan: 
	dlg -ci *.dlg scan.c
gcc: 
	g++ -Wno-write-strings -o program *.c -I/usr/include/pccts/
pruebas:
	./program < pruebas.txt > result_pruebas.txt
	cat result_pruebas.txt
bol_pruebas:
	./program < bol_pruebas.txt > bol_result.txt
final:
	./program < inp.txt > result_final.txt	
clean:
	rm -f *.c *.h *.dlg program result_pruebas.txt result_final.txt bol_result.txt
