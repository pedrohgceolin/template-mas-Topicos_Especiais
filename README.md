# Projeto Sistemas Multiagentes para disciplina de Tópicos Especiais I
Autor: Pedro Ceolin

Este projeto tem como finalidade montar um sistema multiagentes para entregas de pacotes por drones.

Agentes:
- Drones;
- Coordenador.

## Explicação de cada agente

### Drones

São os agentes que realizarão as entregas.

Tem 4 crenças principais:
- Localização ( localizacao(X,Y) );
- Percetual da bateria ( bateria(100) );
- Se está ocupado ( ocupado(n) );
- Se está carregando pacote ( pacote(n) ).

Tem planos para os objetivos de:
 - Realizar entrega de pacote ( +!entregar )
 - Voar para alguma localizacao ( +!voar_para )
 - Pegar pacote ( +!pegar_pacote )
 - Entregar pacote ( +!entregar_pacote )
 - Atualizar nivel de bateria ( +!atualizar_bateria )

### Coordenador

É o agente que recebe os pedidos de entrega e seleciona qual drone realizará a entrega. 
Para selecionar o drone, o coordenador verifica qual esta mais perto do ponto de coleta do pacote, 
e verifica se tem bateria suficiente para fazer o trajeto todo.

Tem um objetivo:
- Verificar a localização dos drones, se estão ocupados e qual o nivel de bateria ( !buscar_drones ).

Tem os planos para os objetivos de :
- Verificar a localização dos drones, estão ocupados e qual o nivel de bateria ( +!buscar_drones );
- Selecionar o drone e distribuir a entrega de pacotes ( +!distribuir );
- Mandar o drone voar para algum lugar.

  
