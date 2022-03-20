CREATE TABLE Usuários (
    email VARCHAR(50) NOT NULL,
    saldoBits INTEGER,
    nomeUsuário VARCHAR(20) PRIMARY KEY,
    dataNascimento DATE NOT NULL,
    telefone CHAR(9),
    bio VARCHAR(300) 
);

CREATE TABLE UsuáriosPrime (
    fk_Usuários_nomeUsuário VARCHAR(20) PRIMARY KEY
);


CREATE TABLE CriadoresParceirosdaTwitch (
    saldoDinheiro INTEGER,
    fk_Usuários_nomeUsuário VARCHAR(20) PRIMARY KEY
);


CREATE TABLE Emotes (
    NomeEmote VARCHAR(20) PRIMARY KEY,
    imagem VARCHAR(50),
    fk_Inscrição_idInscrição CHAR(12)
);

CREATE TABLE Transmissão (
  	IdTransmissão CHAR(12) 	PRIMARY KEY,
    Data DATe,
    Inicio TIMESTAMP,
    númerodeespectadores INTEGER
);

CREATE TABLE Inscrição (
    idInscrição CHAR(12) PRIMARY KEY,
    inicio DATE,
    fim DATE,
    preço INTEGER,
    fk_Usuários_nomeUsuário VARCHAR(20),
    fk_CriadoresParceirosdaTwitch_fk_Usuários_nomeUsuário VARCHAR(20),
    fk_UsuáriosPrime_fk_Usuários_nomeUsuário VARCHAR(20)
);

CREATE TABLE Clipes (
    duração INTEGER,
    idClipe CHAR(12) PRIMARY KEY,
  	inicio 	INTEGER,
    visualizaçõesdoclipe INTEGER,
    fk_Usuários_nomeUsuário VARCHAR(20),
    fk_Transmissão_idTransmissão CHAR(12)
);

CREATE TABLE Anunciante (
    NomeEmpresa VARCHAR(20) PRIMARY KEY
);

CREATE TABLE Anúncio (
    númeroAnúncio CHAR(12) PRIMARY KEY,
    vídeo VARCHAR(50),
    fk_Anunciante_NomeEmpresa VARCHAR(20)
);

CREATE TABLE MensagemChat (
    texto VARCHAR(100),
    msg_timestamp timestamp PRIMARY KEY,
    fk_Transmissão_idTransmissão char(12),
    fk_Usuários_nomeUsuário varchar(20)
);

CREATE TABLE Categorias (
    nome VARCHAR(25) PRIMARY KEY
);

CREATE TABLE Tags (
    nome VARCHAR(25) PRIMARY KEY
);

CREATE TABLE Segue (
    fk_Usuários_nomeUsuário VARCHAR(20),
    fk_Usuários_nomeUsuário_ VARCHAR(20)
);

CREATE TABLE Sussurro (
    fk_Usuários_nomeUsuário VARCHAR(20),
    fk_Usuários_nomeUsuário_ VARCHAR(20),
    horário TIMESTAMP,
    texto VARCHAR(100)
);

CREATE TABLE Contém (
    fk_Transmissão_idTransmissão CHAR(12),
    fk_Anúncio_númeroAnúncio BIT
);

CREATE TABLE Categorização (
    fk_Transmissão_idTransmissão CHAR(12),
    fk_Categorias_nome VARCHAR(25)
);

CREATE TABLE Rotulação (
    fk_Tags_nome VARCHAR(25),
    fk_Categorias_nome VARCHAR(25)
);
 
