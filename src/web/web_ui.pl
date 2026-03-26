:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_write)).
:- use_module(library(lists)).

:- consult('../patients/scp.pl').
:- consult('../data/sintomas.pl').
:- consult('../data/doenca_probabilidade.pl').

:- http_handler(root(.), pagina_dashboard, [method(get)]).
:- http_handler(root(diagnostico), pagina_diagnostico, [method(get)]).
:- http_handler(root(pacientes), pagina_pacientes, [method(get)]).
:- http_handler(root(paciente/novo), pagina_paciente, []).
:- http_handler(root(paciente/excluir), excluir_paciente_web, [method(post)]).

start_web :-
    inicializar_dados,
    Port = 8080,
    format('Servidor web iniciado em http://localhost:~w~n', [Port]),
    http_server(http_dispatch, [port(Port)]),
    repeat,
    sleep(3600),
    fail.

inicializar_dados :-
    retractall(paciente(_, _, _, _, _, _)),
    carregar_pacientes.

pagina_dashboard(_Request) :-
    findall(Sintoma, sintoma(Sintoma, _), SintomasDuplicados),
    sort(SintomasDuplicados, Sintomas),
    length(Sintomas, TotalSintomas),
    findall(Doenca, probabilidade(Doenca, _), Doencas),
    length(Doencas, TotalDoencas),
    findall(Id, paciente(Id, _, _, _, _, _), Pacientes),
    length(Pacientes, TotalPacientes),
    Conteudo = [
        h1('Painel do Sistema Medico'),
        p('Use o menu lateral para navegar entre diagnostico, cadastro e lista de pacientes.'),
        div([class('cards-grid')], [
            article([class(card)], [h2('Doencas mapeadas'), p([class(metric), TotalDoencas])]),
            article([class(card)], [h2('Sintomas disponiveis'), p([class(metric), TotalSintomas])]),
            article([class(card)], [h2('Pacientes cadastrados'), p([class(metric), TotalPacientes])])
        ]),
        article([class(card)], [
            h2('Iniciar diagnostico'),
            p('Informe ao menos um sintoma para receber as possiveis condicoes relacionadas.'),
            form([action='/diagnostico', method='get', class('form-stack')], [
                label([for=sintomas], 'Sintomas (separados por virgula)'),
                textarea([name=sintomas, id=sintomas, rows=3, placeholder='febre, tosse, dor_de_cabeca'], []),
                button([type=submit], 'Analisar sintomas')
            ])
        ])
    ],
    render_layout('Painel', dashboard, Conteudo).

pagina_diagnostico(Request) :-
    findall(Sintoma, sintoma(Sintoma, _), SintomasDuplicados),
    sort(SintomasDuplicados, SintomasBase),
    http_parameters(Request, [
        sintomas(SintomasRaw, [default('')])
    ]),
    parse_sintomas(SintomasRaw, SintomasNormalizados),
    diagnostico_por_sintomas(SintomasNormalizados, Resultado),
    (SintomasRaw == '' -> BlocoResultado = p([class(hint)], 'Preencha sintomas para gerar o diagnostico.') ;
        BlocoResultado = article([class(card)], [
            h2('Resultado do diagnostico'),
            p(['Sintomas informados: ', code(SintomasRaw)]),
            \render_resultados(Resultado)
        ])
    ),
    Conteudo = [
        h1('Diagnostico por Sintomas'),
        p('Use os nomes de sintomas em formato simples, separados por virgula.'),
        article([class(card)], [
            form([action='/diagnostico', method='get', class('form-stack')], [
                label([for=sintomas], 'Sintomas'),
                textarea([name=sintomas, id=sintomas, rows=4, placeholder='febre, tosse, fadiga'], SintomasRaw),
                button([type=submit], 'Executar diagnostico')
            ])
        ]),
        article([class(card)], [
            h2('Sintomas da base'),
            p('Referência rápida para preencher o diagnóstico com termos padronizados.'),
            div([class('symptoms-wrap')], \lista_sintomas_chip(SintomasBase))
        ]),
        BlocoResultado
    ],
    render_layout('Diagnostico', diagnostico, Conteudo).

