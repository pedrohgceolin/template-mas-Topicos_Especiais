package artifacts;

import java.awt.event.ActionEvent;
import java.awt.event.WindowEvent;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.JOptionPane;

import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import cartago.tools.GUIArtifact;

public class Pedidos_de_entrega extends GUIArtifact {
    
    private MyFrame frame;

    public void setup() {
        frame = new MyFrame();
        linkActionEventToOp(frame.okButton, "enviarPedido");
        linkWindowClosingEventToOp(frame, "closed");
        
        // Adicionar propriedades observáveis para cada campo
        defineObsProperty("xPegar", 0);
        defineObsProperty("yPegar", 0);
        defineObsProperty("xDestino", 0);
        defineObsProperty("yDestino", 0);
        
        frame.setVisible(true);
    }

    @INTERNAL_OPERATION
    void enviarPedido(ActionEvent ev) {
        System.out.println(">> DEBUG: Método 'enviarPedido' foi chamado pelo clique do botão!");

        try {
            int xP = Integer.parseInt(frame.xPegar.getText());
            int yP = Integer.parseInt(frame.yPegar.getText());
            int xD = Integer.parseInt(frame.xDestino.getText());
            int yD = Integer.parseInt(frame.yDestino.getText());
            
            // Você também pode usar para ver os valores das variáveis
            System.out.println(">> DEBUG: Valores lidos -> xP=" + xP + ", yP=" + yP + ", xD=" + xD + ", yD=" + yD);
            
            signal("pedido_recebido", xP, yP, xD, yD);
            JOptionPane.showMessageDialog(frame, "Pedido enviado com sucesso!", "Confirmação", JOptionPane.INFORMATION_MESSAGE);
        } catch (NumberFormatException e) {
            // Tratar erro de conversão
            signal("error", "Valores inválidos");
        }
    }

    @OPERATION 
    void getValues(OpFeedbackParam<Integer> xPegar, OpFeedbackParam<Integer> yPegar, 
                   OpFeedbackParam<Integer> xDestino, OpFeedbackParam<Integer> yDestino) {
        try {
            xPegar.set(Integer.parseInt(frame.xPegar.getText()));
            yPegar.set(Integer.parseInt(frame.yPegar.getText()));
            xDestino.set(Integer.parseInt(frame.xDestino.getText()));
            yDestino.set(Integer.parseInt(frame.yDestino.getText()));
        } catch (NumberFormatException e) {
            failed("Valores inválidos", "invalid_values");
        }
    }

    @INTERNAL_OPERATION
    void closed(WindowEvent ev) {
        signal("closed");
    }

    class MyFrame extends JFrame {
        
        private JButton okButton;
        private JTextField xPegar;
        private JTextField yPegar;
        private JTextField xDestino;
        private JTextField yDestino;

        public MyFrame() {
            setTitle("Pedidos de entrega");
            setSize(370, 200);
            
            JPanel panel = new JPanel();
            
            JLabel label1 = new JLabel("Insira as coordenadas onde se encontra o pacote:");
            JLabel label2 = new JLabel("Insira as coordenadas para entrega:");
            
            xPegar = new JTextField(5);
            yPegar = new JTextField(5);
            xDestino = new JTextField(5);
            yDestino = new JTextField(5);
            
            okButton = new JButton("Enviar Pedido");
            
            panel.add(label1);
            panel.add(new JLabel("X:"));
            panel.add(xPegar);
            panel.add(new JLabel("Y:"));
            panel.add(yPegar);
            
            panel.add(label2);
            panel.add(new JLabel("X:"));
            panel.add(xDestino);
            panel.add(new JLabel("Y:"));
            panel.add(yDestino);
            
            panel.add(okButton);
            
            setContentPane(panel);
        }
    }
}
