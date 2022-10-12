-- Damian Jankowski s188597
-- spotkanie warunkowe (conditional entry call)

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;

with Ada.Strings.Unbounded;         use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;

procedure Simulation is

	Ilosc_Produktow: constant Integer := 5;
	Ilosc_Zestawow: constant Integer := 3;
	Ilosc_Klientow: constant Integer := 3;

	subtype Typ_Produkt is Integer range 1 .. Ilosc_Produktow;
	subtype Typ_Zestaw is Integer range 1 .. Ilosc_Zestawow;
	subtype Typ_Klient is Integer range 1 .. Ilosc_Klientow;

	Nazwa_Produktu: constant array (Typ_Produkt) of Unbounded_String 
		:= (To_Unbounded_String("Lancuch"), 
			To_Unbounded_String("Zebatka"),
			To_Unbounded_String("Rama"),
			To_Unbounded_String("Kola"),
			To_Unbounded_String("Siodelko"));
	Nazwa_Zestawow: constant array (Typ_Zestaw) of Unbounded_String 
		:= (To_Unbounded_String("Mechaniczny"), 
			To_Unbounded_String("BMX"),
			To_Unbounded_String("Kolarzowka"));
	Imie_Klienta: constant array (1 .. Ilosc_Klientow) of Unbounded_String 
		:= (To_Unbounded_String("Damian"), 
			To_Unbounded_String("Ania"),
			To_Unbounded_String("Maciek"));

	package Losowy_Zestaw is new
		Ada.Numerics.Discrete_Random(Typ_Zestaw);

	-- Producent produkuje produkty
	task type Producent is
		-- Podaj producentowi nr produktu
		entry Start(Produkt: in Typ_Produkt);
	end Producent;

	-- Klient zamawia i odbiera dany zestaw
	task type Klient is
		-- Podaj klientowi jego numer
		entry Start(Numer_Klienta: in Typ_Klient);
	end Klient;

	-- W magazynie produkty sa skladane w zestaw
	task type Magazyn is
		-- Odbierz produkt jesli jest miejsce
		entry Odbierz(Produkt: in Typ_Produkt; Numer: in Integer);
		-- Zloz zestaw jesli jest wystarczajaco produktow
		entry Skladaj(Zestaw: in Typ_Zestaw; Numer: out Integer);
	end Magazyn;

	P: array ( 1 .. Ilosc_Produktow ) of Producent;
	K: array ( 1 .. Ilosc_Klientow ) of Klient;
	M: Magazyn;
	Czas: Integer;

	task body Producent is

		subtype Przedzial_Czasu_Produkcji is Integer range 7 .. 12;

		package Losuj_Czas_Produkcji is new
			Ada.Numerics.Discrete_Random(Przedzial_Czasu_Produkcji);

		GP: Losuj_Czas_Produkcji.Generator;	--  Generator czasu produkcji

		Numer_Typu_Produktu: Integer;
		Numer_Produktu: Integer;

	begin
		accept Start(Produkt: in Typ_Produkt) do
			Losuj_Czas_Produkcji.Reset(GP);	--  Uruchom generatory
			Numer_Produktu := 1;
			Numer_Typu_Produktu := Produkt;
		end Start;

		loop
			Put_Line("[PRODUCENT] Zaczeto produkcje: " & 
			Nazwa_Produktu(Numer_Typu_Produktu));
			Czas := Losuj_Czas_Produkcji.Random(GP);
			delay Duration(Czas); --  Symuluj produkcję
			Put_Line("[PRODUCENT] Wyprodukowano: " &
			Nazwa_Produktu(Numer_Typu_Produktu) & 
			"  nr "  & Integer'Image(Numer_Produktu));
			-- Dostarcz do magazynu produkt
			Czas := Losuj_Czas_Produkcji.Random(GP);
			Put_Line("[PRODUCENT] Towar (" & 
					Nazwa_Produktu(Numer_Typu_Produktu) &
					") przyjedzie do magazynu za " & 
					Integer'Image(Czas) & " sekund ...");
			delay Duration(Czas); -- Symuluj transport
			loop
				select
					M.Odbierz(Numer_Typu_Produktu, Numer_Produktu);
					Numer_Produktu := Numer_Produktu + 1;
					exit;
				else
					Put_Line("[PRODUCENT] Towar (" & 
					Nazwa_Produktu(Numer_Typu_Produktu) &
					") czeka 5 sekund pod brama magazynu ...");
					delay 5.0;
				end select;
			end loop;
		end loop;

	end Producent;

	task body Klient is

		subtype Przedzial_Czasu_Zamawiania is Integer range 5 .. 10;

		package Losuj_Czas_Zamawiania is new
			Ada.Numerics.Discrete_Random(Przedzial_Czasu_Zamawiania);

		GCZ: Losuj_Czas_Zamawiania.Generator;	--  Generator Czasu Zamawiania
		GZ: Losowy_Zestaw.Generator;	--  Generator nr Zestawu

		ID_Klienta: Typ_Klient;
		Numer_Zestawu: Integer;
		Typ_Zestawu: Integer;

	begin
		accept Start(Numer_Klienta: in Typ_Klient) do
			Losuj_Czas_Zamawiania.Reset(GCZ);	--  Ustaw generatory
			Losowy_Zestaw.Reset(GZ);
			ID_Klienta := Numer_Klienta;
		end Start;

		loop
			Put_Line("[KLIENT] Do sklepu zawital klient: " & Imie_Klienta(ID_Klienta));
			Typ_Zestawu := Losowy_Zestaw.Random(GZ);
			Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & " zastanawia sie ...");
			delay Duration(Losuj_Czas_Zamawiania.Random(GCZ)); --  Symuluj zamawianie
			Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & " zamawia zestaw: " &
			Nazwa_Zestawow(Typ_Zestawu));
			loop
				select
					M.Skladaj(Typ_Zestawu, Numer_Zestawu);
					if Numer_Zestawu /= 0 then
						Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & " odbiera zestaw: " &
								Nazwa_Zestawow(Typ_Zestawu) & " nr " &
								Integer'Image(Numer_Zestawu));
					else
						Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & 
								": Trudno, przyjde za 10 sekund!");
								delay 10.0;
					end if;
					exit;
				else
					Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & 
							" czeka na obsluzenie 5 sekund ...");
					delay 5.0;		
				end select;
			end loop;
		end loop;

	end Klient;

	task body Magazyn is

		Pojemnosc_Magazynu: constant Integer := 15;

		type Typ_Magazyn is array (Typ_Produkt) of Integer;

		Magazyn: Typ_Magazyn := (0, 0, 0, 0, 0);

		Zawartosc_Zestawow: array(Typ_Zestaw, Typ_Produkt) of Integer
			:= ((3, 2, 0, 0, 0),(1, 2, 1, 2, 0),(1, 1, 1, 2, 1));

		Max_Zawartosc_Zestawow: array(Typ_Produkt) of Integer;

		Ilosc_Zestawu: array(Typ_Zestaw) of Integer := (0, 0, 0);

		W_Magazynie: Integer := 0;

		procedure Wyznacz_Max_Zestawow is

		begin
			for W in Typ_Produkt loop
			Max_Zawartosc_Zestawow(W) := 0;
				for Z in Typ_Zestaw loop
					if Zawartosc_Zestawow(Z, W) > Max_Zawartosc_Zestawow(W) then
					Max_Zawartosc_Zestawow(W) := Zawartosc_Zestawow(Z, W);
					end if;
				end loop;
			end loop;

		end Wyznacz_Max_Zestawow;

		function Moze_Przyjac(Produkt: Typ_Produkt) return Boolean is

		begin
			if W_Magazynie >= Pojemnosc_Magazynu then -- Sprawdz pojemnosc magazynu
				Put_Line("[STAN] Magazyn pelny! Odbior niemozliwy!");
				return False;
			end if;

			-- Sprawdz czy ilosc tego produktu nie jest za duza
			if Magazyn(Produkt) > Max_Zawartosc_Zestawow(Produkt) 
				and W_Magazynie > Pojemnosc_Magazynu/2 then
					Put_Line("[STAN] W magazynie jest wystarczajaca ilosc: " 
					& Nazwa_Produktu(Produkt) & ". Towar odeslano!");
					return False;
			end if;

			return True; -- Jest miejsce na ten produkt

		end Moze_Przyjac;

		function Czy_Zlozy(Zestaw: Typ_Zestaw) return Boolean is

		begin
			-- Sprawdz czy mozna zlozyc zestaw
			for W in Typ_Produkt loop
				if Magazyn(W) < Zawartosc_Zestawow(Zestaw, W) then
					return False;
				end if;
			end loop;

			return True;

		end Czy_Zlozy;

		procedure Magazyn_Info is --informacje co znajduje sie w magazynie

		begin
			Put_Line("");
			Put_Line("Magazyn (" & Integer'Image(W_Magazynie) & "/" 
			& Integer'Image(Pojemnosc_Magazynu) &") zawiera: ");
			for W in Typ_Produkt loop
				Put_Line(Integer'Image(Magazyn(W)) & "x " & Nazwa_Produktu(W));
			end loop;
			Put_Line("Zlozono: ");
			for Z in Typ_Zestaw loop
				Put_Line(Integer'Image(Ilosc_Zestawu(Z)) & "x " & Nazwa_Zestawow(Z));
			end loop;
			Put_Line("");
		end Magazyn_Info;
		
	begin
		Put_Line("Magazyn otwiera sie:");
		Wyznacz_Max_Zestawow;
		loop
			select
				-- Odbieranie produktow od producentow
				accept Odbierz(Produkt: in Typ_Produkt; Numer: in Integer) do
					if Moze_Przyjac(Produkt) then
						Put_Line("[MAGAZYN] Przyjeto dostawe: " &
								Nazwa_Produktu(Produkt) & " nr " & Integer'Image(Numer));
						Magazyn(Produkt) := Magazyn(Produkt) + 1;
						W_Magazynie := W_Magazynie + 1;
						Magazyn_Info;
					end if;
				end Odbierz;
			or	
				-- Odbieranie zamowien od klientow
				accept Skladaj(Zestaw: in Typ_Zestaw; Numer: out Integer) do
					if Czy_Zlozy(Zestaw) then
						Ilosc_Zestawu(Zestaw) := Ilosc_Zestawu(Zestaw) + 1;
						Numer := Ilosc_Zestawu(Zestaw);
						Put_Line("[MAGAZYN] Skladamy zamowiony zestaw: " 
						& Nazwa_Zestawow(Zestaw) & " nr "
						& Integer'Image(Ilosc_Zestawu(Zestaw)) 
						& " Potrwa to 5 s ...");
						delay 5.0;
						Put_Line("[MAGAZYN] Zlozono zestaw: " & Nazwa_Zestawow(Zestaw) 
								& " nr " & Integer'Image(Ilosc_Zestawu(Zestaw)));
						for W in Typ_Produkt loop
							Magazyn(W) := Magazyn(W) - Zawartosc_Zestawow(Zestaw, W);
							W_Magazynie := W_Magazynie - Zawartosc_Zestawow(Zestaw, W);
						end loop;
						Magazyn_Info;
					else
						Put_Line("[MAGAZYN] Przykro nam, brakuje czesci do zestawu: " &
								Nazwa_Zestawow(Zestaw));
						Numer := 0;
					end if;
				end Skladaj;
			end select;
		end loop;

	end Magazyn;

begin
	-- Uruchomienie watkow
	for I in 1 .. Ilosc_Produktow loop
		P(I).Start(I);
	end loop;
	for J in 1 .. Ilosc_Klientow loop
		K(J).Start(J);
	end loop;
	
end Simulation;