pagina_paciente(Request) :-
    (   memberchk(method(post), Request)
    ->  criar_paciente(Request)
    ;   pagina_form_paciente(Request)
    ).

pagina_form_paciente(_Request) :-
    Conteudo = [
        h1('Novo Paciente'),
        p('Cadastre paciente com dados basicos e sintomas em formato padrao.'),
        article([class(card)], [
            form([action='/paciente/novo', method='post', class('form-stack')], [
                label([for=id], 'ID'),
                input([name=id, id=id, type=number, required=true]),
                label([for=nome], 'Nome'),
                input([name=nome, id=nome, type=text, required=true]),
                label([for=sobrenome], 'Sobrenome'),
                input([name=sobrenome, id=sobrenome, type=text, required=true]),
                label([for=idade], 'Idade'),
                input([name=idade, id=idade, type=number, required=true]),
                label([for=sintomas], 'Sintomas (separados por virgula)'),
                input([name=sintomas, id=sintomas, type=text, required=true, placeholder='febre, dor_de_cabeca']),
                label([for=diagnostico], 'Diagnostico'),
                input([name=diagnostico, id=diagnostico, type=text, required=true]),
                button([type=submit], 'Salvar paciente')
            ])
        ])
    ],
    render_layout('Novo Paciente', novo_paciente, Conteudo).

criar_paciente(Request) :-
    http_parameters(Request, [
        id(Id, [integer]),
        nome(NomeRaw, [string]),
        sobrenome(SobrenomeRaw, [string]),
        idade(Idade, [integer]),
        sintomas(SintomasRaw, [string]),
        diagnostico(DiagnosticoRaw, [string])
    ]),
    parse_sintomas(SintomasRaw, Sintomas),
    normalizar_texto_para_atom(NomeRaw, Nome),
    normalizar_texto_para_atom(SobrenomeRaw, Sobrenome),
    normalizar_texto_para_atom(DiagnosticoRaw, Diagnostico),
    ( paciente_existe(Id) ->
        Mensagem = 'Paciente com este ID ja existe.',
        ClasseStatus = 'status erro'
    ;
        incluir_paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
        Mensagem = 'Paciente cadastrado com sucesso.',
        ClasseStatus = 'status ok'
    ),
    Conteudo = [
        h1('Cadastro de Paciente'),
        p([class(ClasseStatus)], Mensagem),
        div([class('actions-inline')], [
            a([href='/pacientes', class('btn-link')], 'Ver pacientes'),
            a([href='/paciente/novo', class('btn-link secondary')], 'Novo cadastro')
        ])
    ],
    render_layout('Cadastro', novo_paciente, Conteudo).

pagina_pacientes(_Request) :-
    findall(
        paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
        paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico),
        Pacientes
    ),
    Conteudo = [
        h1('Pacientes Cadastrados'),
        p('Visualize os registros atuais do arquivo de pacientes.'),
        article([class(card)], [\render_tabela_pacientes(Pacientes)])
    ],
    render_layout('Pacientes', pacientes, Conteudo).

excluir_paciente_web(Request) :-
    ( obter_inteiro_post(Request, id, Id) ->
        ( paciente_existe(Id) ->
            excluir_paciente(Id),
            Mensagem = 'Paciente excluido com sucesso.',
            ClasseStatus = 'status ok'
        ;
            Mensagem = 'Paciente nao encontrado para exclusao.',
            ClasseStatus = 'status erro'
        )
    ;
        Mensagem = 'ID invalido para exclusao.',
        ClasseStatus = 'status erro'
    ),
    Conteudo = [
        h1('Exclusao de Paciente'),
        p([class(ClasseStatus)], Mensagem),
        div([class('actions-inline')], [
            a([href='/pacientes', class('btn-link')], 'Voltar para pacientes'),
            a([href='/paciente/novo', class('btn-link secondary')], 'Cadastrar paciente')
        ])
    ],
    render_layout('Exclusao', pacientes, Conteudo).

