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
        -+ocupado(n).

 +!voar_para(X, Y) : .my_name(Nome)
    <-  .print(Nome, " voando para (", X,",", Y,")");
        .wait(2000);
        .print(Nome ," chegou!");
        -+localizacao(X,Y).

+!pegar_pacote(Pacote) : .my_name(Nome)
    <-  .wait(1000);
        .print(Nome ," pegou pacote ", Pacote);
        -+pacote(s).

+!entregar_pacote(Pacote) : .my_name(Nome)
    <-  .wait(1000);
        .print(Nome ," entregou pacote ", Pacote);
        -+pacote(n).

+!mandar_loc : localizacao(X,Y) & ocupado(O) & pacote(P)
    <-  .send(coordenador, tell, localizacao(X,Y));
        .print("Mandando coordenadas: ", X, ", ", Y);
        .send(coordenador, tell, ocupado(O));
        .print("Ocupado: ", O);
        .send(coordenador, tell, pacote(P));
        .print("Pacote: ", P).