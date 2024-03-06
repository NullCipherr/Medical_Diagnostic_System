% sintoma(sintoma, doenca)
%  Facilita na manipulação dos sintomas individualmente ao invés da
%  estrutura: doenca(doenca, [Sintoma1, Sintoma2, ...]), que tornaria
%  mais complexo essa manipulacao.

% Base de conhecimento de 'sintoma'.

% Covid-19.
sintoma(febre, covid19).
sintoma(tosse, covid19).
sintoma(dor_de_cabeca, covid19).
sintoma(perda_de_olfato, covid19).
sintoma(fadiga, covid19).

% Gripe comum.
sintoma(febre, gripe).
sintoma(tosse, gripe).
sintoma(dor_de_garganta, gripe).
sintoma(coriza, gripe).
sintoma(dor_de_cabeca, gripe).

% Dengue.
sintoma(febre, dengue).
sintoma(dor_de_cabeca, dengue).
sintoma(dor_atras_dos_olhos, dengue).
sintoma(fadiga, dengue).
sintoma(erupcao_cutanea, dengue).

% Asthma.
sintoma(falta_de_ar, asthma).
sintoma(tosse, asthma).
sintoma(chiado_no_peito, asthma).
sintoma(dor_no_peito, asthma).
sintoma(fadiga, asthma).

% Diabetes.
sintoma(sede_excessiva, diabetes).
sintoma(fome_excessiva, diabetes).
sintoma(perda_de_peso, diabetes).
sintoma(fadiga, diabetes).
sintoma(visao_embacada, diabetes).

% Hipertensao.
sintoma(dor_de_cabeca, hipertensao).
sintoma(falta_de_ar, hipertensao).
sintoma(tontura, hipertensao).
sintoma(dor_no_peito, hipertensao).
sintoma(sangramento_nasal, hipertensao).

% Anemia.
sintoma(fadiga, anemia).
sintoma(palidez, anemia).
sintoma(falta_de_ar, anemia).
sintoma(tontura, anemia).
sintoma(dor_no_peito, anemia).

% Obesidade.
sintoma(ganho_de_peso, obesidade).
sintoma(fadiga, obesidade).
sintoma(falta_de_ar, obesidade).
sintoma(suor_excessivo, obesidade).
sintoma(dor_nas_costas, obesidade).

% Depressao.
sintoma(tristeza, depressao).
sintoma(perda_de_interesse, depressao).
sintoma(dificuldade_de_concentracao, depressao).
sintoma(fadiga, depressao).
sintoma(sentimentos_de_desesperanca, depressao).

% Ansiedade.
sintoma(nervosismo, ansiedade).
sintoma(inquietacao, ansiedade).
sintoma(aumento_da_frequencia_cardiaca, ansiedade).
sintoma(fadiga, ansiedade).
sintoma(sentimentos_de_pavor, ansiedade).

% Hipotireoidismo.
sintoma(fadiga, hipotireoidismo).
sintoma(ganho_de_peso, hipotireoidismo).
sintoma(pele_seca, hipotireoidismo).
sintoma(sensibilidade_ao_frio, hipotireoidismo).
sintoma(constipacao, hipotireoidismo).

% Hipertireoidismo.
sintoma(perda_de_peso, hipertireoidismo).
sintoma(aumento_da_frequencia_cardiaca, hipertireoidismo).
sintoma(aumento_do_apetite, hipertireoidismo).
sintoma(nervosismo, hipertireoidismo).
sintoma(sudorese, hipertireoidismo).

% Insuficiência renal.
sintoma(nausea, insuficiencia_renal).
sintoma(fadiga, insuficiencia_renal).
sintoma(perda_de_apetite, insuficiencia_renal).
sintoma(dificuldade_de_concentracao, insuficiencia_renal).
sintoma(coceira_na_pele, insuficiencia_renal).

% Hepatite.
sintoma(febre, hepatite).
sintoma(fadiga, hepatite).
sintoma(dor_abdominal, hepatite).
sintoma(ictericia, hepatite).
sintoma(perda_de_apetite, hepatite).

% Pneumonia.
sintoma(tosse, pneumonia).
sintoma(febre, pneumonia).
sintoma(falta_de_ar, pneumonia).
sintoma(sudorese, pneumonia).
sintoma(dor_no_peito, pneumonia).

% Tuberculose.
sintoma(tosse, tuberculose).
sintoma(febre, tuberculose).
sintoma(sudorese_noturna, tuberculose).
sintoma(perda_de_peso, tuberculose).
sintoma(fadiga, tuberculose).

% Gastrite.
sintoma(dor_abdominal, gastrite).
sintoma(nausea, gastrite).
sintoma(vomito, gastrite).
sintoma(perda_de_apetite, gastrite).
sintoma(azia, gastrite).

% Úlcera péptica.
sintoma(dor_abdominal, ulcera_peptica).
sintoma(azia, ulcera_peptica).
sintoma(nausea, ulcera_peptica).
sintoma(sensacao_de_fome, ulcera_peptica).
sintoma(vomito, ulcera_peptica).

% Artrite reumatoide.
sintoma(dor_nas_articulacoes, artrite_reumatoide).
sintoma(inchaco_nas_articulacoes, artrite_reumatoide).
sintoma(rigidez_nas_articulacoes, artrite_reumatoide).
sintoma(fadiga, artrite_reumatoide).
sintoma(febre, artrite_reumatoide).

% Osteoporose.
sintoma(dor_ossea, osteoporose).
sintoma(perda_de_altura, osteoporose).
sintoma(postura_curvada, osteoporose).
sintoma(fraturas_osseas, osteoporose).
