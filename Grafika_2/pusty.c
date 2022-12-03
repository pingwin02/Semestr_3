
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <stdlib.h>
#include <sys/time.h>
#include <string.h>
#include <math.h>

#define TRUE 1
#define FALSE 0

int red, green, blue, yellow;
unsigned long foreground, background;

void usleep();

//*************************************************************************************************************************
// Funkcje rysujace
//75,125
void literaD(Display* display, Window window, GC gc, int x, int y)
{

  XSetForeground(display, gc, yellow);
  XFillArc(display, window, gc, x-75, y, 250, 250, -90*64, 180*64);
  XFillRectangle(display, window, gc, x, y, 50, 250);

  XSetForeground(display, gc, red);
  XFillArc(display, window, gc, x-25, y, 50, 250, -90*64, 180*64);
  XFillArc(display, window, gc, x-25, y+50, 150, 150, -90*64, 180*64);

  XSetForeground(display, gc, foreground);
  XDrawArc(display, window, gc, x-75, y, 250, 250, -90*64, 180*64);
  XDrawArc(display, window, gc, x-25, y, 50, 250, -90*64, 180*64);
  XDrawLine(display, window, gc, x, y, x+50, y);
  XDrawLine(display, window, gc, x+50, y+50, x+50, y+200);
  XDrawLine(display, window, gc, x, y+250, x+50, y+250);
  XDrawArc(display, window, gc, x-25, y+50, 150, 150, -90*64, 180*64);
}

//275, 125
void cyfra7(Display* display, Window window, GC gc, int x, int y) {

  XSetForeground(display, gc, 0XFFB6C1);
  XFillRectangle(display, window, gc, x, y, 150, 50);
  XPoint punkty[] = {{375, y+50}, {-100, 200}, {50, 0}, {100, -200}};
  XFillPolygon(display, window, gc, punkty, 4, Complex, CoordModePrevious);

  XSetForeground(display, gc, red);
  XFillArc(display, window, gc, x, y-25, 150, 50, 180*64, 180*64);

  XSetForeground(display, gc, foreground);
  XDrawArc(display, window, gc, x, y-25, 150, 50, 180*64, 180*64);
  XDrawLines(display, window, gc, punkty, 4, CoordModePrevious);
  XDrawLine(display, window, gc, x, y, x, y+50);
  XDrawLine(display, window, gc, x, y+50, x+100, y+50);
  XDrawLine(display, window, gc, x+150, y, x+150, y+50);

}

//*************************************************************************************************************************
// Funkcja rysujaca tarcze

int tarcza(Display* display, Window window, GC gc)
{
  int width, height;
  XPoint points[7];
  XWindowAttributes attributes;

  XGetWindowAttributes(display, window, &attributes);
  width = attributes.width;
  height = attributes.height;

  for (int i = 0; i < 6; i++) {
    XPoint p;
    p.x = (width/2 * cos(2 * M_PI * i / 6 + M_PI/6 )) + width/2;
    p.y = width/2 * sin(2 * M_PI * i / 6 + M_PI/6 ) + width/2;
		points[i] = p;
	}
  points[6] = points[0];

  XSetForeground(display, gc, red);
  XFillPolygon(display, window, gc, points, 7, Complex, CoordModeOrigin);
  XSetForeground(display, gc, foreground);
  XDrawLines(display, window, gc, points, 7, CoordModeOrigin);

}


//*************************************************************************************************************************
//funkcja przydzielania kolorow

int AllocNamedColor(char *name, Display* display, Colormap colormap)
  {
    XColor col;
    XParseColor(display, colormap, name, &col);
    XAllocColor(display, colormap, &col);
    return col.pixel;
  } 

//*************************************************************************************************************************
// inicjalizacja zmiennych globalnych okreslajacych kolory

int init_colors(Display* display, int screen_no, Colormap colormap)
{
  background = WhitePixel(display, screen_no);  //niech tlo bedzie biale
  foreground = BlackPixel(display, screen_no);  //niech ekran bedzie czarny
  red=AllocNamedColor("red", display, colormap);
  green=AllocNamedColor("green", display, colormap);
  blue=AllocNamedColor("blue", display, colormap);
  yellow=AllocNamedColor("yellow", display, colormap);
}

//*************************************************************************************************************************
// Glowna funkcja zawierajaca petle obslugujaca zdarzenia */

