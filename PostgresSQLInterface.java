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
            query2(c);
            query6(c);
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
                "FROM categorizacao JOIN transmissao USING(idtransmissao) JOIN rotulacao USING(nomecategoria)\n" +
                "GROUP BY nometag\n" +
                "HAVING COUNT(idtransmissao) >= 2;" );
        while ( rs.next() ) {
            String  tag = rs.getString("nometag");
            System.out.println( "TAG = " + tag );
            System.out.println();
        }
        rs.close();
        stmt.close();

    }
    public static void query2(Connection c) throws Exception{
        //Usuário e seu email. O usuario deve ser prime e um criadores, também deve ter o maior número de bits
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "SELECT nomeusuario,email\n" +
                "FROM usuarios JOIN usuariosprime ON(nomeusuario = nomeUsuarioPrime) JOIN criadoresparceirosdatwitch ON (criadorparceiro = nomeusuario)\n" +
                "WHERE saldobits = (SELECT MAX(saldobits)\n" +
                "                   FROM usuarios);\n");
        while ( rs.next() ) {
            String  nomeusuario = rs.getString("nomeusuario");
            String  email = rs.getString("email");
            System.out.println( "nomeusuario = " + nomeusuario );
            System.out.println( "email = " + email );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query3(Connection c) throws Exception{
        //Criadores que o Usuário ? segue e que fizeram uma transmissão na categoria de ?.
        PreparedStatement stmt = null;
        String sql = "SELECT DISTINCT criador\n" +
                     "FROM segue JOIN transmissao ON(transmissao.criador = segue.nomeusuarioseguido) JOIN categorizacao USING (idtransmissao)\n" +
                     "WHERE segue.nomeusuariosegue = ? AND nomecategoria = ?;";
        stmt = c.prepareStatement(sql);
        System.out.println("Escolha valores para ? para o seguinte enunciado: Criadores que o Usuario ? segue e que fizeram uma transmissao na categoria de ?.");
        Scanner scanner = new Scanner(System.in);
        System.out.print("Usuario = ");
        String usuario = scanner.nextLine();
        System.out.print("Categoria = ");
        String categoria = scanner.nextLine();
        System.out.println();
        stmt.setString(1,usuario);
        stmt.setString(2,categoria);

        ResultSet rs = stmt.executeQuery();
        while ( rs.next() ) {
            String  criador = rs.getString("criador");
            System.out.println( "criador = " + criador );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
    public static void query4(Connection c) throws Exception{
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
    public static void query5(Connection c) throws Exception{
        //Toda informação dos usuários que escreveram no chat de alguma stream do ?
        PreparedStatement stmt = null;
        String sql = "select usuarios.email,usuarios.saldobits,usuarios.nomeusuario,usuarios.datanascimento,usuarios.telefone,usuarios.bio\n" +
                      "from transmissao join mensagemchat USING(idtransmissao) Join usuarios using(nomeusuario)\n" +
                     "where transmissao.criador = ?;";
        stmt = c.prepareStatement(sql);
        System.out.println("Escolha valores para ? para o seguinte enunciado: Toda informação dos usuários que escreveram no chat de alguma stream do Criador ?");
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
    public static void query6(Connection c) throws Exception{
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
    public static void query7(Connection c) throws Exception{
        //
        Statement stmt = null;
        stmt = c.createStatement();
        ResultSet rs = stmt.executeQuery( "");
        while ( rs.next() ) {
            String  nomeusuario = rs.getString("nomeusuario");
            String  email = rs.getString("email");
            System.out.println( "nomeusuario = " + nomeusuario );
            System.out.println( "email = " + email );
            System.out.println();
        }
        rs.close();
        stmt.close();
    }
}


