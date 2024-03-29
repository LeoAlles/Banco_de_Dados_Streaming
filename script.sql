DROP TABLE IF EXISTS Usuarios,Usuariosprime,CriadoresParceirosdaTwitch,Emotes,Transmissao,Inscricao,Clipes,Anunciante,Anuncio,MensagemChat,Categorizacao,Categorias,Tags,Sussurro,Segue,Contem,Rotulacao,Cheer,Visualizacao,Anunciou;

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
    
create TABLE Anunciou(
	numeroAnuncio INTEGER NOT NULL,
	idTransmissao char(12) NOT NULL,
    FOREIGN key (numeroanuncio) REFERENCES Anuncio(numeroAnuncio) on delete CASCADE,
    FOREIGN KEY (idTransmissao) REFERENCES Transmissao(idTransmissao) ON DELETE set NULL
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

INSERT INTO Usuarios VALUES('Joao@email.com',0,'Joao','2001-05-01','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Pedro@email.com',15,'Pedro','2001-06-11','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Leonardo@email.com',19,'Leonardo','2001-09-11','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Gabriella@email.com',4,'Gabriella','2002-12-01','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Nikolas@email.com',19,'Nikolas','2001-11-21','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Maria@email.com',4,'Maria','2009-12-31','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Helena@email.com',3,'Helena','2009-12-31','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Leticia@email.com',0,'Leticia','2001-05-01','123456789','Sou um user da Twitch');

INSERT INTO Usuarios VALUES('Carlos@email.com',15,'Carlos','2001-06-11','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Matheus@email.com',19,'Matheus','2001-09-11','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Gabriela@email.com',4,'Gabriela','2002-12-01','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Renata@email.com',19,'Renata','2001-11-21','123456789','Sou um user da Twitch');

INSERT INTO Usuarios VALUES('Gaules@email.com',3,'Gaules','2009-12-31','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Alanzoka@email.com',3,'Alanzoka','2009-12-31','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Lett@email.com',3,'Lett','2009-12-31','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('Shroud@email.com',3,'Shroud','2009-12-31','123456789','Sou um user da Twitch');
INSERT INTO Usuarios VALUES('criadorvazio@email.com',3,'CriadorVazio','2009-12-31','123456789','Sou um user da Twitch');

INSERT INTO CriadoresParceirosdaTwitch VALUES(10,'Gaules');
INSERT INTO CriadoresParceirosdaTwitch VALUES(14,'Alanzoka');
INSERT INTO CriadoresParceirosdaTwitch VALUES(20,'Lett');
INSERT INTO CriadoresParceirosdaTwitch VALUES(23,'Shroud');
INSERT INTO CriadoresParceirosdaTwitch VALUES(23,'CriadorVazio');


INSERT INTO Inscricao VALUES('123456789011', '2009-12-31','2009-12-31', 10, 'Gaules', 'Joao');
INSERT INTO Inscricao VALUES('123456789012', '2009-12-31','2009-12-31', 10, 'Gaules', 'Pedro');
INSERT INTO Inscricao VALUES('123456789013', '2009-12-31','2009-12-31', 10, 'Gaules', 'Leonardo');
INSERT INTO Inscricao VALUES('123456789014', '2009-12-31','2009-12-31', 10, 'Gaules', 'Lett');
INSERT INTO Inscricao VALUES('123456789020', '2009-12-31','2010-02-26', 15, 'Gaules', 'Maria');

INSERT INTO Inscricao VALUES('123456789015', '2009-12-31','2009-12-31', 10, 'Lett', 'Gaules');
INSERT INTO Inscricao VALUES('123456789016', '2009-12-31','2010-02-26', 15, 'Lett', 'Gabriela');
INSERT INTO Inscricao VALUES('123456789017', '2009-12-31','2009-12-31', 10, 'Lett', 'Renata');
INSERT INTO Inscricao VALUES('123456789018', '2009-12-31','2010-02-26', 15, 'Lett', 'Nikolas');

INSERT INTO Inscricao VALUES('123456789019', '2009-12-31','2009-12-31', 10, 'Alanzoka', 'Nikolas');
INSERT INTO Inscricao VALUES('123456789010', '2009-12-31','2010-02-26', 15, 'Alanzoka', 'Carlos');

INSERT INTO UsuariosPrime VALUES('Leonardo','123456789013');
INSERT INTO UsuariosPrime VALUES('Matheus');
INSERT INTO UsuariosPrime VALUES('Gabriela','123456789016');
INSERT INTO UsuariosPrime VALUES('Renata','123456789017');
INSERT INTO UsuariosPrime VALUES('Maria','123456789020');


INSERT INTO Segue VALUES('Gaules', 'Shroud');
INSERT INTO Segue VALUES('Lett', 'Shroud');
INSERT INTO Segue VALUES('Alanzoka', 'Shroud');
INSERT INTO Segue VALUES('Leonardo', 'Shroud');
INSERT INTO Segue VALUES('Nikolas', 'Gaules');
INSERT INTO Segue VALUES('Maria', 'Shroud');
INSERT INTO Segue VALUES('Leonardo', 'Nikolas');
INSERT INTO Segue VALUES('Nikolas', 'Leonardo');
INSERT INTO Segue VALUES('Nikolas','Alanzoka');
INSERT INTO Segue VALUES('Leonardo', 'Gaules');
INSERT INTO Segue VALUES('Gaules', 'Lett');
INSERT INTO Segue VALUES('Gaules', 'Alanzoka');
INSERT INTO Segue VALUES('Gaules', 'Leonardo');
INSERT INTO Segue VALUES('Leonardo', 'CriadorVazio');


INSERT INTO Emotes VALUES('carinha feliz','emotes/img1','123456789012');
INSERT INTO Emotes VALUES('carinha triste','emotes/img2','123456789012');
INSERT INTO Emotes VALUES('bola de futebol','emotes/img3','123456789012');

INSERT INTO Emotes VALUES('carinha feliz','emotes/img1','123456789013');
INSERT INTO Emotes VALUES('carinha triste','emotes/img2','123456789013');
INSERT INTO Emotes VALUES('bola de futebol','emotes/img3','123456789013');

INSERT INTO Emotes VALUES('carinha feliz','emotes/img1','123456789020');
INSERT INTO Emotes VALUES('carinha triste','emotes/img2','123456789020');
INSERT INTO Emotes VALUES('bola de futebol','emotes/img3','123456789020');

INSERT INTO Emotes VALUES('carinha feliz','emotes/img1','123456789011');
INSERT INTO Emotes VALUES('carinha triste','emotes/img2','123456789011');
INSERT INTO Emotes VALUES('bola de futebol','emotes/img3','123456789011');

INSERT INTO Emotes VALUES('carinha feliz','emotes/img1','123456789014');
INSERT INTO Emotes VALUES('carinha triste','emotes/img2','123456789014');
INSERT INTO Emotes VALUES('bola de futebol','emotes/img3','123456789014');

INSERT INTO Emotes VALUES('emote1','emotes/img4','123456789015');
INSERT INTO Emotes VALUES('emote1','emotes/img4','123456789016');
INSERT INTO Emotes VALUES('emote1','emotes/img4','123456789017');
INSERT INTO Emotes VALUES('emote1','emotes/img4','123456789018');

INSERT INTO Emotes VALUES('emote2','emotes/img5','123456789019');
INSERT INTO Emotes VALUES('emote2','emotes/img5','123456789010');
 
INSERT INTO Transmissao VALUES('123456789011','2004-10-19 10:23:54','2004-10-19 10:54:54','Furia x Astralis', 'Gaules');
INSERT INTO Transmissao VALUES('123456789012','2004-10-19 10:23:57','2004-10-19 11:54:54','NBA no Gau', 'Gaules');
INSERT INTO Transmissao VALUES('123456789013','2004-10-19 11:23:54','2004-10-19 16:54:54','Navi x G2', 'Gaules');
INSERT INTO Transmissao VALUES('123456789014','2004-10-19 11:23:54','2004-10-19 16:54:54','Pre-Jogo', 'Gaules');

INSERT INTO Transmissao VALUES('123456789015','2004-10-19 10:23:54','2004-10-19 10:54:54','Jogando GTA', 'Alanzoka');
INSERT INTO Transmissao VALUES('123456789016','2004-10-19 10:23:57','2004-10-19 11:54:54','Jogando Elden Ring', 'Alanzoka');

INSERT INTO Transmissao VALUES('123456789019','2004-10-19 10:23:54','2004-10-19 10:54:54','CS com amigos', 'Lett');
INSERT INTO Transmissao VALUES('123456789010','2004-10-19 10:23:57','2004-10-19 11:54:54','Jogando f1', 'Lett');
INSERT INTO Transmissao VALUES('123456789021','2004-10-19 11:23:54','2004-10-19 16:54:54','Lobby', 'Lett');
INSERT INTO Transmissao VALUES('123456789022','2004-10-19 11:23:54','2004-10-19 16:54:54','Among Us', 'Lett');

INSERT INTO Transmissao VALUES('123456789023','2004-10-19 10:23:54','2004-10-19 10:54:54','CSGO', 'Shroud');
INSERT INTO Transmissao VALUES('123456789024','2004-10-19 10:23:57','2004-10-19 11:54:54','Rainbow-Six', 'Shroud');
INSERT INTO Transmissao VALUES('123456789025','2004-10-19 11:23:54','2004-10-19 16:54:54','PUBG', 'Shroud');

insert into visualizacao VALUES('Maria','123456789011');
insert into visualizacao VALUES('Renata','123456789011');
insert into visualizacao VALUES('Leonardo','123456789011'); 
insert into visualizacao VALUES('Nikolas','123456789011'); 
insert into visualizacao VALUES('Helena','123456789011'); 

insert into visualizacao VALUES('Leonardo','123456789012'); 
insert into visualizacao VALUES('Gabriela','123456789012'); 
insert into visualizacao VALUES('Nikolas','123456789012');  
insert into visualizacao VALUES('Matheus','123456789012'); 

INSERT INTO Clipes VALUES('142', '123456789011', 543, 12, 'Maria','123456789011'); --Gaules
INSERT INTO Clipes VALUES('156', '123456789012', 1543, 16, 'Leonardo','123456789012');
INSERT INTO Clipes VALUES('172', '123456789013', 5441, 21, 'Nikolas','123456789012');

INSERT INTO Clipes VALUES('156', '123456789014', 1543, 16, 'Renata','123456789015'); --Alan
INSERT INTO Clipes VALUES('172', '123456789015', 5441, 21, 'Pedro','123456789015'); 

INSERT INTO Clipes VALUES('156', '123456789016', 1543, 16, 'Leonardo','123456789019'); --Lett
INSERT INTO Clipes VALUES('172', '123456789017', 5441, 21, 'Nikolas','123456789010');

INSERT INTO Anunciante VALUES('DELL');
INSERT INTO Anunciante VALUES('INTEL');
INSERT INTO Anunciante VALUES('APPLE');

INSERT INTO Anuncio VALUES(4,'anuncios/videoDell', 'DELL');
INSERT INTO Anuncio VALUES(5,'anuncios/videoDell2', 'DELL');
INSERT INTO Anuncio VALUES(1,'anuncios/videoApple', 'APPLE');

INSERT INTO MensagemChat VALUES('Ola, que dia bonito', '2004-10-19 11:23:54', '123456789011', 'Gabriela');

INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:23:56', '123456789013', 'Matheus');
INSERT INTO MensagemChat VALUES('Vou bem', '2004-11-19 10:23:59', '123456789013', 'Maria');

INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:24:56', '123456789010', 'Joao');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:25:56', '123456789014', 'Pedro');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:26:56', '123456789015', 'Leonardo');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:27:56', '123456789016', 'Matheus');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:28:56', '123456789019', 'Carlos');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:29:56', '123456789021', 'Leticia');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:30:56', '123456789022', 'Helena');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:31:56', '123456789023', 'Leticia');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:33:56', '123456789024', 'Leticia');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:34:56', '123456789025', 'Nikolas');
INSERT INTO MensagemChat VALUES('Como vai?', '2004-11-19 10:34:59', '123456789025', 'Nikolas');


