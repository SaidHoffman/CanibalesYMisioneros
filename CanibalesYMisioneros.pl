% Base de conocimiento
misionero(m1).
misionero(m2).
misionero(m3).
canibal(c1).
canibal(c2).
canibal(c3).
balsa(b).
orilla(orilla_origen).
orilla(orilla_destino).

% Estado inicial
estado_inicial(estado(3,3,0,0,orilla_origen)).
meta(estado(0,0,3,3,orilla_destino)).

% Predicados básicos
puede_cruzar(1,0).
puede_cruzar(2,0).
puede_cruzar(1,1).
puede_cruzar(0,1).
puede_cruzar(0,2).

% Verificar seguridad
es_seguro(estado(MI,CI,MD,CD,_)) :-
    MI >= 0, CI >= 0, MD >= 0, CD >= 0,
    (MI >= CI ; MI = 0),
    (MD >= CD ; MD = 0).

% Mover
mover(estado(MI,CI,MD,CD,orilla_origen), M, C,
      estado(MI2,CI2,MD2,CD2,orilla_destino)) :-
    puede_cruzar(M,C),
    MI2 is MI-M, CI2 is CI-C,
    MD2 is MD+M, CD2 is CD+C,
    es_seguro(estado(MI2,CI2,MD2,CD2,orilla_destino)).

mover(estado(MI,CI,MD,CD,orilla_destino), M, C,
      estado(MI2,CI2,MD2,CD2,orilla_origen)) :-
    puede_cruzar(M,C),
    MI2 is MI+M, CI2 is CI+C,
    MD2 is MD-M, CD2 is CD-C,
    es_seguro(estado(MI2,CI2,MD2,CD2,orilla_origen)).

% Jugar
jugar :-
    estado_inicial(Estado),
    mostrar_estado(Estado),
    jugar(Estado).

jugar(Estado) :-
    meta(Estado),
    write('¡Felicidades! Has ganado el juego.\n'), !.

jugar(Estado) :-
    write('Ingresa el número de misioneros a mover (0-2): '),
    read(M),
    write('Ingresa el número de caníbales a mover (0-2): '),
    read(C),
    (mover(Estado, M, C, NuevoEstado) ->
        mostrar_estado(NuevoEstado),
        jugar(NuevoEstado)
    ;
        write('Movimiento inválido. Intenta de nuevo.\n'),
        jugar(Estado)
    ).

% Mostrar estado
mostrar_estado(estado(MI,CI,MD,CD,Orilla)) :-
    write('Estado actual:\n'),
    format('Orilla Origen: ~w misioneros, ~w caníbales\n', [MI,CI]),
    format('Orilla Destino: ~w misioneros, ~w caníbales\n', [MD,CD]),
    format('Balsa en: ~w\n\n', [Orilla]).

% Iniciar juego
:- write('Bienvenido al juego de Misioneros y Caníbales!\n'),
   write('Para jugar, escribe "jugar." y presiona Enter.\n').