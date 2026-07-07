CREATE DATABASE IF NOT EXISTS aso_sistema;
USE aso_sistema;

CREATE TABLE empresa (
    ID_Empresa INT PRIMARY KEY AUTO_INCREMENT,
    Nome_Empresa VARCHAR(150) NOT NULL,
    CNPJ VARCHAR(18) UNIQUE,
    Email VARCHAR(120) UNIQUE,
    Telefone VARCHAR(20) UNIQUE,
    Endereco VARCHAR(200),
    Criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE funcionarios (
    ID_Funcionarios INT PRIMARY KEY AUTO_INCREMENT,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    Data_de_nascimento DATE,
    Cargo VARCHAR(100),
    Setor VARCHAR(100),
    Email VARCHAR(120) UNIQUE,
    ID_empresa INT,
    Nome VARCHAR(120) NOT NULL,
    Data_de_Admissao DATE,
    Celular VARCHAR(20) UNIQUE,
    WhatsApp VARCHAR(20) UNIQUE,
    Condicao VARCHAR(20),
    Criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_empresa) REFERENCES empresa(ID_Empresa)
);

CREATE TABLE aso (
    ID_ASO INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    Tipo_de_Exame VARCHAR(120),
    Data_de_vencimento DATE,
    Data_de_Emissao DATE,
    Resultado VARCHAR(50),
    Medico_Responsavel VARCHAR(120),
    Observacao TEXT,
    Condicao VARCHAR(20),
    Criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_funcionario) REFERENCES funcionarios(ID_Funcionarios)
);

CREATE TABLE registro_exclusao_aso (
    ID_Exclusao INT PRIMARY KEY AUTO_INCREMENT,
    ID_ASO INT NOT NULL,
    Motivo_Exclusao VARCHAR(255),
    Usuario_Exclusao VARCHAR(120),
    Data_Exclusao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_ASO) REFERENCES aso(ID_ASO)
);

INSERT INTO empresa (Nome_Empresa, CNPJ, Email, Telefone, Endereco)
VALUES
('AsoConnect', '11.222.333/0001-01', 'AssoConnect.contato@gmail.com', '(31)9234-4475', 'Avenida Afonso Pena 111');

INSERT INTO funcionarios (
    Nome,
    CPF,
    Celular,
    WhatsApp,
    Email,
    ID_empresa,
    Data_de_nascimento,
    Setor,
    Cargo,
    Condicao
)
VALUES
('Tele Santana', '403.975.670-72', '(31)9178-1581', '(31)8574-1591', 'tel@email.com', 1, '2006-04-21', 'Logistica', 'Auxiliar de logistica', 'ATIVO'),
('Hélio Campos', '657.707.950-18', '(31)92569-2362', '(31)92569-2362', 'helio@email.com', 1, '2008-11-02', 'TI', 'Desenvolvedor de sistemas', 'ATIVO'),
('Laís Bassilio', '917.334.310-20', '(31)9866-1044', '(31)9866-1044', 'lais@email.com', 1, '2006-09-17', 'Marketing', 'Assistente de marketing', 'ATIVO'),
('Miguel Otavio', '629.330.860-34', '(31)99234-4476', '(31)99234-4476', 'miguel@email.com', 1, '2008-08-30', 'TI', 'Desenvolvedor de banco de dados', 'ATIVO'),
('Arthur Original', '647.509.660-10', '(31)99783-0156', '(31)99783-0156', 'arthur@email.com', 1, '2009-11-22', 'Recursos Humanos', 'Auxiliar de recursos humanos', 'ATIVO'),
('Joao Pedro', '679.268.930-05', '(31)9834-0981', '(31)9834-0981', 'mengao@email.com', 1, '2008-10-19', 'Portaria', 'Porteiro', 'ATIVO');

INSERT INTO aso (
    id_funcionario,
    Condicao,
    Data_de_vencimento,
    Tipo_de_Exame,
    Data_de_Emissao,
    Medico_Responsavel,
    Resultado,
    Observacao
)
VALUES
(1, 'ATIVO', '2027-05-12', 'Periodico', '2026-05-12', 'DR. Claudio', 'APROVADO', 'TUDO OK'),
(2, 'ATIVO', '2026-06-06', 'Admissional', '2025-06-06', 'DR. Cleber', 'APROVADO', 'TUDO OK'),
(3, 'ATIVO', '2026-06-18', 'Retorno ao trabalho', '2026-05-19', 'DR. Vinicius', 'APROVADO', 'TUDO OK'),
(4, 'ATIVO', '2026-06-22', 'Periodico', '2025-06-22', 'DR. Bernardo', 'REPROVADO', 'REPROVADO POR DOENCAS CARDIACAS'),
(5, 'ATIVO', '2027-04-21', 'Demissional', '2026-04-21', 'DR. Helbert', 'APROVADO', 'TUDO OK'),
(6, 'ATIVO', '2022-11-23', 'Demissional', '2021-11-23', 'DR. Gabriel Barbosa', 'APROVADO', 'TUDO OK');

INSERT INTO registro_exclusao_aso (
    ID_ASO,
    Motivo_Exclusao,
    Usuario_Exclusao,
    Data_Exclusao
)
VALUES
(4, 'Erro no cadastro', 'Hélio', '2025-05-22'),
(3, 'Atualização de dados', 'Matheus', '2026-02-18'),
(1, 'Demissao', 'Luiz', '2026-05-21'),
(2, 'Exclusão', 'Miguel', '2024-08-18'),
(2, 'Exclusão', 'Danilo', '2025-05-18'),
(1, 'Demissao', 'Will', '2025-08-15');

-- Total de funcionários
SELECT COUNT(*) AS total_funcionarios
FROM funcionarios;

-- ASOs ativos
SELECT COUNT(*) AS asos_ativos
FROM aso
WHERE Condicao = 'ATIVO';

-- ASOs vencidos
SELECT COUNT(*) AS asos_vencidos
FROM aso
WHERE Data_de_vencimento < CURDATE();

-- ASOs vencendo em até 30 dias
SELECT COUNT(*) AS asos_vencendo
FROM aso
WHERE Data_de_vencimento 
BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

ALTER TABLE funcionarios
ADD COLUMN Foto VARCHAR(255);
UPDATE funcionarios
SET Foto = 'joao.jpg'
WHERE ID_Funcionarios = 6;

UPDATE funcionarios
SET Foto = 'maria.jpg'
WHERE ID_Funcionarios = 2;