DROP TABLE IF EXISTS Usuarios,Usuariosprime,CriadoresParceirosdaTwitch,Emotes,Transmissao,Inscricao,Clipes,Anunciante,Anuncio,MensagemChat,Categorizacao,Categorias,Tags,Sussurro,Segue,Contem,Rotulacao,Cheer,Visualizacao;

CREATE TABLE Usuarios (
    email VARCHAR(50) NOT NULL,
    saldoBits INTEGER,
    nomeUsuario VARCHAR(20) NOT NULL,
    dataNascimento DATE NOT NULL,
    telefone CHAR(9),
    bio VARCHAR(300),
  	PRIMARY KEY (nomeUsuario)
);

CREATE TABLE CriadoresParceirosdaTwitch (
    saldoDinheiro INTEGER,
    criadorParceiro VARCHAR(20) PRIMARY KEY NOT NULL,
  	FOREIGN KEY (criadorParceiro) REFERENCES Usuarios(nomeUsuario) ON DELETE CASCADE
);

CREATE TABLE Inscricao (
    idInscricao CHAR(12) PRIMARY KEY NOT NULL,
    inicio DATE NOT NULL,
    fim DATE NOT NULL,
    preco INTEGER NOT NULL,
  	criadorParceiro VARCHAR(20) not NULL,
    nomeUsuario VARCHAR(20),
  	FOREIGN KEY (criadorParceiro) REFERENCES CriadoresParceirosdaTwitch(criadorParceiro) ON DELETE CASCADE,
  	FOREIGN KEY (nomeUsuario) REFERENCES Usuarios(nomeUsuario) ON DELETE CASCADE
);

CREATE TABLE UsuariosPrime (
    nomeUsuarioPrime VARCHAR(20) PRIMARY KEY NOT NULL,
  	idInscricaoPrime CHAR(12),
  	FOREIGN KEY (nomeUsuarioPrime) REFERENCES Usuarios (nomeUsuario) ON DELETE CASCADE,
  	FOREIGN Key (idInscricaoPrime) REFERENCES Inscricao(idInscricao) on DELETE set NULL
);
   
CREATE TABLE Transmissao (
  	idTransmissao char(12) PRIMARY KEY not NULL,
    Inicio TIMESTAMP NOT NULL,
  	Fim TIMESTAMP NOT NULL,
  	nome VARCHAR(40) NOT NULL,
  	criador VARCHAR(20) NOT NULL,
    FOREIGN KEY (criador) REFERENCES Usuarios(nomeUsuario) ON DELETE CASCADE
);


CREATE TABLE Emotes (
    nomeEmote VARCHAR(20) NOT NULL,
    imagem VARCHAR(50) NOT NULL,
    idInscricao CHAR(12),
  	PRIMARY KEY(idInscricao,NomeEmote),
  	FOREIGN KEY (idInscricao) REFERENCES Inscricao(idInscricao) ON DELETE CASCADE
);


CREATE TABLE Clipes (
    duracao INTEGER NOT NULL,
    idClipe CHAR(12) PRIMARY KEY NOT NULL,
  	inicio 	INTEGER NOT NULL,
    visualizacoesDoClipe INTEGER NOT NULL,
    nomeUsuario VARCHAR(20) NOT NULL,
  	idTransmissao char(12) NOT NULL,
  	FOREIGN KEY (nomeUsuario) REFERENCES Usuarios(nomeUsuario) ON DELETE CASCADE,
    FOREIGN KEY (idTransmissao) REFERENCES Transmissao(idTransmissao) ON DELETE CASCADE
);

CREATE TABLE Anunciante (
    nomeEmpresa VARCHAR(20) PRIMARY KEY NOT NULL
);

CREATE TABLE Anuncio (
    numeroAnuncio INTEGER NOT NULL,
    video VARCHAR(50)NOT NULL,
    nomeEmpresa VARCHAR(20) NOT NULL,
  	FOREIGN KEY(nomeEmpresa) REFERENCES Anunciante(nomeEmpresa)ON DELETE CASCADE,
  	PRIMARY KEY(numeroAnuncio),
  	UNIQUE(nomeEmpresa,numeroAnuncio)
);
    
CREATE TABLE MensagemChat (
    texto VARCHAR(100) NOT NULL,
    msgTimestamp timestamp NOT NULL,
    idTransmissao char(12) NOT NULL,
    nomeUsuario varchar(20) NOT NULL,
  	PRIMARY KEY(nomeUsuario,msgTimestamp),
  	FOREIGN KEY (idTransmissao) REFERENCES Transmissao(idTransmissao) ON DELETE CASCADE,
  	FOREIGN KEY (nomeUsuario) REFERENCES Usuarios(nomeUsuario) ON DELETE CASCADe
);


CREATE TABLE Categorias (
    nomeCategoria VARCHAR(25) PRIMARY KEY NOT NULL
);

CREATE TABLE Tags (
    nomeTag VARCHAR(25) PRIMARY KEY NOT NULL
);

