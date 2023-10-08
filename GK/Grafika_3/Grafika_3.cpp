/******************************************************************
 Grafika komputerowa, œrodowisko MS Windows - program  przyk³adowy
 *****************************************************************/

#include <windows.h>
#include <gdiplus.h>
using namespace Gdiplus;

POINT tab1[7], tab2[7], heart[13];

int chosen;
bool isChosen = false;

void czesc1(POINT* tab) {
	tab[0] = { 100, 100 };
	tab[1] = { 100, 500 };
	tab[2] = { 400, 500 };
	tab[3] = { 500, 400 };
	tab[4] = { 500, 200 };
	tab[5] = { 400, 100 };
	tab[6] = { 100, 100 };
}

void czesc2(POINT* tab) {
	tab[0] = { 200, 200 };
	tab[1] = { 200, 400 };
	tab[2] = { 350, 400 };
	tab[3] = { 400, 350 };
	tab[4] = { 400, 250 };
	tab[5] = { 350, 200 };
	tab[6] = { 200, 200 };
}

void samochod(POINT* car, POINT start) {

	car[0] = { 80 + start.x, 120 + start.y };
	car[1] = { 90 + start.x, 120 + start.y };
	car[2] = { 200 + start.x, 120 + start.y };
	car[3] = { 300 + start.x, 120 + start.y };
	car[4] = { 320 + start.x, 110 + start.y };
	car[5] = { 310 + start.x, 50 + start.y };
	car[6] = { 200 + start.x, 30 + start.y };
	car[7] = { 180 + start.x, 30 + start.y };
	car[8] = { 160 + start.x, 40 + start.y };
	car[9] = { 140 + start.x, 60 + start.y };
	car[10] = { 10 + start.x, 60 + start.y };
	car[11] = { 0 + start.x, 100 + start.y };
	car[12] = { 80 + start.x, 120 + start.y };
}

void serce(POINT* heart, POINT start) {
	heart[0] = { 40 + start.x, 100 + start.y };
	heart[1] = { 60 + start.x, 60 + start.y };
	heart[2] = { 80 + start.x, 60 + start.y };
	heart[3] = { 110 + start.x, 80 + start.y };
	heart[4] = { 140 + start.x, 60 + start.y };
	heart[5] = { 160 + start.x, 60 + start.y };
	heart[6] = { 180 + start.x, 100 + start.y };
	heart[7] = { 200 + start.x, 120 + start.y };
	heart[8] = { 120 + start.x, 160 + start.y };
	heart[9] = { 110 + start.x, 250 + start.y };
	heart[10] = { 100 + start.x, 160 + start.y };
	heart[11] = { 20 + start.x, 120 + start.y };
	heart[12] = { 40 + start.x, 100 + start.y };
}

void skaluj(POINT* tab, int n, int skala) {
	for (int i = 0; i < n; i++)
	{
		tab[i].x *= skala;
		tab[i].y *= skala;
	}
}

//deklaracja funkcji obslugi okna
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

