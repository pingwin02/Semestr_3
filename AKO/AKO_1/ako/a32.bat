@echo Asemblacja i linkowanie programu 32-bitowego
ml -c -Cp -coff -Fl %1.asm
if errorlevel 1 goto koniec
link -subsystem:console -out:%1.exe %1.obj libcmt.lib
:koniec