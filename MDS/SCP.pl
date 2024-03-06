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
    forall(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
           writeq(Str, paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico))),
    close(Str).

% Consultar paciente
consultar_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico) :-
    paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico).

% Incluir paciente
incluir_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico) :-
    %nonvar(Nome),
    %nonvar(Sobrenome),
    %nonvar(Idade),
    %nonvar(Sintomas),
    %nonvar(Diagnostico),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)),
    salvar_pacientes.

% Verifica se o paciente com o ID fornecido existe.
paciente_existe(Id) :-
    paciente(Id, _, _, _, _, _).  % Substitua por sua estrutura de dados de paciente

% Alterar paciente
alterar_paciente(Id) :-
    (paciente_existe(Id) ->
        (
            nl, write('Selecione o campo que deseja alterar:'), nl, nl,
            write('1. Nome'), nl,
            write('2. Sobrenome'), nl,
            write('3. Idade'), nl,
            write('4. Sintomas'), nl,
            write('5. Diagnostico'), nl, nl,

            read(Opcao),
            alterar_campo_paciente(Id, Opcao),
            salvar_pacientes
        )
    ;
        nl, write('Paciente não encontrado.'), nl
    ).

alterar_campo_paciente(Id, 1) :-
    nl, write('Digite o novo nome:'),
    read(Nome),
    retract(paciente(Id, _, Sobrenome, Idade, Sintomas, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

alterar_campo_paciente(Id, 2) :-
    nl, write('Digite o novo sobrenome:'),
    read(Sobrenome),
    retract(paciente(Id, Nome, _, Idade, Sintomas, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

alterar_campo_paciente(Id, 3) :-
    nl, write('Digite a nova idade:'),
    read(Idade),
    retract(paciente(Id, Nome, Sobrenome, _, Sintomas, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

alterar_campo_paciente(Id, 4) :-
    nl, write('Digite os novos sintomas:'),
    read(Sintomas),
    retract(paciente(Id, Nome, Sobrenome, Idade, _, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

alterar_campo_paciente(Id, 5) :-
    nl, write('Digite o novo diagnostico:'),
    read(Diagnostico),
    retract(paciente(Id, Nome, Sobrenome, Idade, Sintomas, _)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).
alterar_campo_paciente(_, _) :-
    write('Opção inválida.').


% Excluir paciente
excluir_paciente(Id) :-
    (paciente_existe(Id) ->
        (
            retract(paciente(Id, _, _, _, _, _)),
            salvar_pacientes,
            nl, write('Paciente excluido com sucesso.'), nl
        )
    ;
        nl, write('Paciente não encontrado.'), nl
    ).


% Listar todos os pacientes
listar_pacientes :-
    write('=================================================================================='), nl,
    write('   ID  |   NOME  |  Sobrenome  |  Idade  |     Sintomas     |      DIAGNOSTICO    '), nl,
    write('=================================================================================='), nl,

    forall(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
    (
               write('    '),write(Id), write('     '),write(Nome),write('       '), write(Sobrenome), write('     '), write(Idade), write('     '), write(Sintomas), write('     '), write(Diagnostico), nl, nl)
    ),

    nl, nl, write('Listagem realizada com sucesso!!'), nl.


% Menu de Sistema de Controle de Pacientes.
menu_SCP :-
    nl,
    write('=================================='), nl,
    write(' Sistema de Controle de Pacientes '), nl,
    write('=================================='), nl, nl,

    write(' 1. Consultar paciente'), nl,
    write(' 2. Incluir paciente'), nl,
    write(' 3. Alterar paciente'), nl,
    write(' 4. Excluir paciente'), nl,
    write(' 5. Listar pacientes'), nl,
    write(' 6. Voltar'), nl,
    nl, nl,

    read(Opcao),
    processar_opcao_SCP(Opcao).


% Opcao Sistema de Controle de paciente
% Processar opção do menu
processar_opcao_SCP(1) :-
    nl,
    write('================================'), nl,
    write(' Selecionado=Consultar Paciente'), nl,
    write('================================'), nl, nl,
    write(' Digite o ID do paciente '),
    read(Id),

    (consultar_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico) ->
        write('Nome: '), write(Nome),
        write(Sobrenome), nl,
        write('Idade: '), write(Idade), nl,
        write('Sintomas: '), write(Sintomas), nl,
        write('Diagnostico: '), write(Diagnostico), nl
    ;
        nl, write('Paciente não encontrado!!'), nl
    ),
    menu_SCP.
processar_opcao_SCP(2) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Incluir Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID '), read(Id),
    write('Nome '), read(Nome),
    write('Sobrenome '), read(Sobrenome),
    write('Idade '), read(Idade),
    write('Sintomas '), read(Sintomas),
    write('Diagnóstico '), read(Diagnostico),
    incluir_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
    menu_SCP.
processar_opcao_SCP(3) :-
    nl,
    write('==============================='), nl,
    write(' Selecionado=Alterar Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID do paciente: '), read(Id),
    alterar_paciente(Id),
    menu_SCP.
processar_opcao_SCP(4) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Excluir Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID do paciente: '), read(Id),
    excluir_paciente(Id),
    menu_SCP.
processar_opcao_SCP(5) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Listar Pacientes'), nl,
    write('=============================='), nl, nl,
    listar_pacientes,
    menu_SCP.
processar_opcao_SCP(6) :-
    consult('main.pl'),
    menu_principal.
processar_opcao_SCP(_) :-
    write('Opção inválida'), nl,
    menu_SCP.


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
    excluir_paciente(1),
    excluir_paciente(2),
        \+ paciente(3, _, _).

:- end_tests(pacientes).

% start :-
    % run_tests,
    %menu.