//funkcja Main - dla Windows
 int WINAPI WinMain(HINSTANCE hInstance,
               HINSTANCE hPrevInstance,
               LPSTR     lpCmdLine,
               int       nCmdShow)
{
	MSG meldunek;		  //innymi slowy "komunikat"
	WNDCLASS nasza_klasa; //klasa g³ównego okna aplikacji
	HWND okno;
	static char nazwa_klasy[] = "Podstawowa";
	
	GdiplusStartupInput gdiplusParametry;// parametry GDI+; domyœlny konstruktor wype³nia strukturê odpowiednimi wartoœciami
	ULONG_PTR	gdiplusToken;			// tzw. token GDI+; wartoœæ uzyskiwana przy inicjowaniu i przekazywana do funkcji GdiplusShutdown
   
	// Inicjujemy GDI+.
	GdiplusStartup(&gdiplusToken, &gdiplusParametry, NULL);

	//Definiujemy klase g³ównego okna aplikacji
	//Okreslamy tu wlasciwosci okna, szczegoly wygladu oraz
	//adres funkcji przetwarzajacej komunikaty
	nasza_klasa.style         = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
	nasza_klasa.lpfnWndProc   = WndProc; //adres funkcji realizuj¹cej przetwarzanie meldunków 
 	nasza_klasa.cbClsExtra    = 0 ;
	nasza_klasa.cbWndExtra    = 0 ;
	nasza_klasa.hInstance     = hInstance; //identyfikator procesu przekazany przez MS Windows podczas uruchamiania programu
	nasza_klasa.hIcon         = 0;
	nasza_klasa.hCursor       = LoadCursor(0, IDC_ARROW);
	nasza_klasa.hbrBackground = (HBRUSH) GetStockObject(GRAY_BRUSH);
	nasza_klasa.lpszMenuName  = "Menu" ;
	nasza_klasa.lpszClassName = nazwa_klasy;

    //teraz rejestrujemy klasê okna g³ównego
    RegisterClass (&nasza_klasa);
	
	/*tworzymy okno g³ówne
	okno bêdzie mia³o zmienne rozmiary, listwê z tytu³em, menu systemowym
	i przyciskami do zwijania do ikony i rozwijania na ca³y ekran, po utworzeniu
	bêdzie widoczne na ekranie */
 	okno = CreateWindow(nazwa_klasy, "Grafika komputerowa", WS_OVERLAPPEDWINDOW | WS_VISIBLE,
						CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL);
	
	
	/* wybór rozmiaru i usytuowania okna pozostawiamy systemowi MS Windows */
   	ShowWindow (okno, nCmdShow) ;
    
	//odswiezamy zawartosc okna
	UpdateWindow (okno) ;

	// G£ÓWNA PÊTLA PROGRAMU
	while (GetMessage(&meldunek, NULL, 0, 0))
     /* pobranie komunikatu z kolejki; funkcja GetMessage zwraca FALSE tylko dla
	 komunikatu WM_QUIT; dla wszystkich pozosta³ych komunikatów zwraca wartoœæ TRUE */
	{
		TranslateMessage(&meldunek); // wstêpna obróbka komunikatu
		DispatchMessage(&meldunek);  // przekazanie komunikatu w³aœciwemu adresatowi (czyli funkcji obslugujacej odpowiednie okno)
	}

	GdiplusShutdown(gdiplusToken);
	
	return (int)meldunek.wParam;
}

