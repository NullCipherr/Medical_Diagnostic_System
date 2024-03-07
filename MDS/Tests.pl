

:- begin_tests(diagnostico).

consult('SCP.pl').
consult('SDM.pl').

test(list_to_set) :-
    list_to_set([a, b, a, c, b, d], Set),
    assertion(Set == [d, c, b, a]).

:- end_tests(diagnostico).



:- begin_tests(incluir_paciente).

test('Inclui paciente com dados válidos') :-
    incluir_paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe'),
    paciente_existe(999).

:- end_tests(incluir_paciente).



:- begin_tests(consultar_paciente).

% Consulta paciente com ID válido'
test('Consulta paciente com ID valido') :-
    paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe'),
    consultar_paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe').

% Consulta paciente com ID inválido
test('Consulta paciente com ID invalido') :-
    \+ consultar_paciente(10000, _, _, _, _, _).

:- end_tests(consultar_paciente).




:- begin_tests(excluir_paciente).

test('Exclui paciente existente') :-
    assertz(paciente(999, 'joao', 'silva', 35, ['Febre', 'Tosse'], 'Gripe')),
    excluir_paciente(999),
    \+ paciente_existe(999).

test('Exclui paciente inexistente') :-
    excluir_paciente(1000),
    \+ paciente_existe(1000).

:- end_tests(excluir_paciente).



