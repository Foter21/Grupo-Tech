CREATE DATABASE IF NOT EXISTS aso_sistema
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE aso_sistema;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS registro_exclusao_aso;
DROP TABLE IF EXISTS aso;
DROP TABLE IF EXISTS funcionarios;
DROP TABLE IF EXISTS empresa;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE empresa (
    ID_Empresa INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Empresa VARCHAR(150) NOT NULL,
    CNPJ VARCHAR(18) NOT NULL UNIQUE,
    Email VARCHAR(120) UNIQUE,
    Telefone VARCHAR(20) UNIQUE,
    Endereco VARCHAR(200),
    Criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE funcionarios (
    ID_Funcionarios INT AUTO_INCREMENT PRIMARY KEY,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    Data_de_nascimento DATE,
    Cargo VARCHAR(100),
    Setor VARCHAR(100),
    Email VARCHAR(120) UNIQUE,
    ID_empresa INT NOT NULL,
    Nome VARCHAR(120) NOT NULL,
    Data_de_Admissao DATE,
    Celular VARCHAR(20) UNIQUE,
    WhatsApp VARCHAR(20) UNIQUE,
    Foto VARCHAR(255),
    Condicao VARCHAR(20) DEFAULT 'ATIVO',
    Criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_funcionarios_empresa
        FOREIGN KEY (ID_empresa)
        REFERENCES empresa(ID_Empresa)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE aso (
    ID_ASO INT AUTO_INCREMENT PRIMARY KEY,
    id_funcionario INT NOT NULL,
    Tipo_de_Exame VARCHAR(120),
    Data_de_vencimento DATE,
    Data_de_Emissao DATE,
    Resultado VARCHAR(50),
    Medico_Responsavel VARCHAR(120),
    Observacao TEXT,
    Condicao VARCHAR(20) DEFAULT 'ATIVO',
    Criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_aso_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionarios(ID_Funcionarios)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE registro_exclusao_aso (
    ID_Exclusao INT AUTO_INCREMENT PRIMARY KEY,
    ID_ASO INT NOT NULL,
    Motivo_Exclusao VARCHAR(255),
    Usuario_Exclusao VARCHAR(120),
    Data_Exclusao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_exclusao_aso
        FOREIGN KEY (ID_ASO)
        REFERENCES aso(ID_ASO)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO empresa (Nome_Empresa, CNPJ, Email, Telefone, Endereco)
VALUES
('AsoConnect', '11.222.333/0001-01', 'asoconnect.contato@gmail.com', '(31)9234-4475', 'Avenida Afonso Pena 111');

INSERT INTO funcionarios (
    Nome,
    CPF,
    Celular,
    WhatsApp,
    Email,
    ID_empresa,
    Data_de_nascimento,
    Data_de_Admissao,
    Setor,
    Cargo,
    Foto,
    Condicao
)
VALUES
('Tele Santana', '403.975.670-72', '(31)9178-1581', '(31)8574-1591', 'tel@email.com', 1, '2006-04-21', '2026-01-10', 'Logistica', 'Auxiliar de logistica', 'tele.jpg', 'ATIVO'),
('Hélio Campos', '657.707.950-18', '(31)92569-2362', '(31)92569-2362', 'helio@email.com', 1, '2008-11-02', '2026-01-10', 'TI', 'Desenvolvedor de sistemas', 'helio.jpg', 'ATIVO'),
('Laís Gabriela', '917.334.310-20', '(31)9866-1044', '(31)9866-1044', 'lais@email.com', 1, '2006-09-17', '2026-01-10', 'Marketing', 'Assistente de marketing', 'lais.jpg', 'ATIVO'),
('Miguel Otavio', '629.330.860-34', '(31)99234-4476', '(31)99234-4476', 'miguel@email.com', 1, '2008-08-30', '2026-01-10', 'TI', 'Desenvolvedor de banco de dados', 'miguel.jpg', 'ATIVO'),
('Arthur Original', '647.509.660-10', '(31)99783-0156', '(31)99783-0156', 'arthur@email.com', 1, '2009-11-22', '2026-01-10', 'Recursos Humanos', 'Auxiliar de recursos humanos', 'arthur.jpg', 'ATIVO'),
('Joao Pedro', '679.268.930-05', '(31)9834-0981', '(31)9834-0981', 'mengao@email.com', 1, '2008-10-19', '2026-01-10', 'Portaria', 'Porteiro', 'joao.jpg', 'ATIVO');

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
(4, 'Erro no cadastro', 'Hélio', '2025-05-22 00:00:00'),
(3, 'Atualização de dados', 'Matheus', '2026-02-18 00:00:00'),
(1, 'Demissao', 'Luiz', '2026-05-21 00:00:00'),
(2, 'Exclusão', 'Miguel', '2024-08-18 00:00:00'),
(2, 'Exclusão', 'Danilo', '2025-05-18 00:00:00'),
(1, 'Demissao', 'Will', '2025-08-15 00:00:00');

-- Consulta para testar a tela principal do Flask
SELECT
    aso.*,
    funcionarios.Nome AS Nome_funcionario,
    funcionarios.Foto AS Foto
FROM aso
INNER JOIN funcionarios
    ON aso.id_funcionario = funcionarios.ID_Funcionarios
ORDER BY aso.ID_ASO ASC;

-- Códigos para testar o login:
-- Código da Empresa = ID_empresa
-- Código de Acesso = ID_Funcionarios
SELECT
    f.ID_empresa AS codigo_empresa,
    f.ID_Funcionarios AS codigo_acesso,
    f.Nome,
    e.Nome_Empresa
FROM funcionarios f
INNER JOIN empresa e
    ON f.ID_empresa = e.ID_Empresa
ORDER BY f.ID_Funcionarios ASC


