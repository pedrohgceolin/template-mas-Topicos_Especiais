last_order_id(0).

!gui.

+!gui
    <-  makeArtifact("gui","artifacts.Pedidos_de_entrega",[],Id);
        focus(Id);
        .print("Interface gráfica criada e pronta para receber pedidos").

    
// PLANO REATIVO: Este plano é ativado AUTOMATICAMENTE quando o artefato
// envia o sinal "pedido_recebido" (após o clique do botão).
// As variáveis XP, YP, XD, YD são preenchidas com os dados do sinal.
+pedido_recebido(XP, YP, XD, YD) :   last_order_id(N)
    <-  .print("Pedido recebido via GUI: Pegar em (",XP,",",YP,"), Entregar em (",XD,",",YD,")");
        ID = N + 1;
        .print("Coordenador: Gerando ID para o pedido: ", ID);
        +pedido(ID, pendente, nao_atribuido, XP, YP, XD, YD);
        -last_order_id(N);
        +last_order_id(ID); 
        .abolish(localizacao(_,_,_,_,_));
        .print("Coordenador: A limpar dados de localização antigos...");
        !buscar_drones;
        .wait(2000); 
        !decidir_drone.

+!decidir_drone
    :   pedido(ID, pendente, _, XP, YP, _, _) & .findall(localizacao(D, DX, DY, O, B), localizacao(D, DX, DY, O, B), ListaDrones)
    <-  .print("Coordenador: Calculando o melhor drone para o pedido ", ID, " a partir de: ", ListaDrones);
        !encontrar_melhor_drone(ListaDrones, XP, YP, nenhum, 999999).

// 4. Planos recursivos para encontrar o melhor drone. A lógica agora é mais simples e explícita.

// Plano para drones OCUPADOS.
+!encontrar_melhor_drone([localizacao(Drone, _, _, s, _) | T], XP, YP, MelhorAteAgora, MinDistQuadrada)
    <-  .print("Analisando ", Drone, "... está ocupado. A ignorar.");
        !encontrar_melhor_drone(T, XP, YP, MelhorAteAgora, MinDistQuadrada).

// Plano para drones LIVRES. Este plano calcula tudo e depois chama um ajudante para decidir.
+!encontrar_melhor_drone([localizacao(Drone, DX, DY, n, Bateria) | T], XP, YP, MelhorAteAgora, MinDistQuadrada)
    :   pedido(ID, pendente, _, _, _, XD, YD)
    <-  .print("Analisando ", Drone, "...");
        // Cálculos são feitos no corpo do plano, que é mais seguro.
        DistDronePacote = math.sqrt( (XP-DX)*(XP-DX) + (YP-DY)*(YP-DY) );
        DistPacoteDestino = math.sqrt( (XD-XP)*(XD-XP) + (YD-YP)*(YD-YP) );
        DistDestinoBase = math.sqrt( (0-XD)*(0-XD) + (0-YD)*(0-YD) );
        BateriaNecessaria = DistDronePacote + DistPacoteDestino + DistDestinoBase;
        DistQuadradaAtual = (XP - DX)*(XP - DX) + (YP - DY)*(YP - DY);

        // Imprime os cálculos para depuração
        .print("Distância Drone -> Pacote: ", DistDronePacote);
        .print("Distância Pacote -> Destino: ", DistPacoteDestino);
        .print("Distância Destino -> Base: ", DistDestinoBase);
        .print("Bateria Necessária Total: ", BateriaNecessaria, " / Bateria Atual: ", Bateria);

        // Chama um plano ajudante para tomar a decisão final sobre este drone.
        !avaliar_candidato(Drone, Bateria, BateriaNecessaria, DistQuadradaAtual, T, XP, YP, MelhorAteAgora, MinDistQuadrada).


// --- PLANOS AJUDANTES PARA AVALIAR UM CANDIDATO ---

// Ajudante CASO B: Não tem bateria.
+!avaliar_candidato(Drone, Bateria, BateriaNecessaria, _, T, XP, YP, MelhorAteAgora, MinDistQuadrada)
    :   Bateria <= BateriaNecessaria
    <-  .print("    Resultado: Bateria insuficiente. A ignorar.");
        .send(Drone,achieve, voar_para(0, 0));
        !encontrar_melhor_drone(T, XP, YP, MelhorAteAgora, MinDistQuadrada).

// Ajudante CASO C: Tem bateria, mas não é o mais próximo.
+!avaliar_candidato(Drone, Bateria, BateriaNecessaria, DistQuadradaAtual, T, XP, YP, MelhorAteAgora, MinDistQuadrada)
    :   Bateria > BateriaNecessaria & DistQuadradaAtual >= MinDistQuadrada
    <-  .print("    Resultado: Não é o mais próximo. A ignorar.");
        !encontrar_melhor_drone(T, XP, YP, MelhorAteAgora, MinDistQuadrada).

