@echo Asemblacja, kompilacja i linkowanie programu 64-bitowego
cl -c %2.c
if errorlevel 1 goto koniec
ml64 -c -Cp -Fl %1.asm
if errorlevel 1 goto koniec
link -subsystem:console -out:%2.exe %1.obj %2.obj user32.lib
:koniec