INSERT INTO Categorias VALUES ('CSGO');
INSERT INTO Categorias VALUES ('Esporte');
INSERT INTO Categorias VALUES ('DOTA2');
INSERT INTO Categorias VALUES ('GTA');
INSERt into Categorias VALUES ('Among Us');
INSERt into Categorias VALUEs ('Elden Ring');
INSERT INTO Categorias VALUES ('F1 2021');
INSERT INTO Categorias VALUES ('Rainbow-Six');
INSERT INTO Categorias VALUES ('PUBG');

INSERT INTO Cheer VALUES('Matheus','Lett',20,'2020-02-7 07:12:15');
INSERT INTO Cheer VALUES('Gabriela','Lett',20,'2020-02-7 07:12:15');

INSERT INTO Cheer VALUES('Helena','Gaules',20,'2020-02-7 07:12:15');
INSERT INTO Cheer VALUES('Joao','Gaules',20,'2020-02-7 07:12:15');

INSERT INTO Cheer VALUES('Renata','Alanzoka',20,'2020-02-7 07:12:15');
INSERT INTO Cheer VALUES('Matheus','Alanzoka',20,'2020-02-7 07:12:15');

INSERT INTO Cheer VALUES('Matheus','Shroud',20,'2020-02-7 07:12:15');
INSERT INTO Cheer VALUES('Leticia','Shroud',20,'2020-02-7 07:12:15');

