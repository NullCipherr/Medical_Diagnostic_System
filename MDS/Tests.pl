:- consult('SCP.pl').
:- consult('SDM.pl').


% Teste de lista para conjunto(list_to_set)
:- begin_tests(lista_para_conjunto).

test(lista_para_conjunto_com_duplicatas) :-
    list_to_set([a, b, a, c, b, d], Conjunto),
    assertion(Conjunto == [d, c, b, a]).

test(lista_para_conjunto_com_duplicatas_numericas) :-
    list_to_set([1, 2, 2, 3, 1, 4], Conjunto),
    assertion(Conjunto == [4, 3, 2, 1]).

test(lista_para_conjunto_com_duplicatas_alfabeticas) :-
    list_to_set([x, y, x, z, y, w], Conjunto),
    assertion(Conjunto == [w, z, y, x]).

:- end_tests(lista_para_conjunto).


% Incluir paciente.
:- begin_tests(incluir_paciente).

test('Inclui paciente com dados validos e verifica existencia') :-
    incluir_paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe'),
    assertion(paciente_existe(999)).

test('Inclui outro paciente com dados validos e verifica existencia') :-
    incluir_paciente(998, 'maria', 'santos', 45, ['Dor de cabeca', 'Nausea'], 'Enxaqueca'),
    assertion(paciente_existe(998)).

test('Inclui paciente com dados validos e verifica nao existencia de outro paciente') :-
    incluir_paciente(997, 'jose', 'pereira', 55, ['Tontura', 'Desmaio'], 'Pressao alta'),
    assertion(\+paciente_existe(996)).

:- end_tests(incluir_paciente).


% Consultar paciente.
:- begin_tests(consultar_paciente).

% Consulta paciente com ID valido.
test('Consulta paciente com ID valido') :-
    paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe'),
    consultar_paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe').

% Consulta paciente com ID invalido.
test('Consulta paciente com ID invalido') :-
    \+ consultar_paciente(10000, _, _, _, _, _).

% Consulta outro paciente com ID valido.
test('Consulta outro paciente com ID valido') :-
    paciente(998, 'maria', 'santos', 45, ['Dor de cabeca', 'Nausea'], 'Enxaqueca'),
    consultar_paciente(998, 'maria', 'santos', 45, ['Dor de cabeca', 'Nausea'], 'Enxaqueca').

% Consulta paciente com ID válido e verifica nao existência de outro.
test('Consulta paciente com ID valido e verifica nao existencia de outro') :-
    paciente(997, 'jose', 'pereira', 55, ['Tontura', 'Desmaio'], 'Pressao alta'),
    consultar_paciente(997, 'jose', 'pereira', 55, ['Tontura', 'Desmaio'], 'Pressao alta'),
    \+ consultar_paciente(996, _, _, _, _, _).

:- end_tests(consultar_paciente).


% Excluir paciente.
:- begin_tests(excluir_paciente).

test('Exclui paciente existente') :-
    assertz(paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe')),
    excluir_paciente(999),
    \+ paciente_existe(999).

test('Exclui paciente inexistente') :-
    excluir_paciente(1000),
    \+ paciente_existe(1000).

% Exclui outro paciente existente
test('Exclui outro paciente existente') :-
    assertz(paciente(998, 'maria', 'santos', 45, ['Dor de cabeca', 'Nausea'], 'Enxaqueca')),
    excluir_paciente(998),
    \+ paciente_existe(998).

% Tenta excluir paciente já excluído
test('Tenta excluir paciente ja excluido') :-
    assertz(paciente(997, 'jose', 'pereira', 55, ['Tontura', 'Desmaio'], 'Pressao alta')),
    excluir_paciente(997),
    \+ paciente_existe(997),
    excluir_paciente(997),
    \+ paciente_existe(997).

:- end_tests(excluir_paciente).


% Salvar paciente.
:- begin_tests(salvar_pacientes).

test('Salva pacientes quando a lista de pacientes esta vazia') :-
    retractall(paciente(_, _, _, _, _, _)),  % Limpa todos os pacientes.
    salvar_pacientes,
    exists_file('pacientes.txt').  % Verifica se o arquivo 'pacientes.txt' existe.

test('Salva um paciente') :-
    retractall(paciente(_, _, _, _, _, _)),  % Limpa todos os pacientes
    assertz(paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe')),
    salvar_pacientes,
    exists_file('pacientes.txt').  % Verifica se o arquivo 'pacientes.txt' existe.

test('Salva varios pacientes') :-
    retractall(paciente(_, _, _, _, _, _)),  % Limpa todos os pacientes
    assertz(paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe')),
    assertz(paciente(998, 'maria', 'santos', 45, ['Dor de cabeca', 'Nausea'], 'Enxaqueca')),
    salvar_pacientes,
    exists_file('pacientes.txt').  % Verifica se o arquivo 'pacientes.txt' existe.

:- end_tests(salvar_pacientes).


% Paciente existe.
:- begin_tests(paciente_existe).

% Verifica a não existência de um paciente que não foi adicionado
test('Verifica nao existencia de paciente nao adicionado') :-
    assertion(\+ paciente_existe(1000)).

% Verifica a não existência de um paciente que foi excluído
test('Verifica nao existencia de paciente excluido') :-
    assertz(paciente(998, 'maria', 'santos', 45, ['Dor de cabeca', 'Nausea'], 'Enxaqueca')),
    excluir_paciente(998),
    assertion(\+ paciente_existe(998)).

:- end_tests(paciente_existe).


% Imprimir lista em ordem crescente.
:- begin_tests(imprimir_doencas).

% Imprime uma lista vazia de doenças
test('Imprime lista vazia de doencas') :-
    imprimir_doencas([]).

% Imprime uma lista de doenças
test('Imprime lista de doencas') :-
    imprimir_doencas([('Gripe', 30), ('Dengue', 20), ('Covid-19', 50)]).

:- end_tests(imprimir_doencas).


% Imprimir lista ordem decrescente.
:- begin_tests(imprimir_doencas_inverso).

% Imprime uma lista vazia de doenças em ordem inversa
test('Imprime lista vazia de doencas em ordem inversa') :-
    imprimir_doencas_inverso([]).

% Imprime uma lista de doenças em ordem inversa
test('Imprime lista de doencas em ordem inversa') :-
    imprimir_doencas_inverso([('Gripe', 30), ('Dengue', 20), ('Covid-19', 50)]).

:- end_tests(imprimir_doencas_inverso).


% Imprimir
:- begin_tests(imprimir).

% Imprime uma lista vazia
test('Imprime lista vazia') :-
    imprimir([]).

% Imprime uma lista com um elemento
test('Imprime lista com um elemento') :-
    imprimir(['Gripe']).

% Imprime uma lista com múltiplos elementos
test('Imprime lista com multiplos elementos') :-
    imprimir(['Gripe', 'Dengue', 'Covid-19']).

:- end_tests(imprimir).
