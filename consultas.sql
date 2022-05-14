-- 1) Tags que rotulam 2 ou mais transmissões
SELECT nometag
from categorizacao JOIN transmissao USING(idtransmissao) join rotulacao using(nomecategoria)
group by nometag
HAVING count(idtransmissao) >= 2;

-- 2) Criadores, que o níkolas segue, e seus numeros de inscritos em ordem decrescente
SELECT criadorparceiro, COUNT(criadorparceiro) as nroInscritos
from inscricao
where criadorparceiro in (SELECT DISTINCT criador
							FROM segue join transmissao on(transmissao.criador = segue.nomeusuarioseguido) 
							where segue.nomeusuariosegue = 'Nikolas' )
GROUP by criadorparceiro
order by nroInscritos DESC;

-- 3) Toda informação dos usuários que escreveram no chat de alguma stream do Lett
select usuarios.email,usuarios.saldobits,usuarios.nomeusuario,usuarios.datanascimento,usuarios.telefone,usuarios.bio
from transmissao join mensagemchat USING(idtransmissao) Join usuarios using(nomeusuario)
where transmissao.criador = 'Lett';
	
-- 4) Usuarios prime com inscrição prime do 'Gaules' e o numero de emotes que eles receberam da inscrição
select nomeusuarioprime,count(DISTINCT imagem) as emotes
FROM usuariosprime join inscricao on (usuariosprime.idinscricaoprime = idinscricao) join emotes using(idinscricao)
where inscricao.criadorparceiro = 'Gaules'
group by nomeusuarioprime;

-- 5) Recomendacoes para Nikolas, ranking de quem é mais seguido pelos usuários que Nikolas segue
SELECT nomeusuarioseguido, count(nomeusuarioseguido) as nmrSeguidoresSeguidos FROM segue 
	where (		
      nomeusuariosegue in (SELECT nomeusuarioseguido from segue where (nomeusuariosegue = 'Nikolas')) 
      and nomeusuarioseguido != 'Nikolas'
      and nomeusuarioseguido in ( SELECT criadorparceiro from criadoresparceirosdatwitch)
      and nomeusuarioseguido in (select DISTINCT criador from transmissao)
    ) 
    GROUP by nomeusuarioseguido ORDER by count(nomeusuarioseguido) desc; 



-- 6) Quantas vezes o anuncio de uma empresa foi visto    
SELECT nomeEmpresa,COUNT(anunciou) as anunciou
	from Anunciou join Anuncio USING(numeroanuncio) JOIN visualizacao USING(idtransmissao) 
GROUP by(nomeempresa);


-- 7) Quantos anuncios foram passados pro cada criador
SELECT criador, count(anunciou) as passou
	FROM transmissao join visualizacao USING(idtransmissao) join anunciou USING(idtransmissao)
GROUP by(criador) ORDER by(COUNT(anunciou));

    
-- 8)seleciona criadores que fazem transmissoes nas categorias vistas por Leonardo em ordem decrescente de transmissoes feitas.    
SELECT DISTINCT criador,COUNT(criador) as transmissoesfeitas from 
  VizualizacoesporUsuariodeCategoria 
  join categorizacao USING(nomecategoria) 
  join transmissao using(idtransmissao) 
  WHERE nomeusuario='Leonardo'
GROUP BY(criador)
ORDER BY(COUNT(criador)) DESC;


-- 9) Criadores que seguem todos ou mais dos usuarios que o "Leonardo" segue
select distinct criadorparceiro
FROM segue segue_ext JOIN criadoresparceirosdatwitch ON (segue_ext.nomeusuariosegue = criadoresparceirosdatwitch.criadorparceiro)
where not exists (select segue.nomeusuarioseguido
               	 from segue
                 where nomeusuariosegue = 'Leonardo' AND
                    nomeusuarioseguido not in
                            		(SELECT DISTINCT segue.nomeusuarioseguido
                           			 FROM segue 
                            		 where segue.nomeusuariosegue = segue_ext.nomeusuariosegue));
       

-- 10) ranking de emotes mais populares no chat do Gaules                  
select nomeemote
from MensagensNoChatDeCriador join inscricao ON(MensagensNoChatDeCriador.nomeusuario = inscricao.nomeusuario) join emotes on(emotes.idinscricao = inscricao.idinscricao)
where MensagensNoChatDeCriador.texto = emotes.nomeemote and MensagensNoChatDeCriador.criador = 'Gaules'
GROUP by nomeemote
order by  (COUNT(nomeemote)) DESC;

