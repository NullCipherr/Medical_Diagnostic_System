
% Carregar pacientes do arquivo
carregar_pacientes :-
    exists_file('pacientes.txt'), !,
    open('pacientes.txt', read, Str),
    read_pacientes(Str, _),
    close(Str).
carregar_pacientes.

% Ler pacientes do arquivo
read_pacientes(Stream,[]) :-
    at_end_of_stream(Stream), !.
read_pacientes(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    assertz(X),
    read_pacientes(Stream,L).

% Salvar pacientes no arquivo
salvar_pacientes :-
    open('pacientes.txt', write, Str),
    forall(paciente(Id, Nome, Diagnostico),
           writeq(Str, paciente(Id, Nome, Diagnostico))),
    close(Str).

% Consultar paciente
consultar_paciente(Id, Nome, Diagnostico) :-
    paciente(Id, Nome, Diagnostico).

% Incluir paciente
incluir_paciente(Id, Nome, Diagnostico) :-
    % Certifique-se de que Nome e Diagnostico são instanciados
    nonvar(Nome),
    nonvar(Diagnostico),
    assertz(paciente(Id, Nome, Diagnostico)),
    salvar_pacientes.

% Alterar paciente
alterar_paciente(Id, Nome, Diagnostico) :-
    retract(paciente(Id, _, _)),
    assertz(paciente(Id, Nome, Diagnostico)),
    salvar_pacientes.

% Excluir paciente
excluir_paciente(Id) :-
    retract(paciente(Id, _, _)),
    salvar_pacientes.

% Listar todos os pacientes
listar_pacientes :-
    write('Listando os pacientes ...'), nl, nl,
    write('======================================='), nl,
    write('   ID  |   NOME  |      DIAGNOSTICO    '), nl,
    write('======================================='), nl,

    forall(paciente(Id, Nome, Diagnostico),
    (
               write('    '),write(Id), write('     '),write(Nome),write('       '), write(Diagnostico), nl, nl)
    ),

    write('Listagem realizada com sucesso!!'), nl, nl.

% Remover pacientes duplicados
remover_duplicados :-
    findall(paciente(Id, Nome, Diagnostico), paciente(Id, Nome, Diagnostico), Pacientes),
    sort(Pacientes, PacientesUnicos),
    retractall(paciente(_, _, _)),
    forall(member(Paciente, PacientesUnicos), assertz(Paciente)),
    salvar_pacientes.


% Menu principal
menu :-
    nl,
    write('=================================='), nl,
    write(' Sistema de Controle de Pacientes'), nl,
    write('=================================='), nl, nl,

    write(' 1. Consultar paciente'), nl,
    write(' 2. Incluir paciente'), nl,
    write(' 3. Alterar paciente'), nl,
    write(' 4. Excluir paciente'), nl,
    write(' 5. Listar pacientes'), nl,
    write(' 6. Sair'), nl,
    nl, nl,
    write(' -> '),
    read(Opcao),
    processar_opcao(Opcao).

% Processar opção do menu
processar_opcao(1) :-
    nl,
    write('================================'), nl,
    write(' Selecionado=Consultar Paciente'), nl,
    write('================================'), nl, nl,
    write(' Digite o ID do paciente '),
    read(Id),
    (consultar_paciente(Id, Nome, Diagnostico) ->
        nl, write(Nome), write(' - '), write(Diagnostico), nl
    ;
        nl, write('Paciente não encontrado!!'), nl
    ),

    % nl, write('Pressione [ENTER] para continuar'),
    % read(_),
    menu.
processar_opcao(2) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Incluir Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID do paciente: '), read(Id),
    write('Nome do paciente: '), read(Nome),
    write('Diagnóstico do paciente: '), read(Diagnostico),
    incluir_paciente(Id, Nome, Diagnostico),
    menu.
processar_opcao(3) :-
    nl,
    write('==============================='), nl,
    write(' Selecionado=Alterar Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID do paciente: '), read(Id),
    write('[REPLACE]Nome do paciente: '), read(Nome),
    write('[REPLACE]Diagnóstico do paciente: '), read(Diagnostico),
    alterar_paciente(Id, Nome, Diagnostico),
    menu.
processar_opcao(4) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Excluir Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID do paciente: '), read(Id),
    excluir_paciente(Id),
    menu.
processar_opcao(5) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Listar Pacientes'), nl,
    write('=============================='), nl, nl,
    listar_pacientes,
    menu.
processar_opcao(6) :-
    nl,
    write('Saindo ...'),
    nl, nl.
processar_opcao(_) :-
    write('Opção inválida'), nl,
    menu.





% Testes unitários
:- begin_tests(pacientes).

test(incluir_paciente) :-
    retractall(paciente(_, _, _)),  % Limpa a base de conhecimento
    incluir_paciente(1, 'João', 'Gripe'),
    paciente(1, 'João', 'Gripe').

test(alterar_paciente) :-
    retractall(paciente(_, _, _)),  % Limpa a base de conhecimento
    incluir_paciente(2, 'Maria', 'Resfriado'),
    alterar_paciente(2, 'Maria', 'Gripe'),
    paciente(2, 'Maria', 'Gripe').

test(excluir_paciente) :-
    retractall(paciente(_, _, _)),  % Limpa a base de conhecimento
    incluir_paciente(3, 'Pedro', 'Gripe'),
    excluir_paciente(3),
    \+ paciente(3, _, _).

:- end_tests(pacientes).






% Função main
main :-
    % remover_duplicados,
    write('Executando testes unitários...'), nl,
    run_tests,
    write('Testes concluídos.'), nl, nl,
    menu.

