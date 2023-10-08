@echo Asemblacja, kompilacja i linkowanie programu 32-bitowego
cl -c %2.c
if errorlevel 1 goto koniec
ml -c -Cp -coff -Fl %1.asm
if errorlevel 1 goto koniec
link -subsystem:console -out:%2.exe %1.obj %2.obj
:koniec