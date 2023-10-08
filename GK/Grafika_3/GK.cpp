/******************************************************************
 Grafika komputerowa, �rodowisko MS Windows - program  przyk�adowy
 *****************************************************************/

#include <windows.h>
#include <gdiplus.h>
using namespace Gdiplus;

POINT tab1[4], tab2[8];

Point heart[13];

int chosen;
bool isChosen = false;

void czescD(POINT* tab, POINT start) {
	tab[0] = { 200 + start.x, 100 };
	tab[1] = { 200 + start.x, 300 };
	tab[2] = { 275 + start.x, 300 };
	tab[3] = { 275 + start.x, 100 };
}

void czescJ(POINT* tab, POINT start) {
	tab[0] = { 450 + start.x, 100 };
	tab[1] = { 350 + start.x, 100 };
	tab[2] = { 350 + start.x, 150 };
	tab[3] = { 425 + start.x, 150 };
	tab[4] = { 425 + start.x, 250 };
	tab[5] = { 450 + start.x, 250 };
}
void serce(Point* heart, POINT start) {
	heart[0] = { 40 + start.x, 100 + start.y };
	heart[1] = { 60 + start.x, 70 + start.y };
	heart[2] = { 80 + start.x, 70 + start.y };
	heart[3] = { 110 + start.x, 80 + start.y };
	heart[4] = { 140 + start.x, 70 + start.y };
	heart[5] = { 160 + start.x, 70 + start.y };
	heart[6] = { 180 + start.x, 100 + start.y };
	heart[7] = { 190 + start.x, 120 + start.y };
	heart[8] = { 160 + start.x, 190 + start.y };
	heart[9] = { 110 + start.x, 250 + start.y };
	heart[10] = { 65 + start.x, 190 + start.y };
	heart[11] = { 30 + start.x, 120 + start.y };
	heart[12] = { 40 + start.x, 100 + start.y };
}

