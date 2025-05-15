!inicializar_caixa_de_som.

+!inicializar_caixa_de_som
  <- 	makeArtifact("caixa_de_som","artifacts.CaixaDeSomJarvis",[],D).
        .print("🎤 Ativando Jarvis...");
        caixaDeSomJarvis.ligar();
        .wait(1000);
        caixaDeSomJarvis.tocar("Back in Black - AC/DC");
        .wait(3000);
        caixaDeSomJarvis.aumentar_volume();
        .wait(2000);
        caixaDeSomJarvis.responder("Tudo sob controle por aqui.");
        .wait(3000);
        caixaDeSomJarvis.parar();
        .wait(2000);
        caixaDeSomJarvis.desligar().