-- 1) Tags que rotulam 2 ou mais transmissões
SELECT nometag
from categorizacao JOIN transmissao USING(idtransmissao) join rotulacao using(nomecategoria)
group by nometag
HAVING count(idtransmissao) >= 2;

-- 2) Usuário e seu email. O usuario deve ser prime e um criadores, também deve ter o maior número de bits
SELECT nomeusuario,email
from usuarios join usuariosprime ON(nomeusuario = nomeUsuarioPrime) join criadoresparceirosdatwitch ON (criadorparceiro = nomeusuario)
WHERE saldobits = (select max(saldobits) from usuarios);
                  

-- 3) Criadores que o Níkolas segue e que fizeram uma transmissão na categoria de CSGO. = "Gaules"
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
select nomeusuarioprime,count(DISTINCT imagem) as emotes
FROM usuariosprime join inscricao on (usuariosprime.idinscricaoprime = idinscricao) join emotes using(idinscricao)
where inscricao.criadorparceiro = 'Gaules'
group by nomeusuarioprime;

--7) Recomendacoes para Nikolas, ranking de quem é mais seguido pelos usuários que Nikolas segue
SELECT nomeusuarioseguido, count(nomeusuarioseguido) as nmrSeguidoresSeguidos FROM segue 
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
	FULL JOIN
    (SELECT nomeusuario, COUNT(idtransmissao) as nmrVizualizacoes from usuarios JOIN visualizacao USING(nomeusuario) GROUP by (nomeusuario)) as t2  USING(nomeusuario)
	FULL JOIN
    (SELECT nomeusuario, COUNT(idclipe) as clipesCriados from usuarios JOIN clipes USING(nomeusuario) GROUP by (nomeusuario)) as t4  USING(nomeusuario)
    FULL JOIN 
    (SELECT nomeusuario, COUNT(nomeusuarioseguido) as segue from usuarios as u JOIN segue as s ON(nomeusuario=nomeusuariosegue) GROUP by (nomeusuario)) as t5 USING(nomeusuario)
    FULL JOIN 
    (SELECT nomeusuario, COUNT(nomeusuariorecebe) as sussurroEnv from usuarios as u JOIN sussurro as s on(nomeusuario=nomeusuariomanda) GROUP by (nomeusuario)) as t6 USING(nomeusuario)
    FULL JOIN 
    (SELECT nomeusuario, COUNT(idtransmissao) as msgChatEnv from usuarios JOIN mensagemchat USING(nomeusuario) GROUP by (nomeusuario)) as t7 USING(nomeusuario)
    FULL JOIN 
    (SELECT nomeusuario, COUNT(criadorparceiro) as cheersDados from usuarios JOIN cheer USING(nomeusuario) GROUP by (nomeusuario)) as t8 USING(nomeusuario)
order by(nomeusuario);


--9) Quantas vezes o anuncio de uma empresa foi visto    
SELECT nomeEmpresa,COUNT(anunciou) as anunciou
	from Anunciou join Anuncio USING(numeroanuncio) JOIN visualizacao USING(idtransmissao) 
GROUP by(nomeempresa);


--10) Quantos anuncios foram passados pro cada criador
SELECT criador, count(anunciou) as passou
	FROM transmissao join visualizacao USING(idtransmissao) join anunciou USING(idtransmissao)
GROUP by(criador) ORDER by(COUNT(anunciou));

    
-- 11)seleciona criadores que fazem transmissoes nas categorias vistas por Leonardo em ordem decrescente de transmissoes feitas.    
SELECT DISTINCT criador,COUNT(criador) as transmissoesfeitas from 
  VizualizacoesporUsuariodeCategoria 
  join categorizacao USING(nomecategoria) 
  join transmissao using(idtransmissao) 
  WHERE nomeusuario='Leonardo'
GROUP BY(criador)
ORDER BY(COUNT(criador)) DESC;


-- 12) Criadores que seguem todos ou mais dos usuarios que o "Leonardo" segue
select distinct criadorparceiro
FROM segue segue_ext JOIN criadoresparceirosdatwitch ON (segue_ext.nomeusuariosegue = criadoresparceirosdatwitch.criadorparceiro)
where not exists (select segue.nomeusuarioseguido
               	 from segue
                 where nomeusuariosegue = 'Leonardo' AND
                    nomeusuarioseguido not in
                            		(SELECT DISTINCT segue.nomeusuarioseguido
                           			 FROM segue 
                            		 where segue.nomeusuariosegue = segue_ext.nomeusuariosegue));
       

-- 13) ranking de emotes mais populares no chat do Gaules                  
select nomeemote
from MensagensNoChatDeCriador join inscricao ON(MensagensNoChatDeCriador.nomeusuario = inscricao.nomeusuario) join emotes on(emotes.idinscricao = inscricao.idinscricao)
where MensagensNoChatDeCriador.texto = emotes.nomeemote and MensagensNoChatDeCriador.criador = 'Gaules'
GROUP by nomeemote
order by  (COUNT(nomeemote)) DESC;