void skaluj(Point* tab, int n, int skala) {
	for (int i = 0; i < n; i++)
	{
		tab[i].X *= skala;
		tab[i].Y *= skala;
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
	WNDCLASS nasza_klasa; //klasa g��wnego okna aplikacji
	HWND okno;
	static char nazwa_klasy[] = "Podstawowa";

	GdiplusStartupInput gdiplusParametry;// parametry GDI+; domy�lny konstruktor wype�nia struktur� odpowiednimi warto�ciami
	ULONG_PTR	gdiplusToken;			// tzw. token GDI+; warto�� uzyskiwana przy inicjowaniu i przekazywana do funkcji GdiplusShutdown

	// Inicjujemy GDI+.
	GdiplusStartup(&gdiplusToken, &gdiplusParametry, NULL);

	//Definiujemy klase g��wnego okna aplikacji
	//Okreslamy tu wlasciwosci okna, szczegoly wygladu oraz
	//adres funkcji przetwarzajacej komunikaty
	nasza_klasa.style = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
	nasza_klasa.lpfnWndProc = WndProc; //adres funkcji realizuj�cej przetwarzanie meldunk�w 
	nasza_klasa.cbClsExtra = 0;
	nasza_klasa.cbWndExtra = 0;
	nasza_klasa.hInstance = hInstance; //identyfikator procesu przekazany przez MS Windows podczas uruchamiania programu
	nasza_klasa.hIcon = 0;
	nasza_klasa.hCursor = LoadCursor(0, IDC_ARROW);
	nasza_klasa.hbrBackground = (HBRUSH)GetStockObject(GRAY_BRUSH);
	nasza_klasa.lpszMenuName = "Menu";
	nasza_klasa.lpszClassName = nazwa_klasy;

	//teraz rejestrujemy klas� okna g��wnego
	RegisterClass(&nasza_klasa);

	/*tworzymy okno g��wne
	okno b�dzie mia�o zmienne rozmiary, listw� z tytu�em, menu systemowym
	i przyciskami do zwijania do ikony i rozwijania na ca�y ekran, po utworzeniu
	b�dzie widoczne na ekranie */
	okno = CreateWindow(nazwa_klasy, "Grafika komputerowa", WS_OVERLAPPEDWINDOW | WS_VISIBLE,
		CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL);


	/* wyb�r rozmiaru i usytuowania okna pozostawiamy systemowi MS Windows */
	ShowWindow(okno, nCmdShow);

	//odswiezamy zawartosc okna
	UpdateWindow(okno);

	// G��WNA P�TLA PROGRAMU
	while (GetMessage(&meldunek, NULL, 0, 0))
		/* pobranie komunikatu z kolejki; funkcja GetMessage zwraca FALSE tylko dla
		komunikatu WM_QUIT; dla wszystkich pozosta�ych komunikat�w zwraca warto�� TRUE */
	{
		TranslateMessage(&meldunek); // wst�pna obr�bka komunikatu
		DispatchMessage(&meldunek);  // przekazanie komunikatu w�a�ciwemu adresatowi (czyli funkcji obslugujacej odpowiednie okno)
	}

	GdiplusShutdown(gdiplusToken);

	return (int)meldunek.wParam;
}

/********************************************************************
FUNKCJA OKNA realizujaca przetwarzanie meldunk�w kierowanych do okna aplikacji*/
LRESULT CALLBACK WndProc(HWND okno, UINT kod_meldunku, WPARAM wParam, LPARAM lParam)
{
	HMENU mPlik, mInfo, mGlowne;

	/* PONI�SZA INSTRUKCJA DEFINIUJE REAKCJE APLIKACJI NA POSZCZEG�LNE MELDUNKI */
	switch (kod_meldunku)
	{
	case WM_CREATE:  //meldunek wysy�any w momencie tworzenia okna
		mPlik = CreateMenu();
		AppendMenu(mPlik, MF_STRING, 100, "&Zapiszcz...");
		AppendMenu(mPlik, MF_SEPARATOR, 0, "");
		AppendMenu(mPlik, MF_STRING, 101, "&Koniec");
		mInfo = CreateMenu();
		AppendMenu(mInfo, MF_STRING, 200, "&Autor...");
		mGlowne = CreateMenu();
		AppendMenu(mGlowne, MF_POPUP, (UINT_PTR)mPlik, "&Plik");
		AppendMenu(mGlowne, MF_POPUP, (UINT_PTR)mInfo, "&Informacja");
		SetMenu(okno, mGlowne);
		DrawMenuBar(okno);
		czescD(tab1, { 0, 0 });
		czescJ(tab2, { 0, 0 });

		serce(heart, { 0, -50 });
		skaluj(heart, 13, 3);



	case WM_COMMAND: //reakcje na wyb�r opcji z menu
		switch (wParam)
		{
		case 100: if (MessageBox(okno, "Zapiszcze�?", "Pisk", MB_YESNO) == IDYES)
			MessageBeep(0);
			break;
		case 101: DestroyWindow(okno); //wysylamy meldunek WM_DESTROY
			break;
		case 200: MessageBox(okno, "Imi� i nazwisko: Damian Jankowski\nNumer indeksu: 188597", "Autor", MB_OK);
		}
		return 0;

	case WM_LBUTTONDOWN:
	{
		int x = LOWORD(lParam);
		int y = HIWORD(lParam);
		if (!isChosen) {
			for (int i = 0; i < 13; i++) {
				if ((x - 5 <= heart[i].X) && (x + 5 >= heart[i].X) && (y - 5 <= heart[i].Y) && (y + 5 >= heart[i].Y)) {
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
				heart[0].X = heart[12].X = x;
				heart[0].Y = heart[12].Y = y;
			}
			else {
				heart[chosen].X = x;
				heart[chosen].Y = y;
			}
			InvalidateRect(okno, NULL, true);
		}

	}
	case WM_PAINT:
	{

		PAINTSTRUCT paint;
		HDC kontekst;

		kontekst = BeginPaint(okno, &paint);

		// utworzenie obiektu umo�liwiaj�cego rysowanie przy u�yciu GDI+
		// (od tego momentu nie mo�na u�ywa� funkcji GDI
		Graphics grafika(kontekst);

		// MIEJSCE NA KOD GDI+

		Pen pen(Color(255, 0, 0, 0), 10);

		SolidBrush solidBrush(Color(255, 255, 0, 0));

		GraphicsPath* sercePath = new GraphicsPath();
		sercePath->AddBeziers(heart, 13);

		grafika.DrawBeziers(&pen, heart, 13);

		grafika.FillPath(&solidBrush, sercePath);

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

		SelectObject(kontekst, CreatePen(PS_SOLID, 2, RGB(0, 0, 0)));
		SelectObject(kontekst, pedzel[3]);
		Polygon(kontekst, tab1, 4);

		Pie(kontekst, 200, 100, 350, 300, 275, 300, 275, 100);

		SelectObject(kontekst, pedzel[2]);
		Pie(kontekst, 200, 150, 300, 250, 250, 300, 250, 100);

		SelectObject(kontekst, pedzel[3]);
		Polygon(kontekst, tab2, 6);
		Pie(kontekst, 350, 200, 450, 300, 350, 250, 450, 250);

		SelectObject(kontekst, pedzel[2]);
		Pie(kontekst, 375, 225, 425, 275, 350, 250, 400, 250);

		SelectObject(kontekst, CreatePen(PS_SOLID, 2, RGB(0, 0, 0)));

		SelectObject(kontekst, pedzel[6]);

		for (int i = 0; i < 13; i++) {
			Ellipse(kontekst, heart[i].X - 5, heart[i].Y - 5, heart[i].X + 5, heart[i].Y + 5);
		}

		for each (HBRUSH p in pedzel) {
			DeleteObject(p);
		}

		EndPaint(okno, &paint);

		return 0;
	}

	case WM_DESTROY: //obowi�zkowa obs�uga meldunku o zamkni�ciu okna
		PostQuitMessage(0);
		return 0;

	default: //standardowa obs�uga pozosta�ych meldunk�w
		return DefWindowProc(okno, kod_meldunku, wParam, lParam);
	}
}