CREATE TABLE Segue (
    nomeUsuarioSegue VARCHAR(20) NOT NULL,
    nomeUsuarioSeguido VARCHAR(20) NOT NULL,
  	PRIMARY KEY(nomeUsuarioSegue, nomeUsuarioSeguido),
    FOREIGN KEY (nomeUsuarioSegue) REFERENCES Usuarios (nomeUsuario) ON DELETE CASCADE,
  	FOREIGN KEY (nomeUsuarioSeguido) REFERENCES Usuarios (nomeUsuario) ON DELETE CASCADE
);



CREATE TABLE Sussurro (
    nomeUsuarioManda VARCHAR(20) NOT NULL,
    nomeUsuarioRecebe VARCHAR(20) NOT NULL,
    horario TIMESTAMP NOT NULL,
    texto VARCHAR(100) NOT NULL,
  	PRIMARY KEY(nomeUsuarioManda,nomeUsuarioRecebe,horario),
    FOREIGN KEY (nomeUsuarioManda) REFERENCES Usuarios (nomeUsuario) ON DELETE CASCADE,
  	FOREIGN KEY (nomeUsuarioRecebe) REFERENCES Usuarios (nomeUsuario) ON DELETE CASCADE
);

CREATE TABLE Contem (
    idTransmissao char(12) NOT NULL,
    numeroAnuncio INTEGER NOT NULL,
  	PRIMARY KEY(idTransmissao,numeroAnuncio),
    FOREIGN KEY (idTransmissao) REFERENCES Transmissao(idTransmissao) ON DELETE SET NULL,
  	FOREIGN KEY (numeroAnuncio) REFERENCES Anuncio(numeroAnuncio) ON DELETE SET NULL
);

CREATE TABLE Categorizacao (
    idTransmissao char(12) NOT NULL,
   	nomeCategoria VARCHAR(25) NOT NULL,
  	PRIMARY KEY(idTransmissao,nomeCategoria),
  	FOREIGN KEY (idTransmissao) REFERENCES Transmissao(idTransmissao) ON DELETE SET NULL
);

CREATE TABLE Rotulacao (
    nomeTag VARCHAR(25) NOT NULL,
    nomeCategoria VARCHAR(25) NOT NULL,
  	PRIMARY KEY(nomeTag,nomeCategoria),
  	FOREIGN KEY (nomeTag) REFERENCES Tags (nomeTag) ON DELETE SET NULL,
  	FOREIGN KEY (nomeCategoria) REFERENCES Categorias (nomeCategoria)
);

CREATE TABLE Cheer(
    nomeUsuario VARCHAR(20) NOT NULL,
    criadorParceiro VARCHAR(20) NOT NULL,
    numerodebits INTEGER NOT NULL,
    horario TIMESTAMP NOT NULL,
  	PRIMARY KEY(nomeUsuario,criadorParceiro,horario),
  	FOREIGN KEY (nomeUsuario) REFERENCES Usuarios(nomeUsuario) ON DELETE RESTRICT,
  	FOREIGN KEY (criadorParceiro) REFERENCES CriadoresParceirosdaTwitch(criadorParceiro) ON DELETE SET NULL
);

CREATE TABLE Visualizacao(
	nomeUsuario VARCHAR(20) NOT NULL,
 	idTransmissao char(12),
    FOREIGN KEY (nomeUsuario) REFERENCES Usuarios(nomeUsuario) ON DELETE set NULL,
  	FOREIGN KEY (idTransmissao) REFERENCES Transmissao(idTransmissao) on DELETE cascade
);