obter_inteiro_post(Request, Nome, Valor) :-
    http_read_data(Request, Dados, []),
    (
        memberchk(Nome=Bruto, Dados)
    ;
        memberchk('id'=Bruto, Dados)
    ;
        memberchk("id"=Bruto, Dados)
    ),
    valor_para_inteiro(Bruto, Valor).

valor_para_inteiro(Valor, Valor) :-
    integer(Valor), !.
valor_para_inteiro(Valor, Numero) :-
    atom(Valor),
    atom_number(Valor, Numero), !.
valor_para_inteiro(Valor, Numero) :-
    string(Valor),
    number_string(Numero, Valor), !.

render_layout(Titulo, Ativo, Conteudo) :-
    reply_html_page(
        [
            title(['Medical Diagnostic System - ', Titulo]),
            meta([name(viewport), content('width=device-width, initial-scale=1')]),
            link([rel(preconnect), href('https://fonts.googleapis.com')], []),
            link([rel(preconnect), href('https://fonts.gstatic.com'), crossorigin], []),
            link([rel(stylesheet), href('https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&family=Fraunces:opsz,wght@9..144,600&display=swap')], [])
        ],
        [
            \estilo,
            \scripts,
            div([class('app-shell')], [
                aside([class(sidebar)], [
                    p([class('brand-kicker')], 'Medical Diagnostic'),
                    h2([class(brand)], 'Painel Clinico'),
                    nav([class(menu), 'aria-label'='Navegacao principal'], [
                        ul([
                            \item_menu(Ativo, dashboard, '/', 'Dashboard'),
                            \item_menu(Ativo, diagnostico, '/diagnostico', 'Diagnostico'),
                            \item_menu(Ativo, novo_paciente, '/paciente/novo', 'Novo Paciente'),
                            \item_menu(Ativo, pacientes, '/pacientes', 'Pacientes')
                        ])
                    ])
                ]),
                main([class(content), role(main)], Conteudo)
            ])
        ]
    ).

item_menu(Ativo, Chave, Href, Rotulo) -->
    {
        (Ativo == Chave -> Classe = 'menu-link ativo', Current = 'page';
            Classe = 'menu-link', Current = 'false')
    },
    html(li(a([href=Href, class(Classe), 'aria-current'=Current], Rotulo))).

parse_sintomas(Raw, Sintomas) :-
    split_string(Raw, ',\n', ' \t\r', Partes),
    exclude(string_vazia, Partes, PartesValidas),
    maplist(normalizar_sintoma, PartesValidas, Sintomas).

string_vazia('').

normalizar_sintoma(Texto, Sintoma) :-
    normalize_space(string(EspacosAjustados), Texto),
    split_string(EspacosAjustados, ' ', '', Tokens),
    atomic_list_concat(Tokens, '_', UnderscoreAtom),
    downcase_atom(UnderscoreAtom, Sintoma).

normalizar_texto_para_atom(Texto, Atom) :-
    normalize_space(string(Ajustado), Texto),
    downcase_atom(Ajustado, Atom).

diagnostico_por_sintomas([], []).
diagnostico_por_sintomas(Sintomas, Resultado) :-
    findall(
        Doenca-Probabilidade,
        (member(Sintoma, Sintomas), sintoma(Sintoma, Doenca), probabilidade(Doenca, Probabilidade)),
        PossibilidadesComDuplicata
    ),
    sort(PossibilidadesComDuplicata, PossibilidadesUnicas),
    predsort(comparar_probabilidade_desc, PossibilidadesUnicas, Resultado).

comparar_probabilidade_desc(Ordem, _DoencaA-ProbA, _DoencaB-ProbB) :-
    compare(OrdemBase, ProbB, ProbA),
    (OrdemBase == '=' -> Ordem = '<' ; Ordem = OrdemBase).

render_resultados([]) -->
    html(p([class(hint)], 'Nenhum diagnostico encontrado para os sintomas informados.')).
render_resultados(Resultados) -->
    html(ul([class('result-list')], \lista_resultados(Resultados))).

