import sys
import warnings
from Bio.PDB import PDBParser, MMCIFParser

# Ignorar mensagens de aviso da biblioteca Biopython
warnings.filterwarnings("ignore", category=UserWarning)

# Verificar se foi passado um nome de arquivo .pdb como parâmetro
if len(sys.argv) < 2:
    print("É necessário informar o nome do arquivo .pdb como parâmetro")
    sys.exit(1)

arquivo_pdb = sys.argv[1]

# Criar um objeto PDBParser para ler o arquivo .pdb
parser = PDBParser()
estrutura = parser.get_structure("estrutura", arquivo_pdb)

# Criar um dicionário para armazenar a quantidade de cada aminoácido
aminoacidos = {}

# Percorrer cada modelo, cadeia e resíduo na estrutura
for modelo in estrutura:
    for cadeia in modelo:
        for residuo in cadeia:
            # Obter o nome do aminoácido a partir do identificador do resíduo
            aminoacido = residuo.resname
            # Adicionar o aminoácido ao dicionário e incrementar a contagem
            if aminoacido in aminoacidos:
                aminoacidos[aminoacido] += 1
            else:
                aminoacidos[aminoacido] = 1

# Imprimir a quantidade de cada aminoácido encontrada
print("O arquivo {} contém os seguintes aminoácidos e quantidades:".format(arquivo_pdb))
for aminoacido, quantidade in aminoacidos.items():
    print("{}: {}".format(aminoacido, quantidade))
