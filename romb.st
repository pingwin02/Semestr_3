"Damian Jankowski s188597"
"Romb i wysrodkuj"

Object subclass: #Wielokat
	instanceVariableNames: 'wierzcholki nazwa'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Wielokat methodsFor: 'initialize-release'!

initialize: liczbaWierzcholkow name: nowaNazwa
	"konstruktor obiektu - wielokata"

	nazwa := nowaNazwa.
	wierzcholki := Array new: liczbaWierzcholkow.
	wierzcholki at: 1 put: 0@0.! !

!Wielokat methodsFor: 'accessing'!

nazwa
	"podaje nazwe wielokata"

	^nazwa!

nazwa: nowa_nazwa
	"ustawia nowa nazwe wielokata"

	nazwa:=nowa_nazwa ! !
	
!Wielokat methodsFor: 'actions' !

drukuj
    Transcript cr; show: 'Dana jest figura: '; show: nazwa; cr. 
    1 to: wierzcholki size do:
    [:i | 
		Transcript show: 'Wierzcholek '; 
		show: i printString; show: ':	';
		show: ((wierzcholki at: i) x roundTo: 0.0001) printString;
		show: ' @ ';
		show: ((wierzcholki at: i) y roundTo: 0.0001) printString; cr.
	].
	Transcript show: 'Pole = '; 
	show: (self pole roundTo: 0.0001) printString; 
	cr. ! !
	
Wielokat subclass: #Romb

	instanceVariableNames: 'bok kat'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Romb methodsFor: 'arithmetic'!

+ figura
	"dodaj 2 figury w sensie pola"

	| p |

	p:=(self pole + figura pole).
	^(Romb new) initialize: (p / (kat sin)) sqrt 
			kat: kat * 180 / (Float pi) ! !

!Romb methodsFor: 'actions'!

pole
	"licz pole rombu"

	^bok squared * (kat sin) ! 
	
wysrodkuj

	| xsr ysr |
	
	Transcript cr; show: 'Wysrodkuje figure: '; show: nazwa; cr.

	"Wyznaczenie miejsca przeciecia sie przekatnych"
	xsr := 0.
	ysr := 0.

	1 to: wierzcholki size do:
	[:i |
		xsr := xsr + ((wierzcholki at: i) x).
		ysr := ysr + ((wierzcholki at: i) y).
	].

	xsr := xsr/(wierzcholki size).
	ysr := ysr/(wierzcholki size).
	
	Transcript show: 'Srodek figury znajduje sie w punkcie: ';
	show: (xsr roundTo: 0.0001) printString; 
	show: ' @ '; show: (ysr roundTo: 0.0001) printString.
	
	"Wysrodkowanie"

	1 to: wierzcholki size do:
	[:i |
		wierzcholki at: i put: 
		((wierzcholki at: i) x - xsr) @ ((wierzcholki at: i) y - ysr).
	]. ! !

!Romb methodsFor: 'initialize-release'!

initialize: nowybok kat: nowykat
	"tworz romb o podanym boku i kacie"

	| wys offset |

	super initialize: 4 name: 'Romb'.
	bok := nowybok.
	kat := nowykat * (Float pi) / 180.
	wys := bok*(kat sin).
	offset := bok*(kat cos).
	wierzcholki at: 2 put: bok@0.
	wierzcholki at: 3 put: (offset + bok)@wys.
	wierzcholki at: 4 put: offset@wys. ! !

Romb subclass: #Kwadrat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Kwadrat methodsFor: 'arithmetic'!

+ figura
	"dodaj 2 figury w sensie pola"

	| p |

	p:=(self pole + figura pole).
	^(Kwadrat new) initialize: p sqrt. ! !

!Kwadrat methodsFor: 'actions'!

pole
	"licz pole kwadratu"

	^bok squared! !

!Kwadrat methodsFor: 'initialize-release'!

initialize: nowybok
	"tworz kwadrat o podanym boku"
	"kwadrat jest rombem o kacie 90 stopni"

	super initialize: nowybok kat: 90.
	self nazwa: 'Kwadrat'.
	bok := nowybok.
	wierzcholki at: 2 put: bok@0.
	wierzcholki at: 3 put: bok@bok.
	wierzcholki at: 4 put: 0@bok.! !

k := (Kwadrat new) initialize: 5.
t := (Romb new) initialize: 2 kat: 30.

Transcript show: 'Dane sa wielokaty :'; cr.
k drukuj.
t drukuj.

Transcript cr ; show: 't+k'.
t1 := t + k.
t1 drukuj.

Transcript cr ; show: 'k+t'.
k1 := k + t.
k1 drukuj.

Transcript cr ; show: 'k+k'.
k1 := k + k.
k1 drukuj.

Transcript cr ; show: 't+t'.
t1 := t + t.
t1 drukuj.

k2 := k wysrodkuj.
k2 drukuj.

t2 := t wysrodkuj.
t2 drukuj.