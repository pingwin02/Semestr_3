masm %1.asm,,,;
if errorlevel 1 goto koniec
link %1.obj;
if errorlevel 1 goto koniec
del *.lst
del *.crf
del *.obj
%1
:koniec