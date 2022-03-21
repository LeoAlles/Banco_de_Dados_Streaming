DROP TABLE IF EXISTS usuarios,usuariosprime,criadoresparceirosdatwitch,emotes,transmissao,inscricao,clipes,anunciante,anuncio,mensagemchat,categorizacao,categorias,tags,sussurro,segue,contem,rotulacao;


CREATE TABLE Usuarios (
    email VARCHAR(50) NOT NULL,
    saldoBits INTEGER,
    nomeUsuario VARCHAR(20),
    dataNascimento DATE NOT NULL,
    telefone CHAR(9),
    bio VARCHAR(300),
  	PRIMARY KEY (nomeUsuario)
);

CREATE TABLE UsuariosPrime (
    fk_Usuarios_nomeUsuario VARCHAR(20) PRIMARY KEY
);
   

CREATE TABLE CriadoresParceirosdaTwitch (
    saldoDinheiro INTEGER,
    fk_Usuarios_nomeUsuario VARCHAR(20) PRIMARY KEY
);


CREATE TABLE Emotes (
    NomeEmote VARCHAR(20) PRIMARY KEY,
    imagem VARCHAR(50),
    fk_Inscricao_idInscricao CHAR(12)
);

CREATE TABLE Transmissao (
    Inicio TIMESTAMP PRIMARY KEY,
  	Fim TIMESTAMP,
    numeroDeEspectadores INTEGER,
  	nome VARCHAR(40),
  	fk_Usuarios_nomeUsuario VARCHAR(20)
);

CREATE TABLE Inscricao (
    idInscricao CHAR(12) PRIMARY KEY,
    inicio DATE,
    fim DATE,
    preco INTEGER,
    fk_Usuarios_nomeUsuario VARCHAR(20),
    fk_CriadoresParceirosdaTwitch_fk_Usuarios_nomeUsuario VARCHAR(20),
    fk_UsuariosPrime_fk_Usuarios_nomeUsuario VARCHAR(20)
);

CREATE TABLE Clipes (
    duracao INTEGER,
    idClipe CHAR(12) PRIMARY KEY,
  	inicio 	INTEGER,
    visualizacoesDoClipe INTEGER,
    fk_Usuarios_nomeUsuario VARCHAR(20),
  	fk_Transmissao_Inicio TIMESTAMP
);

CREATE TABLE Anunciante (
    NomeEmpresa VARCHAR(20) PRIMARY KEY
);

CREATE TABLE Anuncio (
    numeroAnuncio INTEGER,
    video VARCHAR(50),
    fk_Anunciante_NomeEmpresa VARCHAR(20),
  	PRIMARY KEY(numeroanuncio)
);

CREATE TABLE MensagemChat (
    texto VARCHAR(100),
    msg_timestamp timestamp PRIMARY KEY,
    fk_Transmissao_Inicio TIMESTAMP,
    fk_Usuarios_nomeUsuario varchar(20)
);

CREATE TABLE Categorias (
    nome VARCHAR(25) PRIMARY KEY
);

CREATE TABLE Tags (
    nome VARCHAR(25) PRIMARY KEY
);

CREATE TABLE Segue (
    fk_Usuarios_nomeUsuario VARCHAR(20),
    fk_Usuarios_nomeUsuario_ VARCHAR(20)
);

CREATE TABLE Sussurro (
    fk_Usuarios_nomeUsuario VARCHAR(20),
    fk_Usuarios_nomeUsuario_ VARCHAR(20),
    horario TIMESTAMP,
    texto VARCHAR(100),
  	PRIMARY KEY(fk_Usuarios_nomeUsuario,fk_Usuarios_nomeUsuario_,horario)
);

CREATE TABLE Contem (
    fk_Transmissao_Inicio TIMESTAMP,
    fk_Anuncio_numeroAnuncio INTEGER
);

CREATE TABLE Categorizacao (
    fk_Transmissao_Inicio TIMESTAMP,
    fk_Categorias_nome VARCHAR(25)
);

CREATE TABLE Rotulacao (
    fk_Tags_nome VARCHAR(25),
    fk_Categorias_nome VARCHAR(25)
);
 

