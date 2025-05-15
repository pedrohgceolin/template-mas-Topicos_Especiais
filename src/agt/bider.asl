

/* Plans */
+tarefa(T,MaxVal): decremento(D,T)
    <-  .print("Recebi anuncio da tarefa ", T, " com valor máximo de ", MaxVal);
        .broadcast(tell,oferta(T,MaxVal-D)).

+oferta(T,Val): bid_minimo(Min,T) & decremento(D,T) & (Val-D >= Min)
    <-  .print("Vou cobrir a oferta de ", Val, " com ", Val-D, " para a tarefa ", T);
        .wait(200);
        .broadcast(tell,oferta(T,Val-D)).

+oferta(T,Val): bid_minimo(Min,T) & decremento(D,T) & (Val-D <= Min)
    <-  .print("Vou ficar de fora da tarefa ", T, " pois o valor jah estah em ", Val, " e o meu minimo eh ", Min).

// reagir a informação da tarefa sendo "anunciada" através do predicado "tarefa(NomeTarefa,ValorMaximo)", 
// gerando uma oferta a ser anunciada através de um broadcast: .broadcast(tell,oferta(NomeTarefa,Oferta)). 
// você também deve reagir aos broadcasts dos colegas "oferta(NomeTarefa,Oferta)[source(Colega)]" para 
// acompanhar quem está vencendo a alocação, e poder decidir se fará novas ofertas ou não para cada tarefa. 


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }