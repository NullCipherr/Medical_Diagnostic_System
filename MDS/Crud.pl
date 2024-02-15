% Prototipo de um sistema de diagnostico médico
%
%  Apresentar os seguinte modulos :
%  - Consulta
%  - Inclusao
%  - Alteração
%  - Exclusao


% Carregar pacientes do arquivo.
load(Pacientes) :-
    open('pacientes.txt', read, Stream),
    read_file(Stream, Pacientes),
    close(Stream).


% Ler arquivo.
read_file(Stream,[]) :-
    at_end_of_stream(Stream).
read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).


% Salvar pacientes no arquivo
salvar_pacientes(Pacientes) :-
    open('pacientes.txt', write, Stream),
    write_file(Stream, Pacientes),
    close(Stream).


% Escrever no arquivo
write_file(_, []).
write_file(Stream, [X|L]) :-
    write(Stream, X), write(Stream, '.\n'),
    write_file(Stream, L).


% Consultar paciente
consultar_paciente(Nome, Pacientes, Paciente) :-
    member(paciente(Nome, _, _), Pacientes), !, Paciente = paciente(Nome, _, _).


% Incluir paciente
incluir_paciente(Paciente, Pacientes, [Paciente|Pacientes]).


% Alterar paciente
alterar_paciente(_, [], _, []) :- !.
alterar_paciente(Nome, [paciente(Nome, _, _)|Pacientes], Paciente, [Paciente|Pacientes]).
alterar_paciente(Nome, [P|Pacientes], Paciente, [P|Result]) :-
    alterar_paciente(Nome, Pacientes, Paciente, Result).


% Excluir paciente
excluir_paciente(_, [], []) :- !.
excluir_paciente(Nome, [paciente(Nome, _, _)|Pacientes], Pacientes).
excluir_paciente(Nome, [P|Pacientes], [P|Result]) :-
    excluir_paciente(Nome, Pacientes, Result).
