// cumprimentos em diferentes idiomas
saudacao(portugues, "Olá!").
saudacao(ingles, "Hello!").
saudacao(espanhol, "¡Hola!").
saudacao(italiano, "Ciao!").
saudacao(alemao, "Hallo!").

// Estado da conversa
resposta_recebida(false).

// Objetivo inicial para começar a conversa
!comecar_conversa.

// Agente português inicia a conversa
+!comecar_conversa : idioma(portugues)
  <- .print(self, ": Iniciando conversa em inglês!");
     !enviar_saudacao("Hello!").

// Outros agentes aguardam comecar_conversa : idioma(Idioma) & Idioma \== portugues
+!comecar_conversa : idioma(MeuIdioma) & MeuIdioma \== portugues
  <- .print(self, ": Aguardando saudação inicial...").

// Envia mensagem para todos os agentes
+!enviar_saudacao(Mensagem)
  <- .send(agente_ingles,    tell, receber_saudacao(Mensagem));
     .send(agente_portugues, tell, receber_saudacao(Mensagem));
     .send(agente_espanhol,  tell, receber_saudacao(Mensagem));
     .send(agente_italiano,  tell, receber_saudacao(Mensagem));
     .send(agente_alemao,    tell, receber_saudacao(Mensagem)).

// Processa saudação recebida
+receber_saudacao(Mensagem)[source(Remetente)]
  <- .print(self, ": Recebi saudação de ", Remetente, ": ", Mensagem);
     !responder_saudacao(Mensagem, Remetente).

// Lógica de resposta
+!responder_saudacao(MensagemRecebida, Remetente)
  <- if (saudacao(MeuIdioma, MinhaSaudacao) & idioma(MeuIdioma) & not resposta_recebida(true)) {
        /* Caso especial: português responde a "Hello!" com pedido de aprendizado */
        if (MensagemRecebida == "Hello!" & idioma(portugues)) {
           .send(Remetente, tell, aprender_idioma(portugues));
        }
        /* Resposta normal no próprio idioma */
        else {
           .print(self, ": Respondendo com ", MinhaSaudacao);
           .send(Remetente, tell, receber_saudacao(MinhaSaudacao));
           -resposta_recebida(false);
           +resposta_recebida(true);
        }
     }.

// Processa pedido de aprendizado de idioma
+aprender_idioma(IdiomaParaAprender) : idioma(MeuIdioma) & MeuIdioma \== portugues
  <- .print(self, ": Aprendendo novo idioma: ", IdiomaParaAprender);
     +idioma(portugues); 
     .print(self, ": Agora respondo em português: 'Olá!'").