int main(int argc, char *argv[])
{
  char            icon_name[] = "Grafika";
  char            title[]     = "Grafika komputerowa";
  Display*        display;    //gdzie bedziemy wysylac dane (do jakiego X servera)
  Window          window;     //nasze okno, gdzie bedziemy dokonywac roznych operacji
  GC              gc;         //tu znajduja sie informacje o parametrach graficznych
  XEvent          event;      //gdzie bedziemy zapisywac pojawiajace sie zdarzenia
  KeySym          key;        //informacja o stanie klawiatury 
  Colormap        colormap;
  int             screen_no;
  XSizeHints      info;       //informacje typu rozmiar i polozenie ok
  
  char            buffer[8];  //gdzie bedziemy zapamietywac znaki z klawiatury
  int             hm_keys;    //licznik klawiszy
  int             to_end;

  double xD = 75, yD = 125;
  double x7 = 275, y7 = 125;

  display    = XOpenDisplay("");                //otworz polaczenie z X serverem pobierz dane od zmiennej srodowiskowej DISPLAY ("")
  screen_no  = DefaultScreen(display);          //pobierz domyslny ekran dla tego wyswietlacza (0)
  colormap = XDefaultColormap(display, screen_no);
  init_colors(display, screen_no, colormap);

  //okresl rozmiar i polozenie okna
  info.x = 100;
  info.y = 150;
  info.width = 500;
  info.height = 500;
  info.flags = PPosition | PSize;

  //majac wyswietlacz, stworz okno - domyslny uchwyt okna
  window = XCreateSimpleWindow(display, DefaultRootWindow(display),info.x, info.y, info.width, info.height, 7/* grubosc ramki */, foreground, background);
  XSetStandardProperties(display, window, title, icon_name, None, argv, argc, &info);
  //utworz kontekst graficzny do zarzadzania parametrami graficznymi (0,0) domyslne wartosci
  gc = XCreateGC(display, window, 0, 0);
  XSetBackground(display, gc, background);
  XSetForeground(display, gc, foreground);
  XSetLineAttributes(display, gc, 5, LineSolid, CapNotLast, JoinRound);

  //okresl zdarzenia jakie nas interesuja, np. nacisniecie klawisza
  XSelectInput(display, window, (KeyPressMask | ExposureMask | ButtonPressMask| ButtonReleaseMask | Button1MotionMask | PointerMotionMask));
  XMapRaised(display, window);  //wyswietl nasze okno na samym wierzchu wszystkich okien
      
  to_end = FALSE;

 /* petla najpierw sprawdza, czy warunek jest spelniony
     i jesli tak, to nastepuje przetwarzanie petli
     a jesli nie, to wyjscie z petli, bez jej przetwarzania */
  while (to_end == FALSE)
  {
    XNextEvent(display, &event);  // czekaj na zdarzenia okreslone wczesniej przez funkcje XSelectInput
    switch(event.type)
    {
      case Expose:
        if (event.xexpose.count == 0)
        {
            XClearWindow(display, window);
            tarcza(display, window, gc);
            literaD(display, window, gc, xD, yD);
            cyfra7(display, window, gc, x7, yD);
        }
        break;

      case MappingNotify:
        XRefreshKeyboardMapping(&event.xmapping); // zmiana ukladu klawiatury - w celu zabezpieczenia sie przed taka zmiana trzeba to wykonac
        break;

      case ButtonPress:
        if (event.xbutton.button == Button1)  // sprawdzenie czy wciscnieto lewy przycisk				    
        {
          for (int tick = 0; tick < 25; tick++) {
            yD--;
            y7++;
            XClearWindow(display, window);
            tarcza(display, window, gc);
            literaD(display, window, gc, xD, yD);
            cyfra7(display, window, gc, x7, y7);
            XFlush(display);
            usleep(20000);
          }
            for (int tick = 0; tick < 50; tick++) {
            yD++;
            y7--;
            XClearWindow(display, window);
            tarcza(display, window, gc);
            literaD(display, window, gc, xD, yD);
            cyfra7(display, window, gc, x7, y7);
            XFlush(display);
            usleep(20000);
          }
            for (int tick = 0; tick < 25; tick++) {
            yD--;
            y7++;
            XClearWindow(display, window);
            tarcza(display, window, gc);
            literaD(display, window, gc, xD, yD);
            cyfra7(display, window, gc, x7, y7);
            XFlush(display);
            usleep(20000);
          }

        }          
        else if (event.xbutton.button == Button3) // sprawdzenie czy wciscnieto prawy przycisk
        {}
        event.type = Expose;                 // wymuszenie odswiezenia okna
        event.xexpose.count = 0;
        XSendEvent(display, window, 0, ExposureMask, &event); 
        break;

      case KeyPress:
        hm_keys = XLookupString(&event.xkey, buffer, 8, &key, 0);
        if (hm_keys == 1)
        {
          if (buffer[0] == 'q') to_end = TRUE;        // koniec programu       
        }

      default:
        break;
    }
  }

  XFreeGC(display, gc);
  XDestroyWindow(display, window);
  XCloseDisplay(display);

  return 0;
}
