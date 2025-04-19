!buscar_drones.
!distribuir(drone1 , 001, 10, 15, 25, 30).

+!distribuir(Drone ,Pacote, XOrigem, YOrigem, XDestino, YDestino)
    <-  .wait(2000);
        .print("Enviando pacote ", Pacote, " para drone ", Drone);
        .send(Drone, achieve, entregar(Pacote, XOrigem, YOrigem, XDestino, YDestino));
        .print("Drone ", Drone, " recebeu a missão.").

// Se não tiver drone disponível
//+!distribuir(Pacote, Origem, Destino) : not env.drone_disponivel(_) 
//    <-  .print("Nenhum drone disponível agora. Tentando novamente em 3s...");
//        .wait(3000);
//        !distribuir(Pacote, Destino).

+!buscar_drones
    <-  .broadcast(achieve, mandar_loc);
        .wait(5000);
        !buscar_drones.

+!voar_para : destino(Xd,Yd)
    <-  .wait(10000);
        .send(drone1,achieve, voar_para(Xd, Yd)).
