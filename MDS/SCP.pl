%=============================================%
%      Alunos                          RA     %
%=============================================%
% Andrei Roberto da Costa            107975   %
% Joao Gilberto Pelisson Casagrande           %
% Rodrigo Vieira de Vasconcellos              %
%=============================================%


% carregar_pacientes is semidet
%
%  Carrega os pacientes do arquivo 'pacientes.txt', se existir.
carregar_pacientes :-
    exists_file('pacientes.txt'), !,
    open('pacientes.txt', read, Str),
    read_pacientes(Str, _),
    close(Str).
carregar_pacientes.


%% read_pacientes(+Stream, -List) is nondet
%
%  Lê os pacientes do arquivo até o final do stream.
read_pacientes(Stream,[]) :-
    at_end_of_stream(Stream), !.
read_pacientes(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    assertz(X),
    read_pacientes(Stream,L).


%% salvar_pacientes is det
%
%  Salva os pacientes no arquivo 'pacientes.txt'.
salvar_pacientes :-
    open('pacientes.txt', write, Str),
    forall(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
           writeq(Str, paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico))),
    close(Str).


%% consultar_paciente(+Id, -Nome, -Sobrenome, -Idade, -Sintomas, -Diagnostico) is semidet
%
%  Consulta um paciente pelo ID.
consultar_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico) :-
    paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico).


%% incluir_paciente(+Id, +Nome, +Sobrenome, +Idade, +Sintomas,+Diagnostico) is det
%
%  Inclui um novo paciente.
incluir_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico) :-
    %nonvar(Nome),
    %nonvar(Sobrenome),
    %nonvar(Idade),
    %nonvar(Sintomas),
    %nonvar(Diagnostico),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)),
    salvar_pacientes.


%% paciente_existe(+Id) is semidet
%
%  Verifica se o paciente com o ID fornecido existe.
paciente_existe(Id) :-
    paciente(Id, _, _, _, _, _).  % Substitua por sua estrutura de dados de paciente


%% alterar_paciente(+Id) is det
%
%  Altera os dados de um paciente existente.
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


%% alterar_campo_paciente(+Id, +Opcao) is det
%
%  Altera um campo específico do paciente com base na opção fornecida.
%
% Alterar nome do paciente.
alterar_campo_paciente(Id, 1) :-
    nl, write('Digite o novo nome:'),
    read(Nome),
    retract(paciente(Id, _, Sobrenome, Idade, Sintomas, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

% Alterar sobrenome do paciente.
alterar_campo_paciente(Id, 2) :-
    nl, write('Digite o novo sobrenome:'),
    read(Sobrenome),
    retract(paciente(Id, Nome, _, Idade, Sintomas, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

% Alterar Idade do paciente.
alterar_campo_paciente(Id, 3) :-
    nl, write('Digite a nova idade:'),
    read(Idade),
    retract(paciente(Id, Nome, Sobrenome, _, Sintomas, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

% Alterar sintomas do paciente.
alterar_campo_paciente(Id, 4) :-
    nl, write('Digite os novos sintomas:'),
    read(Sintomas),
    retract(paciente(Id, Nome, Sobrenome, Idade, _, Diagnostico)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

% Alterar diagnostico do paciente.
alterar_campo_paciente(Id, 5) :-
    nl, write('Digite o novo diagnostico:'),
    read(Diagnostico),
    retract(paciente(Id, Nome, Sobrenome, Idade, Sintomas, _)),
    assertz(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)).

% Opcao Invalida.
alterar_campo_paciente(_, _) :-
    write('Opção inválida.').


%% excluir_paciente(+Id) is det
%
%  Exclui um paciente pelo ID, se existir.
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


%% listar_pacientes is det
%
% Listar todos os pacientes
listar_pacientes :-
    write('=================================================================================='), nl,
    write('   ID  |   NOME  |  Sobrenome  |  Idade  |     Sintomas     |      DIAGNOSTICO    '), nl,
    write('=================================================================================='), nl,

    forall(paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
    (
               write('   '),write(Id), write('     '),write(Nome),write('    '), write(Sobrenome), write('          '), write(Idade), write('        '), write(Sintomas), write('           '), write(Diagnostico), nl, nl)
    ),

    nl, nl, write('Listagem realizada com sucesso!!'), nl.


%% menu_SCP is det
%
%  Exibe o menu do Sistema de Controle de Pacientes.
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


%% processar_opcao_SCP(+Opcao) is det
%
%  Processa a opção escolhida no menu do Sistema de Controle de Pacientes.
%
%  Consultar paciente.
processar_opcao_SCP(1) :-
    nl,
    write('================================'), nl,
    write(' Selecionado=Consultar Paciente'), nl,
    write('================================'), nl, nl,
    write(' Digite o ID do paciente '),
    read(Id),

    (consultar_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico) ->
        nl, write('Nome: '), write(Nome), write(' '),
        write(Sobrenome), nl,
        write('Idade: '), write(Idade), nl,
        write('Sintomas: '), write(Sintomas), nl,
        write('Diagnostico: '), write(Diagnostico), nl
    ;
        nl, write('Paciente não encontrado!!'), nl
    ),
    menu_SCP.

% Incluir paciente.
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

% Alterar paciente.
processar_opcao_SCP(3) :-
    nl,
    write('==============================='), nl,
    write(' Selecionado=Alterar Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID do paciente: '), read(Id),
    alterar_paciente(Id),
    menu_SCP.

% Exluiir paciente.
processar_opcao_SCP(4) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Excluir Paciente'), nl,
    write('=============================='), nl, nl,
    write('ID do paciente: '), read(Id),
    excluir_paciente(Id),
    menu_SCP.

% Listar paciente.
processar_opcao_SCP(5) :-
    nl,
    write('=============================='), nl,
    write(' Selecionado=Listar Pacientes'), nl,
    write('=============================='), nl, nl,
    listar_pacientes,
    menu_SCP.

% Voltar ao menu anterior.
processar_opcao_SCP(6) :-
    consult('main.pl'),
    menu_principal.

% Opcao invalida.
processar_opcao_SCP(_) :-
    write('Opção inválida'), nl,
    menu_SCP.
