!test_gui.

+!test_gui
    <- makeArtifact("gui","artifacts.Pedidos_de_entrega",[],Id);
    focus(Id).

+value(V)
    <- println("Value updated: ",V).

+ok : value(V)
    <- setValue(V+1).

+closed
    <- .my_name(Me);
    .kill_agent(Me).
