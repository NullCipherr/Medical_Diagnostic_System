%╔══════════════════════════════════════════════════════════════════════╗%
%║                  Alunos                             RA               ║%
%╠══════════════════════════════════════════════════════════════════════╣%
%║       Andrei Roberto da Costa                     107975             ║%
%║       Joao Gilberto Pelisson Casagrande                              ║%
%║       Rodrigo Vieira de Vasconcellos                                 ║%
%╚══════════════════════════════════════════════════════════════════════╝%

% Inicia o diagnostico.
iniciar_diagnostico :-
    consult('Sintomas.pl'),
    consult('Doenca_Probabilidade.pl'),

    nl, write('Olá! Vamos começar o diagnóstico. Por favor, informe os sintomas que está sentindo.'), nl,
    coletar_sintomas([]).

% Coleta os sintomas do usuário
coletar_sintomas(Sintomas) :-
    length(Sintomas, NumSintomas),
    (NumSintomas >= 5 ->
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
    nl, write('Os sintomas sentidos sao :'),
    write(Sintomas), nl,

    nl, write('Os possíveis diagnósticos são: '), nl,
    findall((Doenca, Prob), (sintoma(Sintoma, Doenca), member(Sintoma, Sintomas), probabilidade(Doenca, Prob), Prob >= 0.1), Doencas),
    sort(2, @>=, Doencas, DoencasOrdenadas),
    list_to_set(DoencasOrdenadas, DoencasUnicas),
    imprimir_doencas(DoencasUnicas), nl,
    menu_SDM.

% Imprime as doenças em um formato de lista numerada
imprimir_doencas([]).
imprimir_doencas([(H, P)|T]) :-
    write('- '), write(H), write(' com probabilidade de '), write(P), nl,
    imprimir_doencas(T).

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



% Menu de Sistema de Diagnostico Medico
menu_SDM :-
    nl,
    write('=================================='), nl,
    write('   Sistema de Diagnostico Médico  '), nl,
    write('=================================='), nl, nl,

    write(' 1. Diagnosticar Paciente'), nl,
    write(' 2. Feedback'), nl, nl,
    write(' 3. Voltar'), nl,
    nl, nl,
    % write(' -> '),
    read(Opcao),
    processar_opcao_SDM(Opcao).

% Opcoes de selecao do sistema de diagnostico medico
processar_opcao_SDM(1) :-
    % write('Iniciando Diagnostico...'),
    iniciar_diagnostico.
processar_opcao_SDM(2) :-
    % write('Iniciando Feedback...'),
    menu_feedback.
processar_opcao_SDM(3) :-
    %write('Voltando para o menu principal...')
    menu_principal.



% Feedback
% Inicia o menu de feedback
menu_feedback :-
    nl,
    write('=================================='), nl,
    write('   Sistema de Diagnostico Médico  '), nl,
    write('=================================='), nl, nl,

    write('Por favor, escolha uma das seguintes opções de feedback:'), nl,
    write('1. Por que o paciente tem a doença X?'), nl,
    write('2. Por que o paciente não tem a doença Y, ao invés da X?'), nl,
    write('3. Por que foi perguntado se o paciente tem o sintoma A?'), nl,
    write('4. Voltar'), nl, nl,

    read(Opcao),
    processar_opcao_fb(Opcao).


% Processa a opção escolhida pelo usuário
processar_opcao_fb(1) :-
    nl, write('Por favor, insira a doença X: '), nl,
    read(Doenca),
    por_que_tem(Doenca),
    menu_feedback.

%
processar_opcao_fb(2) :-
    nl, write('Por favor, insira a doença Y: '), nl,
    read(DoencaY),
    write('Por favor, insira a doença X: '), nl,
    read(DoencaX),
    write('Por favor, insira os sintomas relatados pelo paciente (em formato de lista): '), nl,
    read(Sintomas),
    por_que_nao_tem(DoencaY, DoencaX, Sintomas),
    menu_feedback .
%
processar_opcao_fb(3) :-
    nl, write('Por favor, insira o sintoma A: '), nl,
    read(Sintoma),
    por_que_perguntou(Sintoma),
    menu_feedback.

%
processar_opcao_fb(4) :-
    menu_SDM.

%
processar_opcao_fb(_) :-
    nl, write('Opção inválida. Por favor, escolha uma opção de 1 a 4.'), nl,
    menu_feedback.


%
por_que_tem(Doenca) :-
    findall(Sintoma, sintoma(Sintoma, Doenca), Sintomas),
    write('O paciente foi diagnosticado com '), write(Doenca), write(' porque ele relatou alguns dos seguintes sintomas: '), write(Sintomas), nl.


%
por_que_nao_tem(Doenca, SintomasReportados) :-
    findall(Sintoma, sintoma(Sintoma, Doenca), Sintomas),
    subtract(Sintomas, SintomasReportados, SintomasFaltantes),
    write('O paciente não foi diagnosticado com '), write(Doenca), write(' porque ele não relatou os seguintes sintomas: '), write(SintomasFaltantes), nl.

%
por_que_perguntou(Sintoma) :-
    findall(Doenca, sintoma(Sintoma, Doenca), Doencas),
    write('Foi perguntado se o paciente tem '), write(Sintoma), write(' porque este sintoma está associado às seguintes doenças: '), write(Doencas), nl.