INSERT INTO Sussurro VALUES('Leonardo','Nikolas','2020-02-7 07:12:15','eae');
INSERT INTO Sussurro VALUES('Nikolas','Leonardo','2020-02-7 07:12:18','eae');
INSERT INTO Sussurro VALUES('Leonardo','Nikolas','2020-02-7 08:12:21','Tudo certo?');
INSERT INTO Sussurro VALUES('Nikolas','Leonardo','2020-02-7 07:12:24','Sim');

insert INTO Tags VALUES('Shooter');
insert INTO Tags VALUES('FPS');
insert INTO Tags VALUES('Action');
insert INTO Tags VALUES('MOBA');
insert INTO Tags VALUES('Strategy');


Insert INtO categorizacao values('123456789011','CSGO');
Insert INtO categorizacao values('123456789013','CSGO');
Insert INtO categorizacao values('123456789014','CSGO');
Insert INtO categorizacao values('123456789019','CSGO');
Insert INtO categorizacao values('123456789012','Esporte');
Insert INtO categorizacao values('123456789015','GTA');
Insert INTO categorizacao values('123456789016','Elden Ring');
Insert INTO categorizacao values('123456789010','F1 2021');
Insert INTO categorizacao values('123456789021','CSGO');
Insert INTO categorizacao values('123456789022','Among Us');
Insert INTO categorizacao values('123456789023','CSGO');
INSERT INTO categorizacao VALUES('123456789024','Rainbow-Six');
INSERT INTO categorizacao VALUES('123456789025','PUBG');

insert into Rotulacao values('Shooter','CSGO');
insert into Rotulacao values('FPS','CSGO');
insert into Rotulacao values('Action','CSGO');
insert into Rotulacao values('Action','DOTA2');
insert into Rotulacao values('MOBA','DOTA2');
INSERT INTO rotulacao values('Strategy','DOTA2');
insert into Rotulacao values('Action','Esporte');

INSERT into anunciou VALUES(4,'123456789011');
INSERT into anunciou VALUES(5,'123456789012');
INSERT into anunciou VALUES(1,'123456789011');
INSERT into anunciou VALUES(1,'123456789012');

SELECT nomeEmpresa,COUNT(anunciou) 
	from Anunciou join Anuncio USING(numeroanuncio) join Anunciante using(nomeEmpresa)
GROUP by(nomeempresa)
