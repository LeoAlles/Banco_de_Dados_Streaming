import java.sql.*;
import java.util.Scanner;

public class PostgresSQLInterface {

    public static void main( String args[] ) {
        Connection c = null;

        try {
            Class.forName("org.postgresql.Driver");
            c = DriverManager.getConnection("jdbc:postgresql://[::1]:5432/postgres",
                                "postgres", "123");
            c.setAutoCommit(false);
            System.out.println("Opened database successfully");
            query1(c);
            System.out.println("####################################");
            query2(c);
            System.out.println("####################################");
            query3(c);
            System.out.println("####################################");
            query4(c);
            System.out.println("####################################");
            query5(c);
            System.out.println("####################################");
            query6(c);
            System.out.println("####################################");
            query7(c);
            System.out.println("####################################");
            query8(c);
            System.out.println("####################################");
            query9(c);
            System.out.println("####################################");
            query10(c);

            c.close();
        } catch ( Exception e ) {
            System.err.println( e.getClass().getName()+": "+ e.getMessage() );
            System.exit(0);
        }
        System.out.println("Operation done successfully");

    }

    public static void query1(Connection c) throws Exception{
        //Tags que rotulam 2 ou mais transmissões
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "SELECT nometag\n" +
                "from categorizacao JOIN transmissao USING(idtransmissao) join rotulacao using(nomecategoria)\n" +
                "group by nometag\n" +
                "HAVING count(idtransmissao) >= 2;" );
        while ( rs.next() ) {
            String  tag = rs.getString("nometag");
            System.out.println( "TAG = " + tag );
            System.out.println();
        }
        rs.close();
        stmt.close();

    }
    public static void query2(Connection c) throws Exception{
        //Criadores, que o usuario ? segue, e seus numeros de inscritos em ordem decrescente
        PreparedStatement stmt = null;
        String sql = "SELECT criadorparceiro, COUNT(criadorparceiro) AS nroInscritos\n" +
                "FROM inscricao\n" +
                "WHERE criadorparceiro IN (SELECT DISTINCT criador\n" +
                "FROM segue JOIN transmissao ON(transmissao.criador = segue.nomeusuarioseguido) \n" +
                "WHERE segue.nomeusuariosegue = ? )\n" +
                "GROUP BY criadorparceiro\n" +
                "ORDER BY nroInscritos DESC;";
        stmt = c.prepareStatement(sql);
        System.out.println("Escolha valores para ? para o seguinte enunciado: Criadores, que o usuario ? segue, e seus numeros de inscritos em ordem decrescente");
        Scanner scanner = new Scanner(System.in);
        System.out.print("Usuario = ");
        String usuario = scanner.nextLine();
        System.out.println();
        stmt.setString(1,usuario);

        ResultSet rs = stmt.executeQuery();
        while ( rs.next() ) {
            String  criador = rs.getString("criadorparceiro");
            int nroInscritos = rs.getInt("nroInscritos");
            System.out.println( "criadorparceiro = " + criador );
            System.out.println("nroInscritos = " + nroInscritos);
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query3(Connection c) throws Exception{
        //Toda informação dos usuários que escreveram no chat de alguma stream do ?
        PreparedStatement stmt = null;
        String sql = "select usuarios.email,usuarios.saldobits,usuarios.nomeusuario,usuarios.datanascimento,usuarios.telefone,usuarios.bio\n" +
                      "from transmissao join mensagemchat USING(idtransmissao) Join usuarios using(nomeusuario)\n" +
                     "where transmissao.criador = ?;";
        stmt = c.prepareStatement(sql);
        System.out.println("Escolha valores para ? para o seguinte enunciado: Toda informacao dos usuarios que escreveram no chat de alguma stream do Criador ?");
        Scanner scanner = new Scanner(System.in);
        System.out.print("Criador = ");
        String criador = scanner.nextLine();
        System.out.println();
        stmt.setString(1,criador);

        ResultSet rs = stmt.executeQuery();
        while ( rs.next() ) {
            String  email = rs.getString("email");
            int saldobits = rs.getInt("saldobits");
            String nomeUsuario = rs.getString("nomeusuario");
            String dataNasicmento = rs.getString("datanascimento");
            int telefone = rs.getInt("telefone");
            String bio = rs.getString("bio");

            System.out.println( "email = " + email );
            System.out.println("saldobits = " + saldobits);
            System.out.println("nomeUsuario = " + nomeUsuario);
            System.out.println("dataNasicmento = " + dataNasicmento);
            System.out.println("telefone = " + telefone);
            System.out.println("bio = " + bio);
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query4(Connection c) throws Exception{
        //Usuarios prime com inscrição prime no Criador ? e o numero de emotes que eles receberam da inscrição
        PreparedStatement stmt = null;
        String sql = "select nomeusuarioprime,count(DISTINCT imagem)\n" +
                "FROM usuariosprime join inscricao on (usuariosprime.idinscricaoprime = idinscricao) join emotes using(idinscricao)\n" +
                "where inscricao.criadorparceiro = ? \n" +
                "group by nomeusuarioprime;";
        stmt = c.prepareStatement(sql);
        System.out.println("Escolha valores para ? para o seguinte enunciado: Usuarios prime com inscricao prime no Criador ? e o numero de emotes que eles receberam da inscricao");
        Scanner scanner = new Scanner(System.in);
        System.out.print("Criador = ");
        String criador = scanner.nextLine();
        System.out.println();
        stmt.setString(1,criador);

        ResultSet rs = stmt.executeQuery();
        while ( rs.next() ) {
            String  usuarioPrime = rs.getString("nomeusuarioprime");
            int nroEmotes = rs.getInt("count");
            System.out.println( "usuarioPrime = " + usuarioPrime );
            System.out.println("nroEmotes = " + nroEmotes);
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query5(Connection c) throws Exception{
        // 5) Recomendacoes para Nikolas, ranking de quem é mais seguido pelos usuários que Nikolas segue
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "SELECT nomeusuarioseguido, count(nomeusuarioseguido) as nmrSeguidoresSeguidos FROM segue \n" +
                "where (\n" +
                "      nomeusuariosegue in (SELECT nomeusuarioseguido from segue where (nomeusuariosegue = 'Nikolas')) \n" +
                "      and nomeusuarioseguido != 'Nikolas'\n" +
                "      and nomeusuarioseguido in ( SELECT criadorparceiro from criadoresparceirosdatwitch)\n" +
                "      and nomeusuarioseguido in (select DISTINCT criador from transmissao)\n" +
                "    ) \n" +
                "    GROUP by nomeusuarioseguido ORDER by count(nomeusuarioseguido) desc; ");
        while ( rs.next() ) {
            String  nomeusuarioseguido = rs.getString("nomeusuarioseguido");
            int  nmrSeguidoresSeguidos = rs.getInt("nmrSeguidoresSeguidos");
            System.out.println( "nomeusuarioseguido = " + nomeusuarioseguido );
            System.out.println( "nmrSeguidoresSeguidos = " + nmrSeguidoresSeguidos );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query6(Connection c) throws Exception{
        //6) Quantas vezes o anuncio de uma empresa foi visto
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "SELECT nomeEmpresa,COUNT(anunciou) as anunciou\n" +
                "from Anunciou join Anuncio USING(numeroanuncio) JOIN visualizacao USING(idtransmissao) \n" +
                "GROUP by(nomeempresa);");
        while ( rs.next() ) {
            String  nomeEmpresa = rs.getString("nomeEmpresa");
            int  anunciou = rs.getInt("anunciou");
            System.out.println( "nomeEmpresa = " + nomeEmpresa );
            System.out.println( "anunciou = " + anunciou );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query7(Connection c) throws Exception{
        //7) Quantos anuncios foram passados pro cada criador
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "SELECT criador, count(anunciou) as passou\n" +
                "FROM transmissao join visualizacao USING(idtransmissao) join anunciou USING(idtransmissao)\n" +
                "GROUP by(criador) ORDER by(COUNT(anunciou));");
        while ( rs.next() ) {
            String  criador = rs.getString("criador");
            int  passou = rs.getInt("passou");
            System.out.println( "criador = " + criador );
            System.out.println( "passou = " + passou );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query8(Connection c) throws Exception{
        //seleciona criadores que fazem transmissoes nas categorias vistas por Leonardo em ordem decrescente de transmissoes feitas.
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "SELECT DISTINCT criador,COUNT(criador) as transmissoesfeitas from \n" +
                "  VizualizacoesporUsuariodeCategoria \n" +
                "  join categorizacao USING(nomecategoria) \n" +
                "  join transmissao using(idtransmissao) \n" +
                "  WHERE nomeusuario='Leonardo'\n" +
                "GROUP BY(criador)\n" +
                "ORDER BY(COUNT(criador)) DESC;\n");
        while ( rs.next() ) {
            String  criador = rs.getString("criador");
            int  transmissoesfeitas = rs.getInt("transmissoesfeitas");
            System.out.println( "criador = " + criador );
            System.out.println( "transmissoesfeitas = " + transmissoesfeitas );
            System.out.println();

        }
        rs.close();
        stmt.close();
    }
    public static void query9(Connection c) throws Exception{
        //Criadores que seguem todos ou mais dos usuarios que o "Leonardo" segue
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "select distinct criadorparceiro\n" +
                "FROM segue segue_ext JOIN criadoresparceirosdatwitch ON (segue_ext.nomeusuariosegue = criadoresparceirosdatwitch.criadorparceiro)\n" +
                "where not exists (select segue.nomeusuarioseguido\n" +
                "                 from segue\n" +
                "                 where nomeusuariosegue = 'Leonardo' AND\n" +
                "                       nomeusuarioseguido not in\n" +
                "                            (SELECT DISTINCT segue.nomeusuarioseguido\n" +
                "                            FROM segue \n" +
                "                            where segue.nomeusuariosegue = segue_ext.nomeusuariosegue));");
        while ( rs.next() ) {
            String  criadorparceiro = rs.getString("criadorparceiro");
            System.out.println( "criadorparceiro = " + criadorparceiro );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query10(Connection c) throws Exception{
        // ranking de emotes mais populares no chat do Gaules
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "select nomeemote\n" +
                "from MensagensNoChatDeCriador join inscricao ON(MensagensNoChatDeCriador.nomeusuario = inscricao.nomeusuario) join emotes on(emotes.idinscricao = inscricao.idinscricao)\n" +
                "where MensagensNoChatDeCriador.texto = emotes.nomeemote and MensagensNoChatDeCriador.criador = 'Gaules'\n" +
                "GROUP by nomeemote\n" +
                "order by  (COUNT(nomeemote)) DESC;");
        while ( rs.next() ) {
            String  nomeemote = rs.getString("nomeemote");
            System.out.println( "nomeemote = " + nomeemote );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
}


