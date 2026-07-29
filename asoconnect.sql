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
('AsoConnect', '11.222.333/0001-01', 'asoconnect.contato@gmail.com', '(31)9234-4475', 'Avenida Afonso Pena 111'),
('MedSaúde Ocupacional', '22.333.444/0001-02', 'contato@medsaude.com.br', '(31) 91234-5678', 'Rua das Flores, 250'),
('SegVida Medicina', '33.444.555/0001-03', 'atendimento@segvida.com.br', '(31) 92345-6789', 'Av. Brasil, 890'),
('VidaLab Exames', '44.555.666/0001-04', 'contato@vidalab.com.br', '(31) 93456-7890', 'Rua São José, 145'),
('Prime Saúde Empresarial', '55.666.777/0001-05', 'suporte@primesaude.com.br', '(31) 94567-8901', 'Av. Amazonas, 1200'),
('BioMed Ocupacional', '66.777.888/0001-06', 'contato@biomedocupacional.com.br', '(31) 95678-9012', 'Rua da Bahia, 550');
INSERT INTO funcionarios (
    CPF,
    Data_de_nascimento,
    Cargo,
    Setor,
    Email,
    ID_empresa,
    Nome,
    Data_de_Admissao,
    Celular,
    WhatsApp,
    Foto,
    Condicao
)
VALUES
('403.975.670-72','2006-04-21','Auxiliar de Logística','Logística','tele@email.com',1,'Tele Santana','2026-01-10','(31)91781-5810','(31)98741-5910','tele.jpg','ATIVO'),
('657.707.950-18','2008-11-02','Desenvolvedor de Sistemas','TI','helio@email.com',1,'Hélio Campos','2026-01-10','(31)92569-2362','(31)98569-2362','helio.jpg','ATIVO'),
('917.334.310-20','2006-09-17','Assistente de Marketing','Marketing','lais@email.com',1,'Laís Gabriela','2026-01-10','(31)98661-0440','(31)99661-0440','lais.jpg','ATIVO'),
('629.330.860-34','2008-08-30','Desenvolvedor de Banco de Dados','TI','miguel@email.com',1,'Miguel Otavio','2026-01-10','(31)99234-4476','(31)98234-4476','miguel.jpg','ATIVO'),
('647.509.660-10','2009-11-22','Auxiliar de Recursos Humanos','Recursos Humanos','arthur@email.com',1,'Arthur Original','2026-01-10','(31)99783-0156','(31)98783-0156','arthur.jpg','ATIVO'),
('111.222.333-01','1997-05-12','Supervisor de Logística','Logística','carlos@email.com',2,'Carlos Henrique','2026-02-01','(31)99111-0001','(31)98111-0001','carlos.jpg','ATIVO'),
('111.222.333-02','1999-09-21','Analista Financeiro','Financeiro','amanda@email.com',2,'Amanda Souza','2026-02-01','(31)99111-0002','(31)98111-0002','amanda.jpg','ATIVO'),
('111.222.333-03','1998-01-15','Analista de Suporte','TI','bruno@email.com',2,'Bruno Ferreira','2026-02-01','(31)99111-0003','(31)98111-0003','bruno.jpg','ATIVO'),
('111.222.333-04','2000-07-30','Assistente de RH','RH','juliana@email.com',2,'Juliana Martins','2026-02-01','(31)99111-0004','(31)98111-0004','juliana.jpg','ATIVO'),
('111.222.333-05','1996-12-18','Comprador','Compras','rafael@email.com',2,'Rafael Lima','2026-02-01','(31)99111-0005','(31)98111-0005','rafael.jpg','ATIVO'),
('222.333.444-01','1995-06-10','Assistente Administrativo','Administrativo','patricia@email.com',3,'Patricia Gomes','2026-03-01','(31)99222-0001','(31)98222-0001','patricia.jpg','ATIVO'),
('222.333.444-02','1998-08-23','Programador','TI','lucas@email.com',3,'Lucas Almeida','2026-03-01','(31)99222-0002','(31)98222-0002','lucas.jpg','ATIVO'),
('222.333.444-03','1999-11-02','Designer','Marketing','fernanda@email.com',3,'Fernanda Silva','2026-03-01','(31)99222-0003','(31)98222-0003','fernanda.jpg','ATIVO'),
('222.333.444-04','1994-02-18','Vendedor','Comercial','diego@email.com',3,'Diego Rocha','2026-03-01','(31)99222-0004','(31)98222-0004','diego.jpg','ATIVO'),
('222.333.444-05','1997-04-27','Inspetor de Qualidade','Qualidade','camila@email.com',3,'Camila Ribeiro','2026-03-01','(31)99222-0005','(31)98222-0005','camila.jpg','ATIVO'),
('333.444.555-01','1993-09-12','Operador','Produção','eduardo@email.com',4,'Eduardo Pereira','2026-04-01','(31)99333-0001','(31)98333-0001','eduardo.jpg','ATIVO'),
('333.444.555-02','1998-01-20','Analista de RH','RH','mariana@email.com',4,'Mariana Costa','2026-04-01','(31)99333-0002','(31)98333-0002','mariana.jpg','ATIVO'),
('333.444.555-03','1996-07-14','Administrador de Redes','TI','gustavo@email.com',4,'Gustavo Oliveira','2026-04-01','(31)99333-0003','(31)98333-0003','gustavo.jpg','ATIVO'),
('333.444.555-04','2000-10-05','Auxiliar Financeiro','Financeiro','beatriz@email.com',4,'Beatriz Santos','2026-04-01','(31)99333-0004','(31)98333-0004','beatriz.jpg','ATIVO'),
('333.444.555-05','1995-03-08','Técnico em Segurança do Trabalho','Segurança','vinicius@email.com',4,'Vinicius Melo','2026-04-01','(31)99333-0005','(31)98333-0005','vinicius.jpg','ATIVO'),
('444.555.666-01','1997-12-11','Conferente','Logística','thiago@email.com',5,'Thiago Barbosa','2026-05-01','(31)99444-0001','(31)98444-0001','thiago.jpg','ATIVO'),
('444.555.666-02','1999-05-17','Social Media','Marketing','larissa@email.com',5,'Larissa Nunes','2026-05-01','(31)99444-0002','(31)98444-0002','larissa.jpg','ATIVO'),
('444.555.666-03','1996-04-01','Analista de Sistemas','TI','pedro@email.com',5,'Pedro Augusto','2026-05-01','(31)99444-0003','(31)98444-0003','pedro.jpg','ATIVO'),
('444.555.666-04','1998-02-09','Assistente de Compras','Compras','natalia@email.com',5,'Natália Moraes','2026-05-01','(31)99444-0004','(31)98444-0004','natalia.jpg','ATIVO'),
('444.555.666-05','1995-08-28','Supervisor de Produção','Produção','leonardo@email.com',5,'Leonardo Alves','2026-05-01','(31)99444-0005','(31)98444-0005','leonardo.jpg','ATIVO'),
('555.666.777-01','1994-11-06','Desenvolvedor Full Stack','TI','gabriel@email.com',6,'Gabriel Moreira','2026-06-01','(31)99555-0001','(31)98555-0001','gabriel.jpg','ATIVO'),
('555.666.777-02','1998-07-16','Contadora','Financeiro','isabela@email.com',6,'Isabela Freitas','2026-06-01','(31)99555-0002','(31)98555-0002','isabela.jpg','ATIVO'),
('555.666.777-03','1997-03-25','Consultor Comercial','Comercial','matheus@email.com',6,'Matheus Rodrigues','2026-06-01','(31)99555-0003','(31)98555-0003','matheus.jpg','ATIVO'),
('555.666.777-04','1999-10-18','Coordenadora de RH','RH','aline@email.com',6,'Aline Carvalho','2026-06-01','(31)99555-0004','(31)98555-0004','aline.jpg','ATIVO'),
('555.666.777-05','1996-01-30','Técnico em Manutenção','Manutenção','renato@email.com',6,'Renato Lopes','2026-06-01','(31)99555-0005','(31)98555-0005','renato.jpg','ATIVO');
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