ALTER TABLE CriadoresParceirosdaTwitch ADD CONSTRAINT FK_CriadoresParceirosdaTwitch_2
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE UsuariosPrime ADD CONSTRAINT FK_UsuariosPrime_2
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
    
ALTER TABLE Emotes ADD CONSTRAINT FK_Emotes_2
    FOREIGN KEY (fk_Inscricao_idInscricao)
    REFERENCES Inscricao (idInscricao)
    ON DELETE CASCADE;
 
ALTER TABLE Inscricao ADD CONSTRAINT FK_Inscricao_2
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Inscricao ADD CONSTRAINT FK_Inscricao_3
    FOREIGN KEY (fk_CriadoresParceirosdaTwitch_fk_Usuarios_nomeUsuario)
    REFERENCES CriadoresParceirosdaTwitch (fk_Usuarios_nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Inscricao ADD CONSTRAINT FK_Inscricao_4
    FOREIGN KEY (fk_UsuariosPrime_fk_Usuarios_nomeUsuario)
    REFERENCES UsuariosPrime (fk_Usuarios_nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Transmissao ADD CONSTRAINT FK_Transmissao_2
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Clipes ADD CONSTRAINT FK_Clipes_2
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Clipes ADD CONSTRAINT FK_Clipes_3
    FOREIGN KEY (fk_Transmissao_Inicio)
    REFERENCES Transmissao (Inicio)
    ON DELETE CASCADE;
    
ALTER TABLE Anuncio ADD CONSTRAINT FK_Anuncio_2
    FOREIGN KEY (fk_Anunciante_NomeEmpresa)
    REFERENCES Anunciante (NomeEmpresa)
    ON DELETE CASCADE; 

 
ALTER TABLE MensagemChat ADD CONSTRAINT FK_MensagemChat_2
    FOREIGN KEY (fk_Transmissao_Inicio)
    REFERENCES Transmissao (Inicio)
    ON DELETE CASCADE;
 
ALTER TABLE MensagemChat ADD CONSTRAINT FK_MensagemChat_3
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Segue ADD CONSTRAINT FK_Segue_1
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Segue ADD CONSTRAINT FK_Segue_2
    FOREIGN KEY (fk_Usuarios_nomeUsuario_)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Sussurro ADD CONSTRAINT FK_Sussurro_2
    FOREIGN KEY (fk_Usuarios_nomeUsuario)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Sussurro ADD CONSTRAINT FK_Sussurro_3
    FOREIGN KEY (fk_Usuarios_nomeUsuario_)
    REFERENCES Usuarios (nomeUsuario)
    ON DELETE CASCADE;
 
ALTER TABLE Contem ADD CONSTRAINT FK_Contem_1
    FOREIGN KEY (fk_Transmissao_Inicio)
    REFERENCES Transmissao (inicio)
    ON DELETE SET NULL;
 
ALTER TABLE Contem ADD CONSTRAINT FK_Contem_2
    FOREIGN KEY (fk_Anuncio_numeroAnuncio)
    REFERENCES Anuncio (numeroAnuncio)
    ON DELETE SET NULL;
 
ALTER TABLE Categorizacao ADD CONSTRAINT FK_Categorizacao_1
    FOREIGN KEY (fk_Transmissao_Inicio)
    REFERENCES Transmissao (inicio)
    ON DELETE SET NULL;
 
ALTER TABLE Categorizacao ADD CONSTRAINT FK_Categorizacao_2
    FOREIGN KEY (fk_Categorias_nome)
    REFERENCES Categorias (nome)
    ON DELETE SET NULL;
 
ALTER TABLE Rotulacao ADD CONSTRAINT FK_Rotulacao_1
    FOREIGN KEY (fk_Tags_nome)
    REFERENCES Tags (nome)
    ON DELETE SET NULL;
 
ALTER TABLE Rotulacao ADD CONSTRAINT FK_Rotulacao_2
    FOREIGN KEY (fk_Categorias_nome)
    REFERENCES Categorias (nome)
    ON DELETE SET NULL;
 
