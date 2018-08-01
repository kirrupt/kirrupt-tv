package recommendation.writer;

import java.util.TreeSet;
import java.util.ArrayList;

import recommendation.utilities.IntDoublePair;
import recommendation.utilities.IntDoubleIntTriple;
/**
 * An interface to describe a way of writing similarity tables
 * @author Amrit Tuladhar
 *
 */
public interface SimilarityWriter {
    /**
     * Writes a similarity value for two movies
     * @param movieId1
     * @param movieId2
     * @param similarity
     * @throws Exception
     */
    public void write(int movieId1, int movieId2, double similarity) throws Exception;

    public void writeBatch(int movieId, ArrayList<IntDoubleIntTriple> similarMovies) throws Exception;
    /**
     * Closes the writer
     * @throws Exception
     */
    public void close() throws Exception;
}
