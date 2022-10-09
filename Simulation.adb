-- Damian Jankowski s188597
-- spotkanie warunkowe (conditional entry call)

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; 
with Ada.Numerics.Discrete_Random;


procedure Simulation is

	Ilosc_Produktow: constant Integer := 5;
	Ilosc_Zestawow: constant Integer := 3;
	Ilosc_Klientow: constant Integer := 3;

	subtype Typ_Produkt is Integer range 1 .. Ilosc_Produktow;
	subtype Typ_Zestaw is Integer range 1 .. Ilosc_Zestawow;
	subtype Typ_Klient is Integer range 1 .. Ilosc_Klientow;

	Nazwa_Produktu: constant array (Typ_Produkt) of String(1 .. 8)
		:= ("Lancuch ", "Zebatka ", "Rama    ", 
		"Kola    ", "Siodelko");
	Nazwa_Zestawow: constant array (Typ_Zestaw) of String(1 .. 11)
		:= ("Mechaniczny", "Rower BMX  ", "Kolarzowka ");
	Imie_Klienta: constant array (1 .. Ilosc_Klientow) of String(1 .. 6)
		:= ("Damian", "Maciek", "Stefan");

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
		entry Odbierz(Produkt: in Typ_Produkt; Numer: in Integer; Wydajnosc_Produkcji: in Integer);
		-- Zloz zestaw jesli jest wystarczajaco produktow
		entry Skladaj(Zestaw: in Typ_Zestaw; Numer: out Integer);
	end Magazyn;

	P: array ( 1 .. Ilosc_Produktow ) of Producent;
	K: array ( 1 .. Ilosc_Klientow ) of Klient;
	M: Magazyn;

	task body Producent is

		subtype Przedzial_Czasu_Produkcji is Integer range 5 .. 10;

		subtype Przedzial_Wydajnosc_Produkcji is Integer range 1 .. 3;

		package Losuj_Czas_Produkcji is new
			Ada.Numerics.Discrete_Random(Przedzial_Czasu_Produkcji);

		package Losuj_Wydajnosc_Produkcji is new
		Ada.Numerics.Discrete_Random(Przedzial_Wydajnosc_Produkcji);

		GP: Losuj_Czas_Produkcji.Generator;	--  Generator czasu produkcji
		GWP: Losuj_Wydajnosc_Produkcji.Generator; --  Generator wydajnosci produkcji

		Numer_Typu_Produktu: Integer;
		Numer_Produktu: Integer;
		Wydajnosc_Produkcji: Integer;

	begin
		accept Start(Produkt: in Typ_Produkt) do
			Losuj_Czas_Produkcji.Reset(GP);	--  Uruchom generatory
			Losuj_Wydajnosc_Produkcji.Reset(GWP);
			Numer_Produktu := 0;
			Numer_Typu_Produktu := Produkt;
		end Start;

		loop
			delay 1.0;
			Wydajnosc_Produkcji := Losuj_Wydajnosc_Produkcji.Random(GWP);
			Put_Line("[PRODUCENT] Zaczeto produkcje: " & Nazwa_Produktu(Numer_Typu_Produktu));
			delay Duration(Losuj_Czas_Produkcji.Random(GP)); --  Symuluj produkcję
			if Wydajnosc_Produkcji = 2 then
				Put_Line("[PRODUCENT] Wydajnosc produkcji 200%");
			elsif Wydajnosc_Produkcji = 3 then
				Put_Line("[PRODUCENT] Wydajnosc produkcji 300%");
			end if;
			Put_Line("[PRODUCENT] Wyprodukowano: " & Integer'Image(Wydajnosc_Produkcji) & "x " &
			Nazwa_Produktu(Numer_Typu_Produktu) & "  nr "  & Integer'Image(Numer_Produktu));
			delay 10.0;
			-- Dostarcz do magazynu produkt
			loop
				select
					M.Odbierz(Numer_Typu_Produktu, Numer_Produktu, Wydajnosc_Produkcji);
					Numer_Produktu := Numer_Produktu + Wydajnosc_Produkcji;
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

		subtype Przedzial_Czasu_Zamawiania is Integer range 3 .. 6;

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
			delay 1.0;
			Put_Line("[KLIENT] Do sklepu zawital klient: " & Imie_Klienta(ID_Klienta));
			Typ_Zestawu := Losowy_Zestaw.Random(GZ);
			Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & " zastanawia sie...");
			delay Duration(Losuj_Czas_Zamawiania.Random(GCZ)); --  Symuluj zamawianie
			Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & " zamawia zestaw " &
			Nazwa_Zestawow(Typ_Zestawu));
			loop
				select
					M.Skladaj(Typ_Zestawu, Numer_Zestawu);
					if Numer_Zestawu /= 0 then
						Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & " odbiera zestaw " &
								Nazwa_Zestawow(Typ_Zestawu) & " nr " &
								Integer'Image(Numer_Zestawu));
					else
						Put_Line("[KLIENT] " & Imie_Klienta(ID_Klienta) & 
								": Trudno przyjde nastepnym razem!");
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
			:= ((2, 2, 0, 0, 0),(3, 1, 2, 2, 0),(1, 1, 1, 2, 1));

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
				delay 3.0;
				return False;
			end if;

			-- Sprawdz czy ilosc tego produktu nie jest za duza
			if Magazyn(Produkt) >= Max_Zawartosc_Zestawow(Produkt) then
				Put_Line("[STAN] W magazynie jest wystarczajaca ilosc: " 
				& Nazwa_Produktu(Produkt) & ". Towar odeslano!");
				delay 3.0;
				return False;
			end if;

			return True; -- Jest miejsce na ten produkt

		end Moze_Przyjac;

		function Czy_Zlozy(Zestaw: Typ_Zestaw) return Boolean is

		begin
			for W in Typ_Produkt loop
				if Magazyn(W) < Zawartosc_Zestawow(Zestaw, W) then
					return False;
				end if;
			end loop;

			return True;

		end Czy_Zlozy;

		procedure Magazyn_Info is

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
		delay 5.0;
		loop
			select
				accept Odbierz(Produkt: in Typ_Produkt; Numer: in Integer; Wydajnosc_Produkcji: in Integer) do
					if Moze_Przyjac(Produkt) then
						Put_Line("[MAGAZYN] Przyjeto dostawe " & Nazwa_Produktu(Produkt) & " nr " & Integer'Image(Numer));
						Magazyn(Produkt) := Magazyn(Produkt) + Wydajnosc_Produkcji;
						W_Magazynie := W_Magazynie + Wydajnosc_Produkcji;
						Magazyn_Info;
					end if;
				end Odbierz;
			or
				accept Skladaj(Zestaw: in Typ_Zestaw; Numer: out Integer) do
					if Czy_Zlozy(Zestaw) then
						Put_Line("[MAGAZYN] Skladamy zamowiony zestaw " 
						& Nazwa_Zestawow(Zestaw) & " nr "
						& Integer'Image(Ilosc_Zestawu(Zestaw)) 
						& " Potrwa to 5 s...");
						delay 5.0;
						Numer := Ilosc_Zestawu(Zestaw);
						Ilosc_Zestawu(Zestaw) := Ilosc_Zestawu(Zestaw) + 1;
						Put_Line("[MAGAZYN] Zlozono zestaw " & Nazwa_Zestawow(Zestaw) & " nr " &
								Integer'Image(Ilosc_Zestawu(Zestaw)));
						for W in Typ_Produkt loop
							Magazyn(W) := Magazyn(W) - Zawartosc_Zestawow(Zestaw, W);
							W_Magazynie := W_Magazynie - Zawartosc_Zestawow(Zestaw, W);
						end loop;
						Magazyn_Info;
					else
						Put_Line("[MAGAZYN] Przykro nam, brakuje czesci do zamowienia: " & Nazwa_Zestawow(Zestaw));
						Numer := 0;
					end if;
				end Skladaj;
			end select;
		end loop;

	end Magazyn;

begin
	for I in 1 .. Ilosc_Produktow loop
		P(I).Start(I);
	end loop;
	for J in 1 .. Ilosc_Klientow loop
		K(J).Start(J);
	end loop;
	
end Simulation;
