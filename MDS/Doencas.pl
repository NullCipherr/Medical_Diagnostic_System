% Lista de doenças, sintomas e suas probabilidades
doencas([
    doenca('Gripe', ['febre', 'dor_no_corpo', 'tosse'], 0.3),
    doenca('Dengue', ['febre', 'dor_no_corpo', 'dor_de_cabeca', 'dor_nos_olhos'], 0.2),
    doenca('Meningite', ['febre', 'dor_de_cabeca', 'dor_no_pescoco', 'nausea', 'vomito'], 0.05),
    doenca('Gripe', ['febre', 'dor_no_corpo', 'tosse'], 0.3),
    doenca('Dengue', ['febre', 'dor_no_corpo', 'dor_de_cabeca', 'dor_nos_olhos'], 0.2),
    doenca('Meningite', ['febre', 'dor_de_cabeca', 'dor_no_pescoco', 'nausea', 'vomito'], 0.05),
    doenca('Resfriado Comum', ['febre', 'tosse', 'dor_de_cabeca'], 0.4)]).




% IHC para solicitar informações de sintomas
solicitar_sintomas(Sintomas) :-
    write('\33\[2J'),
    nl,
    write('Insira os sintomas que o paciente está sentindo, separados por vírgulas (ex: febre,dor_no_corpo,tosse) '),
    nl,
    nl,
    write('-> '),
    read_line_to_string(user_input, Input),
    split_string(Input, ",",",", Sintomas).



% IHC para exibir resultados
exibir_resultados([]) :-
    write('Não foi encontrada nenhuma doença que corresponda aos sintomas informados.\n').
exibir_resultados([doenca(Nome, _, Prob)|Resto]) :-
    format('Doença: ~w, Probabilidade: ~w\n', [Nome, Prob]),
    exibir_resultados(Resto).



% Diagnóstico baseado nos sintomas
% Diagnóstico baseado nos sintomas
diagnosticar(Sintomas, Resultados) :-
    findall(Doenca, (doencas(Doencas), member(Doenca, Doencas), doenca(_, SintomasDoenca, _) = Doenca, intersection(SintomasDoenca, Sintomas, Intersect), Intersect \= []), Resultados).


% Função principal
diagnostico_principal :-
    solicitar_sintomas(Sintomas),
    diagnosticar(Sintomas, Resultados).
    %exibir_resultados(Resultados).















