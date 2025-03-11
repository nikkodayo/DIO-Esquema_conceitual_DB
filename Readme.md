## Esquema conceitual - Oficina mecânica

Este documento descreve o esquema conceitual de um sistema de controle e gerenciamento de ordens de serviço para uma oficina mecânica.

## Entidades e Atributos

Cliente:
idCliente (INT, PK)
nome (VARCHAR)
telefone (VARCHAR)
email (VARCHAR)
endereco (VARCHAR)

Veiculo:
idVeiculo (INT, PK)
idCliente (INT, FK)
placa (VARCHAR, UNIQUE)
modelo (VARCHAR)
marca (VARCHAR)
ano (INT)

Ordem de Serviço (OS):
idOS (INT, PK)
idVeiculo (INT, FK)
idEquipe (INT, FK)
data_emissao (DATE)
valor_total (FLOAT)
status (VARCHAR)
data_conclusao (DATE)

Equipe:
idEquipe (INT, PK)
nome (VARCHAR)

Mecanico:
idMecanico (INT, PK)
nome (VARCHAR)
endereco (VARCHAR)
especialidade (VARCHAR)
idEquipe (INT, FK)

Servico:
idServico (INT, PK)
descricao (VARCHAR)
valor_mao_obra (FLOAT)

Peca:
idPeca (INT, PK)
descricao (VARCHAR)
valor (FLOAT)

Relações:
Um Cliente pode ter vários Veículos (1:N).
Um Veículo pode gerar várias Ordens de Serviço (OS) (1:N).
Uma OS é atribuída a uma única Equipe (N:1).
Uma Equipe pode ter vários Mecânicos (1:N).
Um Mecânico pertence a uma única Equipe (N:1).
Uma OS pode conter vários Serviços (N:M), utilizando a relação intermediária OS_Servico.
Uma OS pode conter várias Peças (N:M), utilizando a relação intermediária OS_Peca.
Um Serviço pode estar em várias OS (N:M).
Uma Peça pode estar em várias OS (N:M).

Cálculo do Valor da OS:
O valor total da OS é a soma do custo da mão de obra dos serviços executados mais o valor das peças utilizadas.

Autorização de Serviço:
O Cliente deve autorizar a execução dos serviços antes do início da manutenção.

Status da OS:
Os status possíveis de uma OS incluem "Aguardando Autorização", "Em Execução", "Concluída" e "Cancelada".

Equipe de Mecânicos:
A mesma equipe é responsável por diagnosticar e executar os serviços de uma OS.

