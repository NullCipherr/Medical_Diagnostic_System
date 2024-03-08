%╔══════════════════════════════════════════════════════════════════════╗%
%║                  Alunos                             RA               ║%
%╠══════════════════════════════════════════════════════════════════════╣%
%║       Andrei Roberto da Costa                     107975             ║%
%║       Joao Gilberto Pelisson Casagrande           112684             ║%
%║       Rodrigo Vieira de Vasconcelos               112680             ║%
%╚══════════════════════════════════════════════════════════════════════╝%


%% iniciar_diagnostico is nondet
%
% Inicia o diagnóstico. Carrega os arquivos 'Sintomas.pl' e 'Doenca_Probabilidade.pl', e começa a coleta de sintomas.
iniciar_diagnostico :-
    nl, write('Olá! Vamos começar o diagnóstico. Por favor, informe os sintomas que está sentindo.'), nl,
    coletar_sintomas([]).


%% coletar_sintomas(+Sintomas) is nondet
%
% Coleta os sintomas do usuário até que haja pelo menos 5 sintomas. Se o usuário digitar "fim", termina a coleta e inicia o diagnóstico.
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


%% diagnosticar_doencas(+Sintomas) is nondet
%
% Diagnostica as doenças com base nos sintomas informados. Imprime os sintomas e as possíveis doenças com suas respectivas probabilidades.
diagnosticar_doencas(Sintomas) :-
    nl, write('Os sintomas sentidos sao :'),
    write(Sintomas), nl,
    nl, write('Os possíveis diagnósticos são: '), nl,
    findall((Doenca, Prob), (sintoma(Sintoma, Doenca), member(Sintoma, Sintomas), probabilidade(Doenca, Prob)), Doencas),
    sort(2, @>=, Doencas, DoencasOrdenadas),
    list_to_set(DoencasOrdenadas, DoencasUnicas),
    imprimir_doencas_inverso(DoencasUnicas), nl.


% imprimir_doencas_inverso(+Doencas) is nondet
%
% Imprime as doenças em um formato de lista numerada em ordem inversa.
imprimir_doencas_inverso(Doencas) :-
    reverse(Doencas, DoencasInverso),
    imprimir_doencas(DoencasInverso).


%% imprimir_doencas(+Doencas) is nondet
%
% Imprime as doenças em um formato de lista numerada.
imprimir_doencas([]).
imprimir_doencas([(H, P)|T]) :-
    write('- '), write(H), write(' com probabilidade de '), write(P), write('%'), nl,
    imprimir_doencas(T).


%% list_to_set(+List, -Set) is nondet
%
% Converte uma lista para um conjunto (remove duplicatas).
list_to_set(List, Set) :-
    list_to_set(List, [], Set).

list_to_set([], Set, Set).
list_to_set([H|T], Temp, Set) :-
    (member(H, Temp) ->
        list_to_set(T, Temp, Set)
    ;
        list_to_set(T, [H|Temp], Set)
    ).


% imprimir_sintomas(+Sintomas) is det.
%
% Retorna os sintomas listados na base de conhecimento.
% Definição da função imprimir_sintomas
imprimir_sintomas :-
    setof(Sintoma, Doenca^sintoma(Sintoma, Doenca), Sintomas),
    forall(member(Sintoma, Sintomas), ((write('- '),(write(Sintoma))), nl)).


%% carregar_dependencias is det.
%
% Carrega os arquivos de dependencias, como sintomas, etc.
carregar_dependencias :-
    consult('Sintomas.pl'),
    consult('Doenca_Probabilidade.pl').


%% menu_SDM is nondet.
%
% Menu do Sistema de Diagnóstico Médico. O usuário pode escolher entre diagnosticar um paciente, dar feedback ou voltar.
menu_SDM :-
    carregar_dependencias,
    nl,
    write('=================================='), nl,
    write('   Sistema de Diagnostico Médico  '), nl,
    write('=================================='), nl, nl,

    write(' 1. Diagnosticar Paciente'), nl,
    write(' 2. Listar Sintomas'), nl,
    write(' 3. Feedback'), nl,
    write(' 4. Voltar'), nl,
    nl, nl,

    read(Opcao),
    processar_opcao_SDM(Opcao).


%% processar_opcao_SDM(+Opcao) is nondet
%
% Processa a opção escolhida pelo usuário no menu do Sistema de Diagnóstico Médico.
processar_opcao_SDM(1) :-
    % write('Iniciando Diagnostico...'),
    iniciar_diagnostico,
    menu_SDM.
processar_opcao_SDM(2) :-
    nl, write('Listando todos os sintomas...'), nl, nl,
    imprimir_sintomas,
    menu_SDM.
processar_opcao_SDM(3) :-
    nl, write('Iniciando Feedback...'), nl,
    menu_feedback.
processar_opcao_SDM(4) :-
    nl, write('Voltando para o menu principal...'), nl,
    menu_principal.
processar_opcao_SDM(_) :-
    nl, write('Opcao Invalida!'), nl.


%% menu_feedback is nondet
%
% Inicia o menu de feedback. O usuário pode escolher entre várias opções de feedback.
menu_feedback :-
    nl,
    write('=================================='), nl,
    write('   Sistema de Diagnostico Médico  '), nl,
    write('=================================='), nl, nl,

    write('Por favor, escolha uma das seguintes opções de feedback:'), nl,
    write('1. Por que o paciente tem a doença X?'), nl,
    write('2. Por que foi perguntado se o paciente tem o sintoma A?'), nl,
    write('3. Voltar'), nl, nl,

    read(Opcao),
    processar_opcao_fb(Opcao).


%% processar_opcao_fb(+Opcao) is nondet
%
% Processa a opção de feedback escolhida pelo usuário.

% Feedback: Por que tem a doença X.
processar_opcao_fb(1) :-
    nl, write('Por favor, insira a doença X: '), nl,
    read(Doenca),
    por_que_tem(Doenca),
    menu_feedback.

% Feedback: Por que foi perguntado se o paciente tem o sintoma A.
processar_opcao_fb(2) :-
    nl, write('Por favor, insira o sintoma A: '), nl,
    read(Sintoma),
    por_que_perguntou(Sintoma),
    menu_feedback.

% Voltar ao menu do sistema de diagnostico medico.
processar_opcao_fb(3) :-
    menu_SDM.

% Opcao Invalida.
processar_opcao_fb(_) :-
    nl, write('Opção inválida. Por favor, escolha uma opção de 1 a 4.'), nl,
    menu_feedback.

% por_que_tem(+Doenca) is det.
%
% Retorna o motivo de ter a doenca X.
por_que_tem(Doenca) :-
    findall(Sintoma, sintoma(Sintoma, Doenca), Sintomas),
    nl, write('O paciente foi diagnosticado com '), write(Doenca), write(' porque ele relatou alguns dos seguintes sintomas: '), write(Sintomas), nl.


% por_que_perguntou(+Sintoma)
%
% Retorna as doencas relacionadas aos sintomas.
por_que_perguntou(Sintoma) :-
    findall(Doenca, sintoma(Sintoma, Doenca), Doencas),
    nl, write('Foi perguntado se o paciente tem '), write(Sintoma), write(' porque este sintoma está associado às seguintes doenças: '), write(Doencas), nl.
