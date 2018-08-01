package recommendation.writer;

import java.util.TreeSet;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

import  recommendation.writer.SimilarityWriter;
import  recommendation.DatabaseImpl;
import recommendation.utilities.IntDoubleIntTriple;
import recommendation.utilities.IntDoublePair;

/**
 * A SimilarityWriter that writes to a database
 * @author Amrit Tuladhar
 *
 */
public class SimilarityWriterToDB implements SimilarityWriter {

    private DatabaseImpl databaseImpl;
    private String similarityTable;

    public SimilarityWriterToDB(DatabaseImpl databaseImpl,
            String similarityTable) {
        this.databaseImpl = databaseImpl;
        if (!databaseImpl.openConnection()) {
            System.out.println("Could not open database connection.");
            System.exit(1);
        }
        this.similarityTable = similarityTable;
    }

    public void write(int movieId1, int movieId2, double similarity) throws Exception{
        String sql = "INSERT INTO " + similarityTable + "(mid1, mid2, similarity) VALUES(" +
        movieId1 + ", " + movieId2 + ", " + similarity + ");";
        databaseImpl.updateDB(sql);
    }

    public void writeBatch(int movieId, ArrayList<IntDoubleIntTriple> similarMovies) throws Exception {
        Connection con = this.databaseImpl.getConnection();

        StringBuilder builder = new StringBuilder("");
        for ( int i = 0; i < similarMovies.size(); i++ ) {
            if ( i != 0 ) {
                builder.append(",");
            }
            builder.append("(?,?,?,?)");
        }

        PreparedStatement statement = con.prepareStatement("INSERT INTO "+similarityTable+
            " (mid1,mid2,similarity,weight) VALUES "+builder.toString());

        int index = 1;
        for(IntDoubleIntTriple pair : similarMovies) {
            statement.setInt(index++, movieId);
            statement.setInt(index++, pair.a);
            statement.setDouble(index++, pair.b);
            statement.setInt(index++,pair.c);
        }
        statement.execute();
        //statement.executeBatch();
    }

    public void close() throws Exception {
        this.databaseImpl.closeConnection();
    }
}

