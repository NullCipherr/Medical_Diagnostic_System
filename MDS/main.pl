start :-
    nl, write('Carregando Sistema de Diagnostico Médico...'), nl,
    consult('SDM.pl'),
    write('Carregando Sistema de Controle de Pacientes...'), nl,
    consult('SCP.pl'),
    menu_principal.

% Menu de Selecao de Sistemas
% Menu Principal
menu_principal :-
    nl,
    write('=================================='), nl,
    write('      Sistema  Clinico v.0.1      '), nl,
    write('=================================='), nl, nl,

    write(' 1. Sistema de Diagnostico Médico'), nl,
    write(' 2. Sistema de Controle de Pacientes'), nl, nl,
    write(' 3. Sair'), nl, nl, nl,
    read(Opcao),
    processar_opcao_menu(Opcao).

% Opcoes de selecao do menu principal.
processar_opcao_menu(1) :-
    menu_SDM.
processar_opcao_menu(2) :-
    menu_SCP.
processar_opcao_menu(3) :-
    nl, write('Saindo...'), nl, nl.











