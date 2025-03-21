-- Criando o banco de dados
CREATE DATABASE OficinaMecanica;
USE OficinaMecanica;

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(255)
);

-- Tabela Cliente Pessoa Física
CREATE TABLE Cliente_PF (
    idCliente INT PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

-- Tabela Cliente Pessoa Jurídica
CREATE TABLE Cliente_PJ (
    idCliente INT PRIMARY KEY,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

-- Tabela Veiculo
CREATE TABLE Veiculo (
    idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(50),
    marca VARCHAR(50),
    ano INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

-- Tabela Equipe
CREATE TABLE Equipe (
    idEquipe INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

-- Tabela Mecanico
CREATE TABLE Mecanico (
    idMecanico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    especialidade VARCHAR(50),
    idEquipe INT NOT NULL,
    FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe) ON DELETE SET NULL
);

-- Tabela Ordem de Serviço (OS)
CREATE TABLE OS (
    idOS INT PRIMARY KEY AUTO_INCREMENT,
    idVeiculo INT NOT NULL,
    idEquipe INT NOT NULL,
    data_emissao DATE NOT NULL,
    valor_total FLOAT,
    status VARCHAR(50),
    data_conclusao DATE,
    FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo) ON DELETE CASCADE,
    FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe) ON DELETE SET NULL
);

-- Tabela Serviço
CREATE TABLE Servico (
    idServico INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    valor_mao_obra FLOAT NOT NULL
);

-- Tabela Peça
CREATE TABLE Peca (
    idPeca INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(255) NOT NULL,
    valor FLOAT NOT NULL
);

-- Tabela de relacionamento entre OS e Serviço (N:M)
CREATE TABLE OS_Servico (
    idOS INT NOT NULL,
    idServico INT NOT NULL,
    PRIMARY KEY (idOS, idServico),
    FOREIGN KEY (idOS) REFERENCES OS(idOS) ON DELETE CASCADE,
    FOREIGN KEY (idServico) REFERENCES Servico(idServico) ON DELETE CASCADE
);

-- Tabela de relacionamento entre OS e Peça (N:M)
CREATE TABLE OS_Peca (
    idOS INT NOT NULL,
    idPeca INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (idOS, idPeca),
    FOREIGN KEY (idOS) REFERENCES OS(idOS) ON DELETE CASCADE,
    FOREIGN KEY (idPeca) REFERENCES Peca(idPeca) ON DELETE CASCADE
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    idPagamento INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    tipo_pagamento VARCHAR(50) NOT NULL,  -- Ex: Cartão, Boleto, PIX
    dados_pagamento VARCHAR(255),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

-- Tabela Entrega
CREATE TABLE Entrega (
    idEntrega INT PRIMARY KEY AUTO_INCREMENT,
    idOS INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    codigo_rastreio VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (idOS) REFERENCES OS(idOS) ON DELETE CASCADE
);

-- CONSULTAS

-- 1. Quantos pedidos foram feitos por cada cliente?
SELECT C.idCliente, C.nome, COUNT(OS.idOS) AS total_ordens
FROM Cliente C
LEFT JOIN Veiculo V ON C.idCliente = V.idCliente
LEFT JOIN OS ON V.idVeiculo = OS.idVeiculo
GROUP BY C.idCliente, C.nome;

-- 2. Clientes com mais de uma forma de pagamento
SELECT idCliente, COUNT(idPagamento) AS total_pagamentos
FROM Pagamento
GROUP BY idCliente
HAVING COUNT(idPagamento) > 1;

-- 3. Lista de mecânicos e suas especialidades
SELECT nome, especialidade FROM Mecanico;

-- 4. Pedidos com status 'Em trânsito'
SELECT OS.idOS, Entrega.codigo_rastreio, Entrega.status
FROM OS
JOIN Entrega ON OS.idOS = Entrega.idOS
WHERE Entrega.status = 'Em trânsito';

-- 5. Relatório de serviços executados por cada OS
SELECT OS.idOS, S.descricao, S.valor_mao_obra
FROM OS
JOIN OS_Servico OSS ON OS.idOS = OSS.idOS
JOIN Servico S ON OSS.idServico = S.idServico;
