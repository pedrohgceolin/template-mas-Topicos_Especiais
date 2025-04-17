!buscar_drones.

//+initially
//   <-  !distribuir(pacote1, b).



//+!distribuir(Pacote, Origem, Destino) 
//    <-  .print("Enviando ", Pacote, " para drone ", D);
//        .send(D, tell, !entregar(Pacote, Retirada, Destino));
//        .print("Drone ", D, " recebeu a missão.").

// Se não tiver drone disponível
//+!distribuir(Pacote, Origem, Destino) : not env.drone_disponivel(_) 
//    <-  .print("Nenhum drone disponível agora. Tentando novamente em 3s...");
//        .wait(3000);
//        !distribuir(Pacote, Destino).

+!buscar_drones
    <-  .broadcast(achieve, mandar_loc);
        .wait(5000);
        !buscar_drones.

