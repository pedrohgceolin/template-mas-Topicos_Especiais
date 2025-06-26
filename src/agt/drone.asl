bateria(100).
ocupado(n).
pacote(n).

+!entregar(Pacote, XOrigem, YOrigem, XDestino, YDestino)
    <-  -+ocupado(s);
        .print("Recebido missão de entregar pacote ", Pacote, " de (", XOrigem,",", YOrigem,") para (", XDestino,",", YDestino,")" );
        !voar_para(XOrigem, YOrigem);
        !pegar_pacote(Pacote);
        !voar_para(XDestino, YDestino);
        !entregar_pacote(Pacote);
        .print("Pacote ", Pacote, " entregue");
        .send(coordenador, tell, missao_concluida(Nome, Pacote));
        -+ocupado(n).

 +!voar_para(X, Y) : localizacao(X1, Y1) & .my_name(Nome)
    <-  Distancia = math.sqrt( (X - X1)*(X - X1) + (Y - Y1)*(Y - Y1) );
        
        TempoDeEspera = math.round(Distancia * 100);

        .print(Nome, " voando de (",X1,",",Y1,") para (", X,",", Y,"). Distância: ", Distancia, ". Tempo de voo: ", TempoDeEspera, " ms.");
        .wait(TempoDeEspera); // Usa o tempo de espera dinâmico.
        
        !atualizar_bateria(X, Y); // Chama a atualização de bateria APÓS o voo.
        .print(Nome ," chegou ao seu destino!");
        -+localizacao(X,Y). // Atualiza a crença de localização.

+!pegar_pacote(Pacote) : .my_name(Nome)
    <-  .wait(1000);
        .print(Nome ," pegou pacote ", Pacote);
        -+pacote(s).

+!entregar_pacote(Pacote) : .my_name(Nome)
    <-  .wait(1000);
        .print(Nome ," entregou pacote ", Pacote);
        -+pacote(n).

+!mandar_loc : localizacao(X,Y) & ocupado(O) & bateria(B) & .my_name(Nome)
    <-  .send(coordenador, tell, localizacao(Nome,X,Y,O,B));
        .print("Mandando coordenadas: ", X, ", ", Y, ", se Ocupado: ", O , " e Bateria: ", B).

+!atualizar_bateria(X2, Y2) : localizacao(X1, Y1) & .my_name(Nome) & bateria(B)
    <-  // Calcula a distância real percorrida usando a fórmula da distância euclidiana.
        Distancia = math.sqrt( (X2 - X1)*(X2 - X1) + (Y2 - Y1)*(Y2 - Y1) );

        // Converte a distância para o gasto de bateria (arredondando para o inteiro mais próximo).
        BateriaGasta = math.round(Distancia);
        NovaBateria = B - BateriaGasta;

        .print("Atualizando bateria do drone ", Nome);
        .print("Distância voada: ", Distancia, ". Bateria gasta: ", BateriaGasta);
        .print("Bateria anterior: ", B, ". Bateria atual: ", NovaBateria);
        -+bateria(NovaBateria).


// Caso 1: Bateria está a carregar (e abaixo de 91%)
+localizacao(0, 0) : ocupado(n) & bateria(B) & B < 91 & .my_name(Nome)
    <-  .print(Nome, ": Na base de recarga...");
        .wait(2000); // Espera 2 segundos
        .print(Nome, ": A recarregar... ", B, "% -> ", B + 10, "%");
        -+bateria(B + 10);
        -+localizacao(0,0). // Aciona este ciclo novamente

// Caso 2: Bateria está quase cheia, carrega até 100%
+localizacao(0, 0) : ocupado(n) & bateria(B) & B >= 91 & B < 100 & .my_name(Nome)
    <-  .print(Nome, ": Na base de recarga...");
        .wait(2000); // Espera 2 segundos
        .print(Nome, ": A recarregar... ", B, "% -> 100%");
        -+bateria(100).