ALTER TABLE registro_exclusao_aso



ADD COLUMN Data_de_Emissao DATE AFTER Data_de_vencimento,
ADD COLUMN Resultado VARCHAR(50) AFTER Data_de_Emissao,
ADD COLUMN Medico_Responsavel VARCHAR(120) AFTER Resultado,
ADD COLUMN Observacao TEXT AFTER Medico_Responsavel,
ADD COLUMN Condicao VARCHAR(20) AFTER Observacao,
ADD COLUMN Criado_em DATETIME AFTER Condicao;

create table registro_exclusao_aso (
    ID_Exclusao INT AUTO_INCREMENT PRIMARY KEY,
    ID_ASO INT NOT NULL,
    id_funcionario INT,
    Tipo_de_Exame VARCHAR(120),
    Data_de_vencimento DATE,
    Data_de_Emissao DATE,
    Resultado VARCHAR(50),
    Medico_Responsavel VARCHAR(120),
    Observacao TEXT,
    Condicao VARCHAR(20),
    Criado_em DATETIME,
    Motivo_Exclusao VARCHAR(255),
    Usuario_Exclusao VARCHAR(120),
    Data_Exclusao DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    38,
    'Admissional',
    '2026-08-05',
    '2026-07-05',
    'APROVADO',
    'Dr. Ricardo Alves',
    'Apto para exercer a função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    39,
    'Periódico',
    '2026-08-12',
    '2025-08-12',
    'APROVADO',
    'Dra. Mariana Costa',
    'Exames dentro dos padrões',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    40,
    'Retorno ao Trabalho',
    '2026-08-20',
    '2026-07-20',
    'APROVADO',
    'Dr. Felipe Rocha',
    'Liberado para retorno às atividades',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    41,
    'Periódico',
    '2026-07-25',
    '2025-07-25',
    'APROVADO',
    'Dra. Paula Mendes',
    'ASO vencido, necessário renovar',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    42,
    'Mudança de Função',
    '2027-01-15',
    '2026-07-15',
    'APROVADO',
    'Dr. André Lima',
    'Apto para exercer a nova função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    43,
    'Periódico',
    '2026-08-01',
    '2025-08-01',
    'APROVADO',
    'Dra. Camila Freitas',
    'Sem alterações clínicas',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    44,
    'Admissional',
    '2027-03-10',
    '2026-03-10',
    'APROVADO',
    'Dr. Marcelo Nunes',
    'Funcionário apto',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    45,
    'Periódico',
    '2026-08-26',
    '2025-08-26',
    'REPROVADO',
    'Dra. Fernanda Ribeiro',
    'Necessita avaliação complementar',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    46,
    'Demissional',
    '2026-07-10',
    '2026-06-10',
    'APROVADO',
    'Dr. Roberto Dias',
    'Exame demissional concluído',
    'INATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    47,
    'Periódico',
    '2026-08-18',
    '2025-08-18',
    'APROVADO',
    'Dra. Bianca Lopes',
    'Sem restrições ocupacionais',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    48,
    'Admissional',
    '2027-04-22',
    '2026-04-22',
    'APROVADO',
    'Dr. Fábio Almeida',
    'Apto para admissão',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    49,
    'Periódico',
    '2026-07-30',
    '2025-07-30',
    'APROVADO',
    'Dra. Renata Ribeiro',
    'ASO próximo do vencimento',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    50,
    'Retorno ao Trabalho',
    '2026-08-15',
    '2026-07-15',
    'APROVADO',
    'Dr. Sérgio Moura',
    'Apto para retorno ao trabalho',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    51,
    'Periódico',
    '2027-05-05',
    '2026-05-05',
    'APROVADO',
    'Dra. Luciana Pinto',
    'Tudo dentro dos padrões',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    52,
    'Mudança de Função',
    '2026-08-08',
    '2026-07-08',
    'APROVADO',
    'Dr. Paulo Henrique',
    'Apto para mudança de função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    53,
    'Periódico',
    '2026-06-30',
    '2025-06-30',
    'REPROVADO',
    'Dra. Amanda Torres',
    'ASO vencido e com pendência médica',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    54,
    'Admissional',
    '2027-06-18',
    '2026-06-18',
    'APROVADO',
    'Dr. Leandro Martins',
    'Funcionário apto para admissão',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    55,
    'Periódico',
    '2026-08-03',
    '2025-08-03',
    'APROVADO',
    'Dra. Carolina Reis',
    'ASO próximo do vencimento',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    56,
    'Demissional',
    '2026-07-18',
    '2026-06-18',
    'APROVADO',
    'Dr. Daniel Castro',
    'Exame demissional concluído',
    'INATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    57,
    'Periódico',
    '2026-08-22',
    '2025-08-22',
    'APROVADO',
    'Dra. Priscila Gomes',
    'Sem restrições médicas',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    58,
    'Retorno ao Trabalho',
    '2027-02-14',
    '2026-07-14',
    'APROVADO',
    'Dr. Felipe Souza',
    'Liberado para retorno',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    59,
    'Periódico',
    '2026-08-10',
    '2025-08-10',
    'APROVADO',
    'Dra. Patrícia Nunes',
    'Apto sem restrições',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    60,
    'Mudança de Função',
    '2027-07-01',
    '2026-07-01',
    'APROVADO',
    'Dr. Gustavo Mendes',
    'Apto para exercer nova função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    61,
    'Periódico',
    '2026-08-25',
    '2025-08-25',
    'REPROVADO',
    'Dra. Juliana Martins',
    'Necessita realizar exames complementares',
    'ATIVO'
);
INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    38,
    'Admissional',
    '2026-08-05',
    '2026-07-05',
    'APROVADO',
    'Dr. Ricardo Alves',
    'Apto para exercer a função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    39,
    'Periódico',
    '2026-08-12',
    '2025-08-12',
    'APROVADO',
    'Dra. Mariana Costa',
    'Exames dentro dos padrões',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    40,
    'Retorno ao Trabalho',
    '2026-08-20',
    '2026-07-20',
    'APROVADO',
    'Dr. Felipe Rocha',
    'Liberado para retorno às atividades',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    41,
    'Periódico',
    '2026-07-25',
    '2025-07-25',
    'APROVADO',
    'Dra. Paula Mendes',
    'ASO vencido, necessário renovar',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    42,
    'Mudança de Função',
    '2027-01-15',
    '2026-07-15',
    'APROVADO',
    'Dr. André Lima',
    'Apto para exercer a nova função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    43,
    'Periódico',
    '2026-08-01',
    '2025-08-01',
    'APROVADO',
    'Dra. Camila Freitas',
    'Sem alterações clínicas',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    44,
    'Admissional',
    '2027-03-10',
    '2026-03-10',
    'APROVADO',
    'Dr. Marcelo Nunes',
    'Funcionário apto',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    45,
    'Periódico',
    '2026-08-26',
    '2025-08-26',
    'REPROVADO',
    'Dra. Fernanda Ribeiro',
    'Necessita avaliação complementar',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    46,
    'Demissional',
    '2026-07-10',
    '2026-06-10',
    'APROVADO',
    'Dr. Roberto Dias',
    'Exame demissional concluído',
    'INATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    47,
    'Periódico',
    '2026-08-18',
    '2025-08-18',
    'APROVADO',
    'Dra. Bianca Lopes',
    'Sem restrições ocupacionais',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    48,
    'Admissional',
    '2027-04-22',
    '2026-04-22',
    'APROVADO',
    'Dr. Fábio Almeida',
    'Apto para admissão',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    49,
    'Periódico',
    '2026-07-30',
    '2025-07-30',
    'APROVADO',
    'Dra. Renata Ribeiro',
    'ASO próximo do vencimento',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    50,
    'Retorno ao Trabalho',
    '2026-08-15',
    '2026-07-15',
    'APROVADO',
    'Dr. Sérgio Moura',
    'Apto para retorno ao trabalho',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    51,
    'Periódico',
    '2027-05-05',
    '2026-05-05',
    'APROVADO',
    'Dra. Luciana Pinto',
    'Tudo dentro dos padrões',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    52,
    'Mudança de Função',
    '2026-08-08',
    '2026-07-08',
    'APROVADO',
    'Dr. Paulo Henrique',
    'Apto para mudança de função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    53,
    'Periódico',
    '2026-06-30',
    '2025-06-30',
    'REPROVADO',
    'Dra. Amanda Torres',
    'ASO vencido e com pendência médica',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    54,
    'Admissional',
    '2027-06-18',
    '2026-06-18',
    'APROVADO',
    'Dr. Leandro Martins',
    'Funcionário apto para admissão',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    55,
    'Periódico',
    '2026-08-03',
    '2025-08-03',
    'APROVADO',
    'Dra. Carolina Reis',
    'ASO próximo do vencimento',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    56,
    'Demissional',
    '2026-07-18',
    '2026-06-18',
    'APROVADO',
    'Dr. Daniel Castro',
    'Exame demissional concluído',
    'INATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    57,
    'Periódico',
    '2026-08-22',
    '2025-08-22',
    'APROVADO',
    'Dra. Priscila Gomes',
    'Sem restrições médicas',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    58,
    'Retorno ao Trabalho',
    '2027-02-14',
    '2026-07-14',
    'APROVADO',
    'Dr. Felipe Souza',
    'Liberado para retorno',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    59,
    'Periódico',
    '2026-08-10',
    '2025-08-10',
    'APROVADO',
    'Dra. Patrícia Nunes',
    'Apto sem restrições',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    60,
    'Mudança de Função',
    '2027-07-01',
    '2026-07-01',
    'APROVADO',
    'Dr. Gustavo Mendes',
    'Apto para exercer nova função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    61,
    'Periódico',
    '2026-08-25',
    '2025-08-25',
    'REPROVADO',
    'Dra. Juliana Martins',
    'Necessita realizar exames complementares',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    38,
    'Admissional',
    '2026-08-05',
    '2026-07-05',
    'APROVADO',
    'Dr. Ricardo Alves',
    'Apto para exercer a função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    39,
    'Periódico',
    '2026-08-12',
    '2025-08-12',
    'APROVADO',
    'Dra. Mariana Costa',
    'Exames dentro dos padrões',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    40,
    'Retorno ao Trabalho',
    '2026-08-20',
    '2026-07-20',
    'APROVADO',
    'Dr. Felipe Rocha',
    'Liberado para retorno às atividades',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    41,
    'Periódico',
    '2026-07-25',
    '2025-07-25',
    'APROVADO',
    'Dra. Paula Mendes',
    'ASO vencido, necessário renovar',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    42,
    'Mudança de Função',
    '2027-01-15',
    '2026-07-15',
    'APROVADO',
    'Dr. André Lima',
    'Apto para exercer a nova função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    43,
    'Periódico',
    '2026-08-01',
    '2025-08-01',
    'APROVADO',
    'Dra. Camila Freitas',
    'Sem alterações clínicas',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    44,
    'Admissional',
    '2027-03-10',
    '2026-03-10',
    'APROVADO',
    'Dr. Marcelo Nunes',
    'Funcionário apto',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    45,
    'Periódico',
    '2026-08-26',
    '2025-08-26',
    'REPROVADO',
    'Dra. Fernanda Ribeiro',
    'Necessita avaliação complementar',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    46,
    'Demissional',
    '2026-07-10',
    '2026-06-10',
    'APROVADO',
    'Dr. Roberto Dias',
    'Exame demissional concluído',
    'INATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    47,
    'Periódico',
    '2026-08-18',
    '2025-08-18',
    'APROVADO',
    'Dra. Bianca Lopes',
    'Sem restrições ocupacionais',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    48,
    'Admissional',
    '2027-04-22',
    '2026-04-22',
    'APROVADO',
    'Dr. Fábio Almeida',
    'Apto para admissão',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    49,
    'Periódico',
    '2026-07-30',
    '2025-07-30',
    'APROVADO',
    'Dra. Renata Ribeiro',
    'ASO próximo do vencimento',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    50,
    'Retorno ao Trabalho',
    '2026-08-15',
    '2026-07-15',
    'APROVADO',
    'Dr. Sérgio Moura',
    'Apto para retorno ao trabalho',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    51,
    'Periódico',
    '2027-05-05',
    '2026-05-05',
    'APROVADO',
    'Dra. Luciana Pinto',
    'Tudo dentro dos padrões',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    52,
    'Mudança de Função',
    '2026-08-08',
    '2026-07-08',
    'APROVADO',
    'Dr. Paulo Henrique',
    'Apto para mudança de função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    53,
    'Periódico',
    '2026-06-30',
    '2025-06-30',
    'REPROVADO',
    'Dra. Amanda Torres',
    'ASO vencido e com pendência médica',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    54,
    'Admissional',
    '2027-06-18',
    '2026-06-18',
    'APROVADO',
    'Dr. Leandro Martins',
    'Funcionário apto para admissão',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    55,
    'Periódico',
    '2026-08-03',
    '2025-08-03',
    'APROVADO',
    'Dra. Carolina Reis',
    'ASO próximo do vencimento',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    56,
    'Demissional',
    '2026-07-18',
    '2026-06-18',
    'APROVADO',
    'Dr. Daniel Castro',
    'Exame demissional concluído',
    'INATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    57,
    'Periódico',
    '2026-08-22',
    '2025-08-22',
    'APROVADO',
    'Dra. Priscila Gomes',
    'Sem restrições médicas',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    58,
    'Retorno ao Trabalho',
    '2027-02-14',
    '2026-07-14',
    'APROVADO',
    'Dr. Felipe Souza',
    'Liberado para retorno',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    59,
    'Periódico',
    '2026-08-10',
    '2025-08-10',
    'APROVADO',
    'Dra. Patrícia Nunes',
    'Apto sem restrições',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    60,
    'Mudança de Função',
    '2027-07-01',
    '2026-07-01',
    'APROVADO',
    'Dr. Gustavo Mendes',
    'Apto para exercer nova função',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    61,
    'Periódico',
    '2026-08-25',
    '2025-08-25',
    'REPROVADO',
    'Dra. Juliana Martins',
    'Necessita realizar exames complementares',
    'ATIVO'
);

INSERT INTO aso (
    id_funcionario,
    Tipo_de_Exame,
    Data_de_vencimento,
    Data_de_Emissao,
    Resultado,
    Medico_Responsavel,
    Observacao,
    Condicao
) VALUES (
    62,
    'Admissional',
    '2027-07-20',
    '2026-07-20',
    'APROVADO',
    'Dr. Eduardo Nunes',
    'Apto para exercer as atividades',
    'ATIVO'
);

SELECT ID_Funcionarios, Nome
FROM funcionarios
ORDER BY ID_Funcionarios;


drop table funcionarios
