package artifacts;

import java.awt.event.ActionEvent;
import java.awt.event.WindowEvent;
import java.awt.BorderLayout;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.WindowConstants;
import javax.swing.JOptionPane;

import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.tools.GUIArtifact;

public class Pedidos_de_entrega extends GUIArtifact {
    
    private MyFrame framePrincipal;
    private JanelaPedidos framePedidos;

    public void setup() {
        framePrincipal = new MyFrame();
        
        // Liga o botão de enviar pedido à operação interna que sinaliza ao agente.
        linkActionEventToOp(framePrincipal.okButton, "enviarPedido");
        
        // PASSO 2: Ligar o novo botão "Ver Pedidos" a uma nova operação interna.
        linkActionEventToOp(framePrincipal.verPedidosButton, "pedir_lista_ao_agente");

        // Cria a janela de pedidos, mas mantém-na invisível por enquanto.
        framePedidos = new JanelaPedidos();
        
        framePrincipal.setVisible(true);
    }
    
    @INTERNAL_OPERATION
    void enviarPedido(ActionEvent ev) {
        try {
            int xP = Integer.parseInt(framePrincipal.xPegar.getText());
            int yP = Integer.parseInt(framePrincipal.yPegar.getText());
            int xD = Integer.parseInt(framePrincipal.xDestino.getText());
            int yD = Integer.parseInt(framePrincipal.yDestino.getText());
            
            signal("pedido_recebido", xP, yP, xD, yD);
            JOptionPane.showMessageDialog(framePrincipal, "Pedido enviado com sucesso!", "Confirmação", JOptionPane.INFORMATION_MESSAGE);
        } catch (NumberFormatException e) {
            signal("error", "Valores inválidos");
        }
    }

    // PASSO 2 (continuação): Operação interna que envia o sinal para o agente.
    @INTERNAL_OPERATION
    void pedir_lista_ao_agente(ActionEvent ev) {
        // Sinaliza ao agente que o utilizador quer ver a lista de pedidos.
        framePedidos.setVisible(true);
        signal("ver_pedidos");
    }

    // PASSO 3: Operação que o agente vai chamar para atualizar a interface.
   @OPERATION
    void mostrar_lista_pedidos(final String lista) {
        // Usa invokeLater para garantir que a atualização da GUI corre na thread correta do Swing.
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                framePedidos.atualizarTexto(lista);
                if (!framePedidos.isVisible()) {
                    framePedidos.setVisible(true);
                }
                framePedidos.toFront();
            }
        });
    }

    @INTERNAL_OPERATION
    void closed(WindowEvent ev) {
        signal("closed");
    }

    // Classe para a janela principal da aplicação.
    class MyFrame extends JFrame {
        
        private JButton okButton;
        private JButton verPedidosButton; // PASSO 1.1: Declarar o novo botão.
        private JTextField xPegar;
        private JTextField yPegar;
        private JTextField xDestino;
        private JTextField yDestino;

        public MyFrame() {
            setTitle("Pedidos de Entrega");
            setSize(250, 200);
            
            JPanel panel = new JPanel();
            
            panel.add(new JLabel("Coleta X:"));
            xPegar = new JTextField(4);
            panel.add(xPegar);
            panel.add(new JLabel("Y:"));
            yPegar = new JTextField(4);
            panel.add(yPegar);
            
            panel.add(new JLabel("   Destino X:"));
            xDestino = new JTextField(4);
            panel.add(xDestino);
            panel.add(new JLabel("Y:"));
            yDestino = new JTextField(4);
            panel.add(yDestino);
            
            okButton = new JButton("Enviar Pedido");
            panel.add(okButton);
            
            // PASSO 1.2: Criar e adicionar o novo botão ao painel.
            verPedidosButton = new JButton("Ver Pedidos");
            panel.add(verPedidosButton);

            setContentPane(panel);
            setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
        }
    }

    // PASSO 1.3: Nova classe para a janela que vai mostrar a lista de pedidos.
    class JanelaPedidos extends JFrame {
        
        private JTextArea displayArea;

        public JanelaPedidos() {
            setTitle("Estado dos Pedidos");
            setSize(250, 200);
            // Quando esta janela for fechada, ela apenas fica invisível, não termina a aplicação.
            setDefaultCloseOperation(WindowConstants.HIDE_ON_CLOSE);
            
            displayArea = new JTextArea();
            displayArea.setEditable(false); // O utilizador não pode editar o texto.
            
            // Adiciona uma barra de scroll, caso a lista de pedidos seja muito grande.
            JScrollPane scrollPane = new JScrollPane(displayArea);
            
            getContentPane().add(scrollPane, BorderLayout.CENTER);
        }

        // Método para atualizar o conteúdo da janela.
        public void atualizarTexto(String texto) {
            displayArea.setText(texto);
        }
    }
}