/********************************************************************
FUNKCJA OKNA realizujaca przetwarzanie meldunków kierowanych do okna aplikacji*/
LRESULT CALLBACK WndProc (HWND okno, UINT kod_meldunku, WPARAM wParam, LPARAM lParam)
{
	HMENU mPlik, mInfo, mGlowne;
    	
/* PONI¯SZA INSTRUKCJA DEFINIUJE REAKCJE APLIKACJI NA POSZCZEGÓLNE MELDUNKI */
	switch (kod_meldunku) 
	{
	case WM_CREATE:  //meldunek wysy³any w momencie tworzenia okna
		mPlik = CreateMenu();
		AppendMenu(mPlik, MF_STRING, 100, "&Zapiszcz...");
		AppendMenu(mPlik, MF_SEPARATOR, 0, "");
		AppendMenu(mPlik, MF_STRING, 101, "&Koniec");
		mInfo = CreateMenu();
		AppendMenu(mInfo, MF_STRING, 200, "&Autor...");
		mGlowne = CreateMenu();
		AppendMenu(mGlowne, MF_POPUP, (UINT_PTR) mPlik, "&Plik");
		AppendMenu(mGlowne, MF_POPUP, (UINT_PTR) mInfo, "&Informacja");
		SetMenu(okno, mGlowne);
		DrawMenuBar(okno);
		czesc1(tab1);
		czesc2(tab2);
		/*
		samochod(car, { 750, 50 });
		PolyBezier(kontekst, car, 13);
		*/
		serce(heart, { 375, 50 });
		skaluj(heart, 13, 2);



	case WM_COMMAND: //reakcje na wybór opcji z menu
		switch (wParam)
		{
		case 100: if(MessageBox(okno, "Zapiszczeæ?", "Pisk", MB_YESNO) == IDYES)
					MessageBeep(0);
                  break;
		case 101: DestroyWindow(okno); //wysylamy meldunek WM_DESTROY
        		  break;
		case 200: MessageBox(okno, "Imiê i nazwisko: Damian Jankowski\nNumer indeksu: 188597", "Autor", MB_OK);
		}
		return 0;
	
	case WM_LBUTTONDOWN:
	{
		int x = LOWORD(lParam);
		int y = HIWORD(lParam);
		if (!isChosen) {
			for (int i = 0; i < 13; i++) {
				if ((x - 5 <= heart[i].x) && (x + 5 >= heart[i].x) && (y - 5 <= heart[i].y) && (y + 5 >= heart[i].y)) {
					chosen = i;
					isChosen = true;
				}
			}
		}
		else {
			isChosen = false;
		}
	}

	case WM_MOUSEMOVE:
	{
		int x = LOWORD(lParam);
		int y = HIWORD(lParam);
		if (isChosen) {
			if (chosen == 0 || chosen == 12) {
				heart[0].x = heart[12].x = x;
				heart[0].y = heart[12].y = y;
			}
			else {
				heart[chosen].x = x;
				heart[chosen].y = y;
			}
			InvalidateRect(okno, NULL, true);
		}

	}
	case WM_PAINT:
		{
			PAINTSTRUCT paint;
			HDC kontekst;

			kontekst = BeginPaint(okno, &paint);
		
			// MIEJSCE NA KOD GDI

			HBRUSH pedzel[] = {
				CreateSolidBrush(RGB(0, 0, 255)),
				CreateSolidBrush(RGB(0, 255, 0)),
				CreateSolidBrush(RGB(255, 0, 0)),
				CreateSolidBrush(RGB(0, 255, 255)),
				CreateSolidBrush(RGB(255, 255, 0)),
				CreateSolidBrush(RGB(255, 0, 255)),
				CreateSolidBrush(RGB(0, 0, 0)),
			};

			SelectObject(kontekst, pedzel[0]);
			Pie(kontekst, 0, 0, 600, 600, 100, 0, 0, 100);

			SelectObject(kontekst, pedzel[1]);
			Pie(kontekst, 0, 0, 600, 600, 0, 100, 500, 600);

			SelectObject(kontekst, pedzel[2]);
			Pie(kontekst, 0, 0, 600, 600, 500, 600, 600, 500);

			SelectObject(kontekst, pedzel[3]);
			Pie(kontekst, 0, 0, 600, 600, 600, 500, 100, 0);

			SelectObject(kontekst, pedzel[4]);
			Polygon(kontekst, tab1, 7);

			SelectObject(kontekst, pedzel[5]);
			Polygon(kontekst, tab2, 7);

			/*
			for (int i = 0; i < 13; i++) {
				Ellipse(kontekst, car[i].x - 5, car[i].y - 5, car[i].x + 5, car[i].y + 5);
			}
			Ellipse(kontekst, 685, 500, 735, 550);
			Ellipse(kontekst, 810, 500, 860, 550);
			*/

			PolyBezier(kontekst, heart, 13);
			for (int i = 0; i < 13; i++) {
				Ellipse(kontekst, heart[i].x - 5, heart[i].y - 5, heart[i].x + 5, heart[i].y + 5);
			}
			
			for each (HBRUSH p in pedzel) {
			DeleteObject(p);
			}

			// utworzenie obiektu umo¿liwiaj¹cego rysowanie przy u¿yciu GDI+
			// (od tego momentu nie mo¿na u¿ywaæ funkcji GDI
			Graphics grafika(kontekst);
			
			// MIEJSCE NA KOD GDI+

			// utworzenie czcionki i wypisanie tekstu na ekranie
			/*
			FontFamily  fontFamily(L"Times New Roman");
			Font        font(&fontFamily, 24, FontStyleRegular, UnitPixel);
			PointF      pointF(100.0f, 400.0f);
			SolidBrush  solidBrush(Color(255, 0, 0, 255));

			grafika.DrawString(L"To jest tekst napisany za pomoc¹ GDI+.", -1, &font, pointF, &solidBrush);
			*/
			EndPaint(okno, &paint);

			return 0;
		}
  	
	case WM_DESTROY: //obowi¹zkowa obs³uga meldunku o zamkniêciu okna
		PostQuitMessage (0) ;
		return 0;
    
	default: //standardowa obs³uga pozosta³ych meldunków
		return DefWindowProc(okno, kod_meldunku, wParam, lParam);
	}
}
