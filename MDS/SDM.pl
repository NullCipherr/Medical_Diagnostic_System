% sintoma(sintoma, doenca)
%  Facilita na manipulação dos sintomas individualmente ao invés da
%  estrutura: doenca(doenca, [Sintoma1, Sintoma2, ...]), que tornaria
%  mais complexo essa manipulacao.

% Base de conhecimento de 'sintoma'.
consult('Sintomas.pl').


iniciar_diagnostico :-
    nl, write('Olá! Vamos começar o diagnóstico. Por favor, informe os sintomas que está sentindo.'), nl,
    coletar_sintomas([]).

% Coleta os sintomas do usuário
coletar_sintomas(Sintomas) :-
    %write('Os sintomas sao:'),
    %write(Sintomas),
    length(Sintomas, NumSintomas),
    (NumSintomas >= 3 ->
        diagnosticar_doencas(Sintomas)
    ;
        write('Por favor, insira um sintoma ou digite "fim" para terminar: '), nl,
        read(Sintoma),
        (Sintoma == fim ->
            diagnosticar_doencas(Sintomas)
        ;
            coletar_sintomas([Sintoma|Sintomas])
        )
    ).


% Diagnostica as doenças com base nos sintomas
diagnosticar_doencas(Sintomas) :-
    write('Os sintomas sentidos sao :'),
    write(Sintomas), nl,
    write('Os possíveis diagnósticos são: '), nl,
    findall(Doenca, (sintoma(Sintoma, Doenca), member(Sintoma, Sintomas)), Doencas),
    list_to_set(Doencas, DoencasUnicas),
    write(DoencasUnicas), nl.

% Converte uma lista para um conjunto (remove duplicatas)
list_to_set(List, Set) :-
    list_to_set(List, [], Set).

list_to_set([], Set, Set).
list_to_set([H|T], Temp, Set) :-
    (member(H, Temp) ->
        list_to_set(T, Temp, Set)
    ;
        list_to_set(T, [H|Temp], Set)
    ).

doencas_associadas(Sintoma, Doencas) :-
    findall(Doenca, sintoma(Sintoma, Doenca), Doencas).
