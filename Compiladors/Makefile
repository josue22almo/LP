all: parser scan gcc  

parser: *.g 
	/opt/pccts/bin/antlr -gt *.g
scan: 
	/opt/pccts/bin/dlg -ci *.dlg scan.c
gcc: 
	g++ -Wno-write-strings -o program *.c -I/home/soft/PCCTS_v1.33/include/
pruebas:
	./program < pruebas.txt > result_pruebas.txt
	cat result_pruebas.txt
bol_pruebas:
	./program < bol_pruebas.txt > bol_result.txt
final:
	./program < inp.txt > result_final.txt	
clean:
	rm -f *.c *.h *.dlg program result_pruebas.txt result_final.txt bol_result.txt
