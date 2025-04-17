bateria(100).
ocupado(n).

//+!entregar(Pacote, Origem, Destino) : localizacao(X,Y)
//    <-  .ocupado(s);
//        !voar_para(Destino);
//        .print("Pacote ", Pacote, " entregue em ", Destino).
//

+!voar_para(Destino) : ocupado(s) 
    <-  .print("Voando para ", Destino);
        localizacao 

+!voar_para(Destino) : ocupado(n)
    <-  .print("Voando para ", Destino);
        -+localizacao(Destino).

+!mandar_loc : localizacao(X,Y) & ocupado(O)
    <-  .send(coordenador, tell, localizacao(X,Y));
        .print("Mandando coordenadas: ", X, ", ", Y);
        .send(coordenador, tell, ocupado(O));
        .print("Mandando status: ", O).