lista_resultados([]) --> [].
lista_resultados([Doenca-Probabilidade|Resto]) -->
    html(li([
        span([class('pill')], code(Doenca)),
        span([class('probability')], [Probabilidade, '%'])
    ])),
    lista_resultados(Resto).

lista_sintomas_chip([]) --> [].
lista_sintomas_chip([Sintoma|Resto]) -->
    html(button(
        [
            type(button),
            class('chip chip-button'),
            'data-sintoma'=Sintoma,
            title('Clique para adicionar ao campo de sintomas')
        ],
        code(Sintoma)
    )),
    lista_sintomas_chip(Resto).

render_tabela_pacientes([]) -->
    html(p([class(hint)], 'Nenhum paciente cadastrado.')).
render_tabela_pacientes(Pacientes) -->
    html(div([class('table-wrap')], table([
        thead(tr([
            th('ID'),
            th('Nome'),
            th('Sobrenome'),
            th('Idade'),
            th('Sintomas'),
            th('Diagnostico'),
            th('Acoes')
        ])),
        tbody(\linhas_pacientes(Pacientes))
    ]))).

linhas_pacientes([]) --> [].
linhas_pacientes([paciente(Id, Nome, Sobrenome, Idade, Sintomas, Diagnostico)|Resto]) -->
    { atomic_list_concat(Sintomas, ', ', SintomasTexto) },
    html(tr([
        td(Id),
        td(code(Nome)),
        td(code(Sobrenome)),
        td(Idade),
        td(SintomasTexto),
        td(code(Diagnostico)),
        td(form([action='/paciente/excluir', method='post'], [
            input([type=hidden, name=id, value=Id]),
            button([type=submit, class('btn-danger'), onclick='return confirm("Deseja realmente excluir este paciente?");'], 'Excluir')
        ]))
    ])),
    linhas_pacientes(Resto).

