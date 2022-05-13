-- Ranking de criadorpareceiro em relação a quantos inscritos eles tem (MODIFICAR, tem que usar 3 tabelas por consulta)
SELECT criadorparceiro, COUNT(criadorparceiro) as nroInscritos
from inscricao
GROUP by criadorparceiro
order by nroInscritos DESC;

--1) Tags que rotulam 2 ou mais transmissões
SELECT nometag
from categorizacao JOIN transmissao USING(idtransmissao) join rotulacao using(nomecategoria)
group by nometag
HAVING count(idtransmissao) >= 2;

--2) Usuário e seu email. O usuario deve ser prime e um criadores, também deve ter o maior número de bits
SELECT nomeusuario,email
from usuarios join usuariosprime ON(nomeusuario = nomeUsuarioPrime) join criadoresparceirosdatwitch ON (criadorparceiro = nomeusuario)
WHERE saldobits = (select max(saldobits)
                   from usuarios);
                   
SELECT nomecategoria,count(idtransmissao) FROM transmissao join categorizacao using(idTransmissao) group BY(nomecategoria);


--3) Criadores que o Níkolas segue e que fizeram uma transmissão na categoria de CSGO. = "Gaules"
SELECT DISTINCT criador
FROM segue join transmissao on(transmissao.criador = segue.nomeusuarioseguido) join categorizacao USING (idtransmissao)
where segue.nomeusuariosegue = 'Nikolas' and nomecategoria = 'CSGO';

--4) Criadores, que o níkolas segue, e seus numeros de inscritos em ordem decrescente
SELECT criadorparceiro, COUNT(criadorparceiro) as nroInscritos
from inscricao
where criadorparceiro in (SELECT DISTINCT criador
							FROM segue join transmissao on(transmissao.criador = segue.nomeusuarioseguido) 
							where segue.nomeusuariosegue = 'Nikolas' )
GROUP by criadorparceiro
order by nroInscritos DESC;

--5) Toda informação dos usuários que escreveram no chat de alguma stream do Lett
select usuarios.email,usuarios.saldobits,usuarios.nomeusuario,usuarios.datanascimento,usuarios.telefone,usuarios.bio
from transmissao join mensagemchat USING(idtransmissao) Join usuarios using(nomeusuario)
where transmissao.criador = 'Lett';
	
--6) Usuarios prime com inscrição prime do 'Gaules' e o numero de emotes que eles receberam da inscrição
select nomeusuarioprime,count(DISTINCT imagem)
FROM usuariosprime join inscricao on (usuariosprime.idinscricaoprime = idinscricao) join emotes using(idinscricao)
where inscricao.criadorparceiro = 'Gaules'
group by nomeusuarioprime;

--7) Algum tipo de ranking sobre a tabela Segue?
SELECT nomeusuarioseguido, count(nomeusuarioseguido) FROM segue 
	where (		
      			nomeusuariosegue in (SELECT nomeusuarioseguido from segue where (nomeusuariosegue = 'Nikolas')) 
           		and nomeusuarioseguido != 'Nikolas'
          		and nomeusuarioseguido in ( SELECT criadorparceiro from criadoresparceirosdatwitch)
      		    and nomeusuarioseguido in (select DISTINCT criador from transmissao)
          ) 
    GROUP by nomeusuarioseguido ORDER by count(nomeusuarioseguido) desc; 


--8) Informacoes de atividade de usuários, tudo que eles fizeram na plataforma
SELECT  nomeusuario, nmrInscricoes, nmrVizualizacoes, clipesCriados, segue, sussurroEnv, msgChatEnv, cheersDados
    from 
    (SELECT nomeusuario, COUNT(criadorparceiro) as nmrInscricoes from usuarios JOIN inscricao USING(nomeusuario) GROUP by (nomeusuario)) as t1
	natural JOIN
    (SELECT nomeusuario, COUNT(idtransmissao) as nmrVizualizacoes from usuarios JOIN visualizacao USING(nomeusuario) GROUP by (nomeusuario)) as t2
	natural JOIN
    (SELECT nomeusuario, COUNT(idclipe) as clipesCriados from usuarios JOIN clipes USING(nomeusuario) GROUP by (nomeusuario)) as t4
    natural JOIN
    (SELECT nomeusuario, COUNT(nomeusuarioseguido) as segue from usuarios as u JOIN segue as s ON(nomeusuario=nomeusuariosegue) GROUP by (nomeusuario)) as t5
    NATURAL JOIN
    (SELECT nomeusuario, COUNT(nomeusuariorecebe) as sussurroEnv from usuarios as u JOIN sussurro as s on(nomeusuario=nomeusuariomanda) GROUP by (nomeusuario)) as t6
    natural JOIN
    (SELECT nomeusuario, COUNT(idtransmissao) as msgChatEnv from usuarios JOIN mensagemchat USING(nomeusuario) GROUP by (nomeusuario)) as t7
    natural JOIN
    (SELECT nomeusuario, COUNT(criadorparceiro) as cheersDados from usuarios JOIN cheer USING(nomeusuario) GROUP by (nomeusuario)) as t8
order by(nomeusuario);


--9) Quantas vezes o anuncio de uma empresa foi visto    
SELECT nomeEmpresa,COUNT(anunciou)
	from Anunciou join Anuncio USING(numeroanuncio) JOIN visualizacao USING(idtransmissao) 
GROUP by(nomeempresa);

-- Quantas vezes as transmissoes de cada criador foram vistas
SELECT criadorparceiro, COUNT(visualizacao) 
	from criadoresparceirosdatwitch as C join transmissao as T on(C.criadorparceiro = T.criador) join visualizacao USING(idtransmissao)
GROUP by(criadorparceiro);

--10) Quantos anuncios foram passados pro cada criador
SELECT criador, count(anunciou)
	FROM transmissao join visualizacao USING(idtransmissao) join anunciou USING(idtransmissao)
GROUP by(criador) ORDER by(COUNT(anunciou));

    
-- Pega as vizualizacoes por categoria do Leonardo 
SELECT nomecategoria,vizualizacoes FRom VizualizacoesporUsuariodeCategoria 
	WHERE nomeusuario = 'Leonardo'
    GROUP by (nomecategoria, vizualizacoes );
    
    
-- seleciona criadores que fazem transmissoes nas categorias vistas por Leonardo em ordem decrescente de transmissoes feitas.    
SELECT DISTINCT criador,COUNT(criador) from 
  VizualizacoesporUsuariodeCategoria 
  join categorizacao USING(nomecategoria) 
  join transmissao using(idtransmissao) 
  WHERE nomeusuario='Leonardo'
GROUP BY(criador)
ORDER BY(COUNT(criador)) DESC;




    
