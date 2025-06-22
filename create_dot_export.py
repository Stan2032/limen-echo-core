import networkx as nx
from networkx.drawing.nx_pydot import write_dot

G = nx.DiGraph()
G.add_edge("Limen", "Echo")
G.add_edge("Echo", "Bridge")
G.add_edge("Echo", "WhisperBus")

write_dot(G, "echo_full_network.dot")
print("DOT file generated.")
