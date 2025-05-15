// package artifacts;

// import java.awt.event.ActionEvent;
// import java.awt.event.WindowEvent;

// import javax.swing.BoxLayout;
// import javax.swing.JButton;
// import javax.swing.JFrame;
// import javax.swing.JLabel;
// import javax.swing.JPanel;
// import javax.swing.JTextField;

// import cartago.INTERNAL_OPERATION;
// import cartago.OPERATION;
// import cartago.tools.GUIArtifact;


// public class CaixaDeSomJarvis extends GUIArtifact {

//     private InterfaceCaixaDeSom frame;

//     public void setup() {
				
// 		create_frame();
// 	}
	
// 	void create_frame() {
// 		frame = new InterfaceCaixaDeSom();
		
// 		frame.setVisible(true);		
// 	}

//     class InterfaceCaixaDeSom extends JFrame {	
		
// 		private JButton okButton;
// 		private JTextField saidaCaixaDeSom;
//         private JTextField entradaCaixaDeSom;
		
// 		public InterfaceCaixaDeSom(){
// 			setTitle(" Caixa de Som ");
// 			setSize(200,300);
						
// 			JPanel panel = new JPanel();
// 			JLabel saida = new JLabel();
// 			saida.setText("Saida Caixa de Som:    ");
//             JLabel entrada = new JLabel();
// 			entrada.setText("Entrada Caixa de Som: ");
// 			setContentPane(panel);
			
// 			okButton = new JButton("ok");
// 			okButton.setSize(80,50);
			
// 			saidaCaixaDeSom = new JTextField(10);
// 			saidaCaixaDeSom.setText("Bom dia");
// 			saidaCaixaDeSom.setEditable(true);
			
// 			entradaCaixaDeSom = new JTextField(10);
// 			entradaCaixaDeSom.setText("");
// 			entradaCaixaDeSom.setEditable(true);
			
// 			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
// 			panel.add(saida);
// 			panel.add(saidaCaixaDeSom);
// 			panel.add(entrada);
// 			panel.add(entradaCaixaDeSom);
// 			panel.add(okButton);
			
// 		}
		
// 		public String getsaidaCaixaDeSom(){
// 			return saidaCaixaDeSom.getText();
// 		}
		
// 		public String getentradaCaixaDeSom(){
// 			return entradaCaixaDeSom.getText();
// 		}
// 	}

// }