INSERT INTO Usuarios VALUES('email1@email.com',0,'User1','2001-05-01','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('email2@email.com',15,'User2','2001-06-11','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('email3@email.com',19,'User3','2001-09-11','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('email4@email.com',4,'User4','2002-12-01','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('email5@email.com',19,'User5','2001-11-21','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('email6@email.com',4,'User6','2009-12-31','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('email7@email.com',3,'User7','2009-12-31','123456789','Sou um user da Twitch');

INSERT INTO CriadoresParceirosdaTwitch VALUES(10,'User4');
INSERT INTO CriadoresParceirosdaTwitch VALUES(14,'User5');
INSERT INTO CriadoresParceirosdaTwitch VALUES(20,'User6');
INSERT INTO CriadoresParceirosdaTwitch VALUES(23,'User7');

INSERT INTO Inscricao VALUES('123456789012', '2009-12-31','2009-12-31', 10, 'User5', 'User1');
INSERT INTO Inscricao VALUES('123456789013', '2009-12-31','2009-12-31', 10, 'User6', 'User4');
INSERT INTO Inscricao VALUES('123456789014', '2009-12-31','2009-12-31', 10, 'User4', 'User3');
INSERT INTO Inscricao VALUES('123456789015', '2009-12-31','2010-02-26', 15, 'User4', 'User2');

INSERT INTO UsuariosPrime VALUES('User4','123456789012');
INSERT INTO UsuariosPrime VALUES('User5','123456789014');
INSERT INTO UsuariosPrime VALUES('User6');

INSERT INTO Segue VALUES('User1', 'User2');
INSERT INTO Segue VALUES('User2', 'User3');
INSERT INTO Segue VALUES('User3', 'User1');

INSERT INTO Emotes VALUES('carinha feliz','emotes/img1','123456789012');
INSERT INTO Emotes VALUES('carinha triste','emotes/img2','123456789013');
INSERT INTO Emotes VALUES('bola de futebol','emotes/img3','123456789014');
 
INSERT INTO Transmissao VALUES('123456789011','2004-10-19 10:23:54','2004-10-19 10:54:54','Transmissao 1', 'User5');
INSERT INTO Transmissao VALUES('123456789012','2004-10-19 10:23:57','2004-10-19 11:54:54','Transmissao 2', 'User6');
INSERT INTO Transmissao VALUES('123456789013','2004-10-19 11:23:54','2004-10-19 16:54:54','Transmissao 3', 'User4');
INSERT INTO Transmissao VALUES('123456789014','2004-10-19 11:23:54','2004-10-19 16:54:54','Transmissao 4', 'User7');

INSERT INTO Clipes VALUES('142', '123456789012', 543, 12, 'User1','123456789011');
INSERT INTO Clipes VALUES('156', '123456789013', 1543, 16, 'User1','123456789012');
INSERT INTO Clipes VALUES('172', '123456789015', 5441, 21, 'User1','123456789012');

INSERT INTO Anunciante VALUES('DELL');
INSERT INTO Anunciante VALUES('INTEL');
INSERT INTO Anunciante VALUES('APPLE');

INSERT INTO Anuncio VALUES(4,'anuncios/video1', 'DELL');
INSERT INTO Anuncio VALUES(5,'anuncios/video2', 'DELL');
INSERT INTO Anuncio VALUES(1,'anuncios/video3', 'APPLE');

INSERT INTO MensagemChat VALUES('Ola, que dia bonito', '2004-10-19 11:23:54', '123456789011', 'User1');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:23:56', '123456789013', 'User2');
INSERT INTO MensagemChat VALUES('Vou bem', '2004-11-19 10:23:59', '123456789013', 'User1');

INSERT INTO Categorias VALUES ('CSGO');
INSERT INTO Categorias VALUES ('Esporte');
INSERT INTO Categorias VALUES ('DOTA2');

INSERT INTO Cheer VALUES('User4','User4',20,'2020-02-7 07:12:15');
INSERT INTO Cheer VALUES('User1','User5',20,'2020-02-7 07:12:15');
INSERT INTO Cheer VALUES('User2','User6',20,'2020-02-7 07:12:15');

INSERT INTO Sussurro VALUES('User1','User2','2020-02-7 07:12:15','eae');
INSERT INTO Sussurro VALUES('User1','User3','2020-02-7 07:12:15','qualquer coisa');
INSERT INTO Sussurro VALUES('User2','User1','2020-02-7 08:12:15','eae a');

insert INTO Tags VALUES('Shooter');
insert INTO Tags VALUES('FPS');
insert INTO Tags VALUES('Action');
insert INTO Tags VALUES('MOBA');
insert INTO Tags VALUES('Strategy');


INSERT INTO Segue VALUES('User2','User1');
INSERT INTO Segue VALUES('User1','User4');


Insert INtO categorizacao values('123456789011','CSGO');
Insert INtO categorizacao values('123456789012','CSGO');
Insert INtO categorizacao values('123456789013','DOTA2');

insert into Rotulacao values('Shooter','CSGO');
insert into Rotulacao values('FPS','CSGO');
insert into Rotulacao values('Action','CSGO');
insert into Rotulacao values('Action','DOTA2');
insert into Rotulacao values('MOBA','DOTA2');
INSERT INTO rotulacao values('Strategy','DOTA2');
insert into Rotulacao values('Action','Esporte');

SELECT * FROM Usuarios;
SELECT * FROM UsuariosPrime;
SELECT * FROM CriadoresParceirosdaTwitch;
SELECT * FROM Inscricao;
SELECT * FROM Segue;
SELECT * FROM Emotes;
SELECT * FROM Transmissao;
SELECT * FROM Clipes;
SELECT * FROM Anunciante;
SELECT * FROM Anuncio;
SELECT * FROM MensagemChat;
SELECT * FROM cheer;
SELECT * FROM Categorias;
SELECT * FROM Sussurro;
SELECT * FROM Tags;   


--Ranking de criadorpareceiro em relação a quantos inscritos eles tem (MODIFICAR, tem que usar 3 tabelas por consulta)
SELECT criadorparceiro, COUNT(criadorparceiro) as nroInscritos
from inscricao
GROUP by criadorparceiro
order by nroInscritos DESC;

--Tags que rotulam 2 ou mais transmissões
SELECT nometag
from categorizacao JOIN transmissao USING(idtransmissao) join rotulacao using(nomecategoria)
group by nometag
HAVING count(idtransmissao) >= 2;





--
