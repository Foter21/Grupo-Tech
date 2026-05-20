
CREATE DATABASE IF NOT EXISTS aso_sistema;
USE aso_sistema;

CREATE TABLE empresa (
    ID_Empresa INT PRIMARY KEY AUTO_INCREMENT,
    Nome_Empresa VARCHAR(150) NOT NULL,
    CNPJ VARCHAR(20),
    Email VARCHAR(120),
    Telefone VARCHAR(20),
    Endereco VARCHAR(200),
    Criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE funcionarios (
    ID_Funcionarios INT PRIMARY KEY AUTO_INCREMENT,
    CPF VARCHAR(20) NOT NULL UNIQUE,
    Data_de_nascimento DATE,
    Cargo VARCHAR(100),
    Setor VARCHAR(100),
    Email VARCHAR(120),
    ID_empresa INT,
    Nome VARCHAR(120) NOT NULL,
    Data_de_Admissao DATE,
    Celular VARCHAR(20),
    Condição VARCHAR(20),
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
    Condição VARCHAR(20),
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


INSERT INTO empresa (ID_empresa, Nome_Empresa,Cnpj, Email, Telefone, Endereço)
VALUES
('221','AsoConnect','11.222.333/0001-01''AssoConnect.contato@gmail.com', '(31)9234-4475', 'Avenida afonso pena 111');


INSERT INTO funcionarios (
ID_Funcionarios, Nome, CPF, Celular, Email, ID_empresa, Data_de_nascimento, Setor, Cargo, Condição
)
VALUES
('2104', 'Telê Santana', '408.975.670-72', '(31)98888-1111', 'tele@email.com', '221','Logistica', 'auxiliar de logistica', ' ATIVO'),   
('1806', 'Hélio Campos', '657.707.950-18', '(31)98888-2222', 'helio@email.com', '221',  'TI', ' Desenvolvedor de sistemas', ' ATIVO'),
('2806','Laís Bassilio', '917.334.310-20', '(31)98888-3333', 'lais@email.com', '221', 'Marketing', 'Assistente de marketing', ' ATIVO'),
('1808','Miguel Otavio', '629.330.860-34', '(31)98888-4444', 'miguel@email.com', '221', 'TI', ' Desenvolvedor de banco de dados', 'ATIVO'),
('2234', 'Arthur Original', '647.509.660-10', '(31)98888-5555', 'arthur@email.com', '221', 'Recursos Humanos', 'Auxiliar de recursos humanos', 'ATIVO'),
('1895', 'Joao Pedro', '679.268.930-05', '(31)98888-6666', 'mengao@email.com', '221', 'Portaria', 'Porteiro', 'ATIVO');


INSERT INTO aso (
    id_funcionario, Condição , Data_de_vencimento, ID_ASO, Tipo_de_exame, Data_de_emissao, Medico_Responsavel, Resultado, Observacao
)
VALUES
('2104', 'ATIVO', '12/05/2027', '3', 'Periodico', '12/05/2026', 'DR.Claudio', 'APROVADO', 'TUDO OK'),
('1806', 'ATIVO', '06/06/2026', '1', 'Admissional', '06/06/2025', 'DR.Cleber', 'APROVADO', 'TUDO OK'), 
('2806', 'ATIVO', '18/06/2026','4', 'Retorno ao trabalho', '19/05/2026', 'DR. Vinicius', 'APROVADO', 'TUDO OK'), 
('1808', 'ATIVO', '22/06/2026', '3', 'Periodico', '22/06/2025', 'DR.Bernado', 'REPROVADO', 'REPROVADO POR DOENCAS CARDIACAS'), 
('2234', 'ATIVO', '21/04/2027', '1', 'Demissional', '21/04/2026', ' DR.HELBERT', 'APROVADO', 'TUDO OK'),
('1895', 'ATIVO', '23/11/2019', '1', 'Demissional', '23/11/2020', ' DR.GABRIEL BARBOSA', 'APROVADO', 'TUDO OK');

INSERT INTO registro_exclusao_aso (
    ID_ASO, Motivo_Exclusao, Usuario_Exclusao, ID_Exclusao, Data_Exclusao
)
VALUES
(4, 'Erro no cadastro', 'HELIO', '8', '22/05/2025'),
(3, 'Atualização de dados', 'MATHEUS','5', '18/02/2026'),
(1, 'Demissao', 'LUIZ', '1', ' 21/05/2026'),
(2, 'Exclusao', 'MIGUEL', '6', '18/08/2024'),
(2, 'Exclusao', 'DANILO', '6', '18/05/2025'),
(1, 'Demissao', 'WILL', '1', ' 15/08/2025');


