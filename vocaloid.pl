%VOCALOID

%vocaloid(Nombre,Cancion).
vocaloid(megurineLuka,nightFever).
vocaloid(megurineLuka,foreverYoung).
vocaloid(hatsuneMiku,tellYourWorld).
vocaloid(gumi,foreverYoung).
vocaloid(gumi,tellYourWorld).
vocaloid(seeU,novemberRain).
vocaloid(seeU,nightFever).

%cancion(Nombre,Duracion).
cancion(nightFever,4).
cancion(foreverYoung,5).
cancion(tellYourWorld,4).
cancion(novemberRain,6).
cancion(nightFever,5).

%concierto(Concierto,Pais,Fama,Tipo).
%	gigante(CantMinimaCanciones,TiempoMinimo).
%	mediano(DuracionMaxima).
%	pequenio(DuracionMinima).
concierto(mikuExpo,estadosUnidos,2000,gigante(3,6)).
concierto(magicalMirai,japon,3000,gigante(4,10)).
concierto(vocalektVisions,estadosUnidos,1000,mediano(9)).
concierto(mikuFest,argentina,100,pequenio(4)).

conoceA(megurineLuka,hatsuneMiku).
conoceA(megurineLuka,gumi).
conoceA(gumi,seeU).
conoceA(seeU,kaito).

%PUNTOA1
novedoso(Vocaloid):-
	sabeDosCanciones(Vocaloid),
	tiempoTotalCanciones(Vocaloid,DuracionTotal),
	DuracionTotal<15.

sabeDosCanciones(Vocaloid):-
	vocaloid(Vocaloid,Cancion1),
	vocaloid(Vocaloid,Cancion2),
	Cancion1\=Cancion2.

tiempoTotalCanciones(Vocaloid,DuracionTotal):-
	findall(Duracion,duracionCancion(Vocaloid,Duracion),ListaDuraciones),
	sumlist(ListaDuraciones,DuracionTotal).

duracionCancion(Vocaloid,Duracion):-
	vocaloid(Vocaloid,Cancion),
	cancion(Cancion,Duracion).

%PUNTOA2
acelerado(Vocaloid):-
	vocaloid(Vocaloid,_),
	not((duracionCancion(Vocaloid,Duracion),Duracion>4)).

%PUNTOB2
puedeParticipar(hatsuneMiku,Concierto):-
	concierto(Concierto,_,_,_).     %solamente si el concierto existe
puedeParticipar(Vocaloid,Concierto):-
	vocaloid(Vocaloid,_),
	concierto(Concierto,_,_,Tipo),
	condicion(Vocaloid,Tipo).

condicion(Vocaloid,gigante(CantMinimaCanciones,TiempoMinimo)):-
	cuantasCancionesCanta(Vocaloid,CantCanciones),
	tiempoTotalCanciones(Vocaloid,DuracionTotal),
	CantMinimaCanciones=<CantCanciones,
	TiempoMinimo=<DuracionTotal.
condicion(Vocaloid,mediano(DuracionMax)):-
	tiempoTotalCanciones(Vocaloid,DuracionTotal),
	DuracionTotal<DuracionMax.
condicion(Vocaloid,pequenio(DuracionMinima)):-
	duracionCancion(Vocaloid,Duracion),
	Duracion>DuracionMinima.

cuantasCancionesCanta(Vocaloid,CantCanciones):-
	findall(Cancion,vocaloid(Vocaloid,Cancion),ListaCanciones),
	length(ListaCanciones,CantCanciones).	

%PUNTOB3
masFamoso(Vocaloid):-
	nivelFama(Vocaloid,Fama),
	forall((nivelFama(Vocaloid2,Fama2),Vocaloid\=Vocaloid2),Fama>Fama2).   %QUE ONDA ACA en la resolucion no diferencia entre vocaloids

nivelFama(Vocaloid,Fama):-
	fama(Vocaloid,FamaTotal),
 	cuantasCancionesCanta(Vocaloid,CantCanciones),
	Fama is FamaTotal*CantCanciones.
	
fama(Vocaloid,FamaTotal):-
	vocaloid(Vocaloid,_),
	findall(Fama,(puedeParticipar(Vocaloid,Concierto),concierto(Concierto,_,Fama,_)),ListaFama),
	sumlist(ListaFama,FamaTotal).

%PUNTOB4   resolucion distinta al resuelto de pag de pdep
unicoQueParticipa(Vocaloid,Concierto):-
	puedeParticipar(Vocaloid,Concierto),
	noParticipanConocidos(Vocaloid,Concierto).

noParticipanConocidos(Vocaloid,Concierto):-
	forall(todosLosConocidos(Vocaloid,Conocido),not(puedeParticipar(Conocido,Concierto))).

todosLosConocidos(Vocaloid,Conocido):-
	conoceA(Vocaloid,Conocido).
todosLosConocidos(Vocaloid,Conocido):-
	conoceA(Vocaloid,Conocido),
	todosLosConocidos(Conocido,_).