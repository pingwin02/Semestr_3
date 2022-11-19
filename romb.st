"Damian Jankowski s188597"
"Romb i wysrodkuj"

Object subclass: #Wielokat
	instanceVariableNames: 'wierzcholki nazwa liczbaW'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Wielokat methodsFor: 'initialize-release'!

initialize: liczbaWierzcholkow name: nowaNazwa
	"konstruktor obiektu - wielokata"

	nazwa := nowaNazwa.
	liczbaW := liczbaWierzcholkow.
	wierzcholki := Array new: liczbaW.
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
    Transcript show: 'Dana jest figura: '; show: nazwa; cr. 
    1 to: liczbaW do:
    [:i | 
		Transcript show: 'Wierzcholek '; 
		show: i printString; show: ':	';
		show: (wierzcholki at: i) x printString;
		show: ' @ ';
		show: (wierzcholki at: i) y printString; cr.
	].
	Transcript show: 'Pole = '; show: self pole printString; cr; cr. ! !

Wielokat subclass: #Kwadrat
	instanceVariableNames: 'bok'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Kwadrat methodsFor: 'arithmetic'!

+ figura
	"dodaj 2 figury w sensie pola"

	| p |

	p:=(self pole + figura pole) * 1e.
	^(Kwadrat new) initialize: p sqrt. ! !

!Kwadrat methodsFor: 'actions'!

pole
	"licz pole kwadratu"

	^bok squared! !

!Kwadrat methodsFor: 'initialize-release'!

initialize: nowybok
	"tworz kwadrat o podanym boku"

	super initialize: 4 name: 'Kwadrat'.
	bok := nowybok.
	wierzcholki at: 2 put: bok@0.
	wierzcholki at: 3 put: bok@bok.
	wierzcholki at: 4 put: 0@bok.! !


Wielokat subclass: #Romb

	instanceVariableNames: 'bok kat'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JezykiProgramowania'!

!Romb methodsFor: 'arithmetic'!

+ figura
	"dodaj 2 figury w sensie pola"

	| p |

	p:=(self pole + figura pole) * 1e.
	^(Romb new) initialize: (p / (kat sin)) sqrt 
			kat: kat * 180 / (Float pi) ! !

!Romb methodsFor: 'actions'!

pole
	"licz pole rombu"

	^bok squared * (kat sin) ! 
	
wysrodkuj

	| xsr ysr |

	"Wyznaczenie miejsca przeciecia sie przekatnych"
	xsr := 0.
	ysr := 0.

	1 to: liczbaW do:
	[:i |
		xsr := xsr + ((wierzcholki at: i) x).
		ysr := ysr + ((wierzcholki at: i) y).
	].

	xsr := xsr/liczbaW.
	ysr := ysr/liczbaW.

	"Wysrodkowanie"

	1 to: liczbaW do:
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
	
"TESTY"

Transcript show: 'Dane sa figury:'; cr; cr.

Transcript show: 't:'; cr.
t := (Kwadrat new) initialize: 5.
t drukuj.

Transcript show: 'r:'; cr.
r := (Romb new) initialize: 3 kat: 30.
r drukuj.

Transcript show: 'd:'; cr.
d := (Romb new) initialize: 2 kat: 15.
d drukuj.

Transcript show: 'd+d+d:'; cr.
d2 := d+d+d.
d2 drukuj.

Transcript show: 'd+r:'; cr.
d1 := d+r.
d1 drukuj.

Transcript show: 'r+d:'; cr.
r1 := r+d.
r1 drukuj.

Transcript show: 'wysrodkuj r+d:'; cr.
r1 wysrodkuj.
r1 drukuj.

Transcript show: 'd+r+t:'; cr.
combo := d+r+t.
combo drukuj.

Transcript show: 'wysrodkuj d+r+t:'; cr.
combo wysrodkuj.
combo drukuj.
