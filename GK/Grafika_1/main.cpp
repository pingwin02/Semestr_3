
//W środku zamiast znaku ma się kręcić dowolny wielokąt foremny(2pkt)

//Wokół okręgu ma się obracać stycznie drugi okrąg a wewnątrz tego stycznego okręgu ma być kręcący się wielokąt(1,5pkt)

//Ten kręcący się okrąg z wielokątem ma się ciągle zwiększać i zmniejszać pozostając styczny(1,5pkt)

//n-wielokat
//ma sie obracac
//porusza sie po osemce

#define _USE_MATH_DEFINES
#include <math.h>
#include <stdio.h>

// Dołącz definicje biblioteki Allegro
#include <allegro5/allegro.h>
#include <allegro5/allegro_primitives.h>

const float FPS = 60;		//obraz będzie aktualizowany co 1/FPS sekundy
const int SCREEN_W = 720;	//szerokość okna
const int SCREEN_H = 720;	//wysokość okna

// Funkcja główna
int main()
{
	ALLEGRO_DISPLAY* display = NULL;			//okno
	ALLEGRO_EVENT_QUEUE* event_queue = NULL;	//kolejka zdarzen
	ALLEGRO_TIMER* timer = NULL;				//timer, od ktorego będziemy odbierac zdarzenia (potrzebny do animacji)
	bool redraw = true;

	if (!al_init()) {							//inicjalizacja biblioteki Allegro
		fprintf(stderr, "Nie zainicjalizowano allegro!\n");
		return -1;
	}

	display = al_create_display(SCREEN_W, SCREEN_H);	//utworznie okna
	timer = al_create_timer(1.0 / FPS);					//utworzenie timera
	al_install_keyboard();								//inicjalizacja obsługi klawiatury
	event_queue = al_create_event_queue();				//utworzenie kolejki zdarzeń

	al_init_primitives_addon();							//inicjalizacja obsługi prostych elementów (punkty, linie, prostokąty, elipsy itd.)

	//Rejestracja żródeł zdarzeń (okno, timer, klawiatura ...)
	al_register_event_source(event_queue, al_get_display_event_source(display));
	al_register_event_source(event_queue, al_get_timer_event_source(timer));
	al_register_event_source(event_queue, al_get_keyboard_event_source());

	//Kolory rysowania
	ALLEGRO_COLOR yellow = al_map_rgb(255, 255, 0);
	ALLEGRO_COLOR white = al_map_rgb(255, 255, 255);
	ALLEGRO_COLOR blue = al_map_rgb(0, 0, 255);
	ALLEGRO_COLOR black = al_map_rgb(0, 0, 0);

	//Wyznacz środek ekranu
	int xm = SCREEN_W / 2;
	int ym = SCREEN_H / 2;

	//Definicja wielokąta
	const int N = 5;

	float dx[N] = {};
	float dy[N] = {};

	//Tablice na przetworzone współrzędna punktów
	float points[2 * N] = {};

	//Zmienne na potrzeby obracania figury
	double fi = 0.0, dfi = 0.02, sinfi, cosfi;
	double x1, y1, size;

	//Uruchamiamy timer, który będzie z zadaną częstotliwością wysyłał zdarzenia
	al_start_timer(timer);

	//Pętla główna programu - obsługa zdarzeń.
	//Działamy, dopóki użytkownik nie wciśnie Esc.


	while (true)
	{
		ALLEGRO_EVENT event;
		al_wait_for_event(event_queue, &event);

		if (event.type == ALLEGRO_EVENT_TIMER) {	//zdarzenie timera -> odświeżenie obrazu 
			redraw = true;
		}
		else if (event.type == ALLEGRO_EVENT_KEY_DOWN) {	//zdarzenie klawiatury -> jeśli Esc to kończymy
			if (event.keyboard.keycode == ALLEGRO_KEY_ESCAPE)
				break;
		}
		else if (event.type == ALLEGRO_EVENT_DISPLAY_CLOSE) { //zdarzenie zamknięcia okna
			break;
		}

		if (redraw && al_is_event_queue_empty(event_queue))
		{
			redraw = false;
			al_clear_to_color(black); //czyszczenie okna na zadany kolor

			//Narysuj okrąg
			al_draw_circle(xm, ym, 100, white, 2);

			//Definicja wierzcholkow
			for (int i = 0; i < N; i++) {
				dx[i] = 50 * cos(2 * M_PI * i / N);
				dy[i] = 50 * sin(2 * M_PI * i / N);
			}

			//Obrót figury
			sinfi = sin(fi);
			cosfi = cos(fi);

			for (int i = 0; i < N; i++)
			{
				points[2 * i] = (dx[i] * cosfi - dy[i] * sinfi + 0.5) + xm;
				points[2 * i + 1] = (dx[i] * sinfi + dy[i] * cosfi + 0.5) + ym;
			}

			//Narysuj wielokat
			al_draw_polygon(points, N, ALLEGRO_LINE_JOIN_ROUND, white, 2, 2);

			//Zmiana rozmiaru
			size = 50 + sinfi * cosfi * 50;

			for (int i = 0; i < N; i++) {
				dx[i] = size * cos(2 * M_PI * i / N);
				dy[i] = size * sin(2 * M_PI * i / N);
			}

			//Narysuj drugi okrąg
			x1 = xm + cosfi * 2 * (size + 50);
			y1 = ym + sinfi * 2 * (size + 50);
			al_draw_circle(x1, y1, 2 * size, white, 2);

			//Narysuj drugi wielokat

			for (int i = 0; i < N; i++)
			{
				points[2 * i] = (dx[i] * sinfi + dy[i] * cosfi + 0.5) + x1;
				points[2 * i + 1] = (dx[i] * cosfi - dy[i] * sinfi + 0.5) + y1;
			}

			al_draw_polygon(points, N, ALLEGRO_LINE_JOIN_ROUND, white, 2, 2);

			fi += dfi;
			//Wyświetl w oknie to, co narysowano w buforze
			al_flip_display();
		}
	}

	al_destroy_display(display);
	al_destroy_timer(timer);
	al_destroy_event_queue(event_queue);
	return 0;
}