estilo -->
    html(style(':root{--bg:#f3f7f6;--ink:#1d2a28;--muted:#617471;--brand:#0c6e52;--brand-2:#0e8a67;--line:#d8e6e2;--card:#ffffff;--shadow:0 20px 55px rgba(17,50,42,.08);}*{box-sizing:border-box;}body{margin:0;font-family:"Manrope",sans-serif;background:radial-gradient(circle at 10% 10%,#dff5ec 0,#f3f7f6 36%,#eef4f2 100%);color:var(--ink);}h1,h2{margin:0 0 .65rem;}h1{font-family:"Fraunces",serif;font-size:clamp(1.6rem,2.6vw,2.2rem);}p{margin:.25rem 0 1rem;color:var(--muted);}a{text-decoration:none;}.app-shell{display:grid;grid-template-columns:290px minmax(0,1fr);min-height:100vh;}.sidebar{padding:2rem 1.2rem;background:linear-gradient(160deg,#0f3f33,#0d5947 45%,#11775e 100%);color:#ecfffa;position:sticky;top:0;height:100vh;}.brand-kicker{margin:0;color:#b9eee0;font-size:.86rem;letter-spacing:.08em;text-transform:uppercase;}.brand{font-size:1.6rem;margin:.5rem 0 1.5rem;}.menu ul{list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:.45rem;}.menu-link{display:block;padding:.74rem .85rem;border-radius:12px;color:#d7fff3;font-weight:600;transition:.18s ease all;background:rgba(255,255,255,.04);border:1px solid transparent;}.menu-link:hover{background:rgba(255,255,255,.11);}.menu-link.ativo{background:rgba(255,255,255,.2);border-color:rgba(255,255,255,.35);color:#fff;}.content{padding:2rem clamp(1rem,3vw,2.3rem);}.cards-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:1rem;margin:1rem 0 1.2rem;}.card{background:var(--card);border:1px solid var(--line);border-radius:18px;padding:1.1rem 1rem;box-shadow:var(--shadow);}.metric{font-size:1.9rem;font-weight:800;color:var(--brand);margin:.2rem 0 0;}.form-stack{display:flex;flex-direction:column;gap:.58rem;}label{font-weight:700;color:#26423b;}textarea,input{width:100%;padding:.7rem .8rem;border:1px solid #c5d7d2;border-radius:12px;background:#fbfefd;color:#1f2d2b;}textarea:focus,input:focus{outline:2px solid #96d8c1;outline-offset:1px;border-color:#96d8c1;}button{margin-top:.35rem;background:linear-gradient(140deg,var(--brand),var(--brand-2));color:#fff;border:0;border-radius:12px;padding:.72rem 1rem;font-weight:700;cursor:pointer;}button:hover{filter:brightness(1.05);}.hint{font-size:.95rem;color:#637e78;}.status{padding:.75rem .85rem;border-radius:12px;font-weight:700;width:fit-content;}.status.ok{background:#ddf6eb;color:#15583f;border:1px solid #95d7bb;}.status.erro{background:#ffe7e8;color:#8f2d35;border:1px solid #ffb6bb;}.actions-inline{display:flex;gap:.7rem;flex-wrap:wrap;margin-top:.6rem;}.btn-link{display:inline-block;padding:.62rem .85rem;border-radius:10px;background:#0d7458;color:#fff;font-weight:700;}.btn-link.secondary{background:#edf5f3;color:#265149;border:1px solid #bcd1cb;}.btn-danger{margin:0;background:#c44f4f;}.btn-danger:hover{filter:brightness(1.08);}.symptoms-wrap{display:flex;flex-wrap:wrap;gap:.45rem;}.chip{display:inline-flex;align-items:center;padding:.28rem .6rem;border-radius:999px;background:#ebf4f1;border:1px solid #d2e4df;color:#214940;font-size:.84rem;}.chip-button{cursor:pointer;transition:.15s ease;}.chip-button:hover{background:#dff0ea;border-color:#b2d8cb;}.chip-button.active{background:#0f6c51;color:#fff;border-color:#0f6c51;}.result-list{list-style:none;padding:0;margin:.7rem 0 0;display:flex;flex-direction:column;gap:.45rem;}.result-list li{display:flex;justify-content:space-between;gap:1rem;align-items:center;background:#f7fbfa;border:1px solid #deece8;padding:.65rem .75rem;border-radius:12px;}.pill{font-weight:700;color:#1f4a40;}.probability{font-weight:800;color:#0c6e52;}.table-wrap{overflow-x:auto;}table{width:100%;border-collapse:collapse;min-width:720px;}th,td{padding:.58rem .5rem;border-bottom:1px solid #e5efec;text-align:left;}thead th{font-size:.82rem;letter-spacing:.04em;text-transform:uppercase;color:#58706a;background:#f6fbf9;}tbody tr:hover{background:#f7fbfa;}@media (max-width:980px){.app-shell{grid-template-columns:1fr;}.sidebar{position:static;height:auto;padding:1.1rem 1rem;}.menu ul{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));}.cards-grid{grid-template-columns:1fr;}.content{padding:1rem;}}')).

scripts -->
    html(script(
        [
            type('text/javascript')
        ],
        "document.addEventListener('DOMContentLoaded',function(){const textarea=document.getElementById('sintomas');const chips=document.querySelectorAll('.chip-button[data-sintoma]');if(!textarea||chips.length===0)return;const readTokens=function(){return textarea.value.split(',').map(function(item){return item.trim();}).filter(function(item){return item.length>0;});};const renderActive=function(){const current=readTokens();chips.forEach(function(chip){const sintoma=chip.getAttribute('data-sintoma');chip.classList.toggle('active',current.indexOf(sintoma)>=0);});};chips.forEach(function(chip){chip.addEventListener('click',function(){const sintoma=chip.getAttribute('data-sintoma');const current=readTokens();if(current.indexOf(sintoma)>=0){textarea.value=current.filter(function(item){return item!==sintoma;}).join(', ');}else{current.push(sintoma);textarea.value=current.join(', ');}renderActive();});});textarea.addEventListener('input',renderActive);renderActive();});"
    )).
