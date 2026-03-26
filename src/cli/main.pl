%% menu_principal
%
%  Exibe o menu principal do sistema clínico.
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


%% processar_opcao_menu(+Opcao)
%
%  Processa a opção escolhida no menu principal.
processar_opcao_menu(1) :-
    menu_SDM.
processar_opcao_menu(2) :-
    menu_SCP.
processar_opcao_menu(3) :-
    nl, write('Saindo...'), nl, nl.


%% start
%
%  Inicia o sistema clínico.
start :-
    nl, write('Carregando Sistema de Diagnostico Médico...'), nl,
    caminho_relativo_main('../diagnosis/sdm.pl', ModuloSDM),
    consult(ModuloSDM),
    write('Carregando Sistema de Controle de Pacientes...'), nl,
    caminho_relativo_main('../patients/scp.pl', ModuloSCP),
    consult(ModuloSCP),
    write('Verificando pacientes.txt...'), nl,
    verificar_paciente,
    menu_principal.






:- dynamic main_base_dir/1.
:- prolog_load_context(directory, MAIN_DIR), asserta(main_base_dir(MAIN_DIR)).

%% caminho_relativo_main(+Relativo, -Absoluto) is det.
%
%  Resolve caminhos relativos a partir de src/cli.
caminho_relativo_main(Relativo, Absoluto) :-
    main_base_dir(Base),
    directory_file_path(Base, Relativo, Absoluto).
