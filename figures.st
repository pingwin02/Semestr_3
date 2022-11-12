Object subclass: #Wielokat
	instanceVariableNames: 'wierzcholki nazwa dlugoscBoku'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Wielokat methodsFor: 'initialize-release'!

initialize: liczbaWierzcholkow name: nowaNazwa
	nazwa := nowaNazwa.
	wierzcholki := Array new: liczbaWierzcholkow.
	wierzcholki at: 1 put: 0@0.
	dlugoscBoku := liczbaWierzcholkow.!!

!Wielokat methodsFor: 'accessing'!

nazwa
	^nazwa!

wierzcholki	
	^wierzcholki!
	
dlugoscBoku
	^dlugoscBoku!

nazwa: nowa_nazwa
	nazwa := nowa_nazwa!!

Wielokat subclass: #Kwadrat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Kwadrat methodsFor: 'arithmetic'!

+ figura
	| p |
	p := self pole + figura pole.
	^(Kwadrat new) initialize: p sqrt !

obroc
	| k2 x y |
	k2 := (Kwadrat new) initialize: self dlugoscBoku.
	1 to: wierzcholki size do: [:i |
	x := (wierzcholki at: i) x.
	y := (wierzcholki at: i) y.
	k2 wierzcholki at: i put: (-1)*y@x.
	].
	^k2!!

!Kwadrat methodsFor: 'actions'!

pole
	^((wierzcholki at: 2) x - (wierzcholki at: 1) x) squared !
	
drukuj
    ^Transcript
        show: 'p1: '; show: (wierzcholki at: 1) printString; cr;
        show: 'p2: '; show: (wierzcholki at: 2) printString; cr;
        show: 'p3: '; show: (wierzcholki at: 3) printString; cr;
        show: 'p4: '; show: (wierzcholki at: 4) printString; cr;
		show: 'dlugosc boku: '; show: (self dlugoscBoku) printString ; cr;
        show: 'pole: '; show: (self pole) printString; cr.!!

!Kwadrat methodsFor: 'initialize-release'!

initialize: bok
	super initialize: 4 name: 'Kwadrat'.
	wierzcholki at: 2 put: bok@0.
	wierzcholki at: 3 put: bok@bok.
	wierzcholki at: 4 put: 0@bok.
	dlugoscBoku := bok!!

Wielokat subclass: #Romb
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Romb methodsFor: 'arithmetic'!

+ figura
	| p a |
	p := self pole + figura pole.
	p := (p / (3.0e0 sqrt / 2.0e0)) sqrt.
	^(Romb new) initialize: p!

obroc
	| r2 x y |
	r2 := (Romb new) initialize: self dlugoscBoku.
	1 to: wierzcholki size do: [:i |
	x := (wierzcholki at: i) x.
	y := (wierzcholki at: i) y.
	r2 wierzcholki at: i put: (-1)*y@x.
	].
	^r2!!

!Romb methodsFor: 'actions'!

pole
	| p |
	p := 3.0e0 sqrt / 2.0e0 * (self dlugoscBoku).
	^p!

drukuj
	^Transcript
        show: 'p1: '; show: (wierzcholki at: 1) printString; cr;
        show: 'p2: '; show: (wierzcholki at: 2) printString; cr;
		show: 'p3: '; show: (wierzcholki at: 3) printString; cr;
		show: 'p4: '; show: (wierzcholki at: 4) printString; cr;
		show: 'dlugosc boku: '; show: (self dlugoscBoku) printString ; cr;
		show: 'pole: '; show: (self pole) printString; cr.!!

!Romb methodsFor: 'initialize-release'!

initialize: bok
	| h przes |
	h := 3.0e0 sqrt / 2.0e0 * bok.	"wysokosc"
	przes := bok / 2.0e0.			"przesuniecie"
	super initialize: 4 name: 'Romb'.
	wierzcholki at: 2 put: bok@0.
	wierzcholki at: 3 put: bok+przes@h.
	wierzcholki at: 4 put: przes@h.
	dlugoscBoku := bok.!!
"
k := (Kwadrat new) initialize: 2.
k drukuj.
r := (Romb new) initialize: 2.
r drukuj.
Transcript show: 'obrocenie'; cr.
r1 := r obroc.
r1 drukuj.
r1 := r1 obroc.
r1 drukuj.
Transcript show: 'r+r'; cr.
r1 := r + r.
r1 drukuj.
Transcript show: 'r+k'; cr.
r1 := r + k.
r1 drukuj."

Transcript show: 'TESTY PANA DACIUKA'; cr.
r := (Romb new) initialize: 4.
r drukuj.
k := (Kwadrat new) initialize: 2.
k drukuj.
Transcript show: 'r+r'; cr.
r1 := r obroc.
r1 drukuj.
r1 := r1 obroc.
r1 drukuj.
r1 := r1 obroc.
r1 drukuj.
r2 := r1 + r1 + r1 + r1.
r2 drukuj.
Transcript show: 'r+k'; cr.
k1 := k obroc.
r2 := r1 + k.
r2 drukuj.
Transcript show: 'k+r'; cr.
k2 := k1 + r1.
k2 drukuj.