//São 5 agentes no sistema, cada agente fala originalmente uma lingua (Inglês, Português, Espanhol, Italiano e Alemão).
//Um dos agentes diz "Olá" para todos os demais agentes do sistemas, que respondem o mesmo cumprimento, mas utilizando 
//sua lingua mãe. 
//A única coisa que o agente que iniciou o "diálogo" sabe, é ordenar alguém aprender sua lingua em Inglês, ou seja, 
//"learn(portuguese)". Dessa forma, ao receber um "Hello!", ele é capaz de responder "learn(portuguese)", 
//pois sabe que o agente que disse "Hello!" vai entender sua ordem em Inglês. 

//Ao receber uma ordem, automaticamente o agente que fala Inglês, aprende português, e passa a responder "Olá!". 

//Tente implementa um único código para todos os agentes, usando crenças iniciais para diferenciar seus comportamentos 
// (por exemplo "sou(brasileiro)")

saudacao(brasileiro,"Olá","aprender","portuguese").
saudacao(english,"Hello","learn","english").
saudacao(italiano,"Ciao","imparare","italiano").
saudacao(deutsch,"Hallo","lernen","deutsch").
saudacao(espanol,"Hola","aprender","espanol").
ja_mandei_learn(Pessoa,false).


+!falar:sou(Y) & saudacao(Y,X,T,Z)
    <-  .broadcast(tell, X).

+!kqml_received(Pessoa,tell,Msg,mid1): .my_name(Nome)
    <-  .print(Nome, " recebeu ", Msg, " de ", Pessoa);
        !responder(Pessoa).

+!responder(P): sou(Y) & saudacao(Y,X,T,Z)
    <-  .send(P, tell, X).

+!kqml_received(Pessoa,tell,Msg,Mid): .my_name(Nome) & saudacao(X,Msg,Y,Z) & sou(K) & saudacao(K,L,M,N) & ja_mandei_learn(Pessoa,false)
    <-  .print(Nome, " recebeu ", Msg, " de ", Pessoa);
        .send(Pessoa,achieve,learn(Pessoa,Y,N));
        +ja_mandei_learn(Pessoa,true).
        
+!learn(Pessoa, Aprender,Lingua): .my_name(Nome) & saudacao(X,Y,Aprender,I)
     <- .print(Nome, " precisa aprender ", Lingua);
        .send(Pessoa,tell,Y).

+!kqml_received(Pessoa,tell,Msg,Mid): .my_name(Nome) & saudacao(X,Msg,Y,Z) & sou(K) & saudacao(K,L,M,N) & ja_mandei_learn(Pessoa,true)
    <-  .print(Nome, " recebeu ", Msg, " de ", Pessoa).