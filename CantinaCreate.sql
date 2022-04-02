CREATE SCHEMA Cantina
GO

CREATE TABLE Cantina.CARGO (
Codigo			VARCHAR(76)		NOT NULL,
Descricao 		VARCHAR(300),
PRIMARY KEY (Codigo),
);

CREATE TABLE Cantina.FUNCIONARIO(
Id			INT			IDENTITY(1,1),
Fname			VARCHAR(32)		NOT NULL,
Lname			VARCHAR(32)		NOT NULL,
Email			VARCHAR(76)		NOT NULL		UNIQUE,
Ccodigo			VARCHAR(76)		NOT NULL,
Salario			DECIMAL(10,2),
PRIMARY KEY (Id),
CONSTRAINT fk_Funcionario_Cargo FOREIGN KEY(Ccodigo) REFERENCES Cantina.CARGO(Codigo),
);

CREATE TABLE Cantina.TURNO(
Datahora_inicio		VARCHAR(64)			NOT NULL,
Datahora_fim		VARCHAR(64)			NOT NULL,
PRIMARY KEY(Datahora_inicio, Datahora_fim),
);


CREATE TABLE Cantina.TURNO_ATRIBUIDO(
Datahora_inicio		VARCHAR(64)			NOT NULL,
Datahora_fim		VARCHAR(64)			NOT NULL,
Fid			INT			NOT NULL,
PRIMARY KEY(Datahora_inicio, Datahora_fim, Fid),
FOREIGN KEY(Fid) REFERENCES Cantina.Funcionario(Id),
FOREIGN KEY (Datahora_inicio, Datahora_fim) REFERENCES Cantina.TURNO (Datahora_inicio, Datahora_fim),
);

CREATE TABLE Cantina.TIPO_CLIENTE(
Id				INT			NOT NULL,
Nome			VARCHAR(32),
Preco			DECIMAL(10,2),
PRIMARY KEY(Id),
);

CREATE TABLE Cantina.CLIENTE(
Nif			INT			NOT NULL		CHECK (Nif > 100000000 AND Nif < 999999999),
Fname			VARCHAR(32),
Lname			VARCHAR(32),
Email			VARCHAR(76) NOT NULL,
Tipo			INT		NOT NULL,
PRIMARY KEY(Nif),
FOREIGN KEY (Tipo) REFERENCES Cantina.TIPO_CLIENTE (Id),
);

CREATE TABLE Cantina.COMPRA(
Cnif			INT			NOT NULL		CHECK (Cnif > 100000000 AND Cnif < 999999999),
Datahora		DATETIME			NOT NULL,
Ref_fatura		INT			IDENTITY(1,1),
Fid				INT			NOT NULL,
PRIMARY KEY (Ref_fatura),
FOREIGN KEY (Cnif) REFERENCES Cantina.CLIENTE (Nif),
FOREIGN KEY (Fid) REFERENCES Cantina.FUNCIONARIO (Id),
);

CREATE TABLE Cantina.PRATO(
Id			INT		IDENTITY(1,1),
Tipo			VARCHAR(76),
Nome			VARCHAR(76),
PRIMARY KEY (Id),
);

CREATE TABLE Cantina.CESTO_DE_COMPRA(
Pid			INT			NOT NULL,
C_ref_fatura		INT			NOT NULL,
PRIMARY KEY (Pid, C_ref_fatura),
FOREIGN KEY (Pid) REFERENCES Cantina.PRATO (Id),
FOREIGN KEY (C_ref_fatura) REFERENCES Cantina.COMPRA (Ref_fatura),
);

CREATE TABLE Cantina.MENU(
Id			INT            NOT NULL,
Nome			VARCHAR(76)				NOT NULL,
PRIMARY KEY (Id),
);

CREATE TABLE Cantina.COMPOSICAO_DO_MENU(
Pid			INT			NOT NULL,
Mid			INT			NOT NULL,
PRIMARY KEY (Mid, Pid),
FOREIGN KEY (Pid) REFERENCES Cantina.PRATO (Id),
FOREIGN KEY (Mid) REFERENCES Cantina.MENU (Id),
);

CREATE TABLE Cantina.DISPENSA(
Id			INT			NOT NULL,
Capacidade		DECIMAL(15,2)		NOT NULL,
CapacidadeAtual DECIMAL(15,2)		NOT NULL,
PRIMARY KEY (Id),
);

CREATE TABLE Cantina.INGREDIENTE(
Id			INT			IDENTITY(1,1),
Nome			VARCHAR(76),
Valor_nutritivo		DECIMAL(10,2),
Quantidade_disponivel	DECIMAL(10,2)		NOT NULL,
Alergenios		VARCHAR(76),
Did			INT,
PRIMARY KEY (Id),
FOREIGN KEY (Did) REFERENCES Cantina.DISPENSA (Id),
);


CREATE TABLE Cantina.COMPOSICAO_DO_PRATO(
Pid			INT			NOT NULL,
Iid			INT			NOT NULL,
PRIMARY KEY (Iid, Pid),
FOREIGN KEY (Pid) REFERENCES Cantina.PRATO (Id),
FOREIGN KEY (Iid) REFERENCES Cantina.INGREDIENTE (Id),
);