ALTER TABLE CriadoresParceirosdaTwitch ADD CONSTRAINT FK_CriadoresParceirosdaTwitch_2
    FOREIGN KEY (fk_Usuários_nomeUsuário, fk_Usuários_nomeUsuário_)
    REFERENCES Usuários (nomeUsuário, nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE UsuáriosPrime ADD CONSTRAINT FK_Usuários Prime_2
    FOREIGN KEY (fk_Usuários_nomeUsuário)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Emotes ADD CONSTRAINT FK_Emotes_2
    FOREIGN KEY (fk_Inscrição_idInscrição)
    REFERENCES Inscrição (idInscrição)
    ON DELETE CASCADE;
 
ALTER TABLE Inscrição ADD CONSTRAINT FK_Inscrição_2
    FOREIGN KEY (fk_Usuários_nomeUsuário)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Inscrição ADD CONSTRAINT FK_Inscrição_3
    FOREIGN KEY (fk_Criadores Parceiros da Twitch_fk_Usuários_nomeUsuário)
    REFERENCES Criadores Parceiros da Twitch (fk_Usuários_nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Inscrição ADD CONSTRAINT FK_Inscrição_4
    FOREIGN KEY (fk_Usuários Prime_fk_Usuários_nomeUsuário)
    REFERENCES Usuários Prime (fk_Usuários_nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Transmissão ADD CONSTRAINT FK_Transmissão_2
    FOREIGN KEY (fk_Usuários_nomeUsuário)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Clipes ADD CONSTRAINT FK_Clipes_2
    FOREIGN KEY (fk_Usuários_nomeUsuário)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Clipes ADD CONSTRAINT FK_Clipes_3
    FOREIGN KEY (fk_Transmissão_idTransmissão)
    REFERENCES Transmissão (idTransmissão)
    ON DELETE CASCADE;
 
ALTER TABLE Anúncio ADD CONSTRAINT FK_Anúncio_2
    FOREIGN KEY (fk_Anunciante_NomeEmpresa)
    REFERENCES Anunciante (NomeEmpresa)
    ON DELETE CASCADE;
 
ALTER TABLE MensagemChat ADD CONSTRAINT FK_MensagemChat_2
    FOREIGN KEY (fk_Transmissão_idTransmissão)
    REFERENCES Transmissão (idTransmissão)
    ON DELETE CASCADE;
 
ALTER TABLE MensagemChat ADD CONSTRAINT FK_MensagemChat_3
    FOREIGN KEY (fk_Usuários_nomeUsuário)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Segue ADD CONSTRAINT FK_Segue_1
    FOREIGN KEY (fk_Usuários_nomeUsuário)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Segue ADD CONSTRAINT FK_Segue_2
    FOREIGN KEY (fk_Usuários_nomeUsuário_)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Sussurro ADD CONSTRAINT FK_Sussurro_2
    FOREIGN KEY (fk_Usuários_nomeUsuário)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Sussurro ADD CONSTRAINT FK_Sussurro_3
    FOREIGN KEY (fk_Usuários_nomeUsuário_)
    REFERENCES Usuários (nomeUsuário)
    ON DELETE CASCADE;
 
ALTER TABLE Contém ADD CONSTRAINT FK_Contém_1
    FOREIGN KEY (fk_Transmissão_idTransmissão)
    REFERENCES Transmissão (idTransmissão)
    ON DELETE SET NULL;
 
ALTER TABLE Contém ADD CONSTRAINT FK_Contém_2
    FOREIGN KEY (fk_Anúncio_númeroAnúncio)
    REFERENCES Anúncio (númeroAnúncio)
    ON DELETE SET NULL;
 
ALTER TABLE Categorização ADD CONSTRAINT FK_Categorização_1
    FOREIGN KEY (fk_Transmissão_idTransmissão)
    REFERENCES Transmissão (idTransmissão)
    ON DELETE SET NULL;
 
ALTER TABLE Categorização ADD CONSTRAINT FK_Categorização_2
    FOREIGN KEY (fk_Categorias_nome)
    REFERENCES Categorias (nome)
    ON DELETE SET NULL;
 
ALTER TABLE Rotulação ADD CONSTRAINT FK_Rotulação_1
    FOREIGN KEY (fk_Tags_nome)
    REFERENCES Tags (nome)
    ON DELETE SET NULL;
 
ALTER TABLE Rotulação ADD CONSTRAINT FK_Rotulação_2
    FOREIGN KEY (fk_Categorias_nome)
    REFERENCES Categorias (nome)
    ON DELETE SET NULL;