// Ajudante CASO D: É o melhor candidato até agora.
+!avaliar_candidato(Drone, Bateria, BateriaNecessaria, DistQuadradaAtual, T, XP, YP, _, MinDistQuadrada)
    :   Bateria > BateriaNecessaria & DistQuadradaAtual < MinDistQuadrada
    <-  .print("    Resultado: Novo melhor candidato!");
        !encontrar_melhor_drone(T, XP, YP, Drone, DistQuadradaAtual).
// Casos base (condições de parada quando a lista de drones fica vazia).
+!encontrar_melhor_drone([], _, _, MelhorDrone, _MinDist)
    :   MelhorDrone \== nenhum
    <-  .print("Coordenador: O melhor drone é ", MelhorDrone, ". Enviando a missão...");
        !enviar_missao(MelhorDrone).
+!encontrar_melhor_drone([], _, _, nenhum, _)
    <-  .print("Coordenador: Nenhum drone disponível ou com bateria suficiente foi encontrado. Missão cancelada.").


    // 5. Plano final para enviar a missão para o drone escolhido.
+!enviar_missao(DroneEscolhido)
    :   pedido(ID, pendente, _, XP, YP, XD, YD) // Procura um pedido pendente
    <-  -pedido(ID, pendente, nao_atribuido, XP, YP, XD, YD);
        +pedido(ID, em_andamento, DroneEscolhido, XP, YP, XD, YD);
        .print("Coordenador: Pedido #", ID, " atualizado para [em andamento]. Drone: ", DroneEscolhido);
        // DEPOIS, envia a missão
        !distribuir(DroneEscolhido, ID, XP, YP, XD, YD).

+!distribuir(Drone, Pacote, XOrigem, YOrigem, XDestino, YDestino)
    <-  .print("Enviando pacote ", Pacote, " para drone ", Drone);
        .send(Drone, achieve, entregar(Pacote, XOrigem, YOrigem, XDestino, YDestino));
        .print("Drone ", Drone, " recebeu a missão.").

+!buscar_drones
    <-  .broadcast(achieve, mandar_loc).

+!voar_para : destino(Xd,Yd)
    <-  .wait(10000);
        .send(drone1,achieve, voar_para(Xd, Yd)).

+missao_concluida(Drone, ID)[source(Drone)]
    // CORRIGIDO: Captura os valores XP, YP, XD, YD do pedido aqui no contexto.
    :   pedido(ID, em_andamento, Drone, XP, YP, XD, YD) 
    <-  // Agora que temos os valores nas variáveis, podemos atualizar a "base de dados".
        
        // Remove a entrada antiga do pedido.
        -pedido(ID, em_andamento, Drone, _, _, _, _);
        // Adiciona a nova entrada com o estado 'entregue'.
        +pedido(ID, entregue, Drone, XP, YP, XD, YD);
        
        .print("Coordenador: Pedido #", ID, " foi entregue com sucesso. Estado atualizado para [entregue].").


        // --- NOVO PLANO PARA VISUALIZAÇÃO DE PEDIDOS ---

// PASSO 1: Este plano é ativado quando o utilizador clica no botão "Ver Pedidos".
+ver_pedidos
    <-  .print("Coordenador: A pedido do utilizador, a gerar relatório de pedidos...");
        // PASSO 2: Recolhe todos os pedidos da "base de dados".
        .findall(pedido(I,S,D,OX,OY,DX,DY), pedido(I,S,D,OX,OY,DX,DY), ListaDePedidos);
        // PASSO 3: Inicia o processo de formatação da lista para uma String.
        !formatar_lista_para_string(ListaDePedidos, "Histórico de Pedidos:\n--------------------------\n\n", RelatorioFinal);
        // PASSO 4: Envia a String final para a interface gráfica.
        mostrar_lista_pedidos(RelatorioFinal)[artifact_id(Id)].

// Planos ajudantes para formatar a lista recursivamente.

// Plano recursivo: processa o primeiro pedido da lista e chama-se a si mesmo para o resto.
+!formatar_lista_para_string([pedido(I,S,D,_,_,_,_) | T], StringAtual, RelatorioFinal)
    <-  // Concatena a informação do pedido atual à String.
        .concat(StringAtual, 
                "Pedido #: ", I, 
                "\n  Estado: ", S,
                "\n  Drone: ", D, "\n\n", 
                ProximaString);
        // Continua o processo com o resto da lista.
        !formatar_lista_para_string(T, ProximaString, RelatorioFinal).

// Caso base: a lista está vazia, a formatação terminou.
+!formatar_lista_para_string([], StringFinal, RelatorioFinal)
    <-  // Unifica a variável de resultado com a String que construímos.
        RelatorioFinal = StringFinal.

