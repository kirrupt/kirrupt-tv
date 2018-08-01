package kirrupt.tvrecommendation.findSimilarities;

import java.util.HashMap;
import java.util.ArrayList;

import kirrupt.tvrecommendation.findSimilarities.reader.DataReader;
import kirrupt.tvrecommendation.findSimilarities.utilities.Pair;
import kirrupt.tvrecommendation.findSimilarities.utilities.Key;
import kirrupt.tvrecommendation.findSimilarities.utilities.Triple;
import kirrupt.tvrecommendation.findSimilarities.utilities.DoublePair;

/**
 * Describes the similarity measure to be used by a ModelBuilder to build an item-based model
 * @author tuladhaa
 *
 */
public interface SimilarityMethod {
    /**
     * Finds the similarity between two movies.
     * @param dataReader DataReader object to use to read the data
     * @param mid1 first movie Id
     * @param mid2 second movie Id
     * @return a double similarity value
     */
    public DoublePair findSimilarity(DataReader dataReader, HashMap<Key, ArrayList<DoublePair>>ratings, int mid1, int mid2);
    /**
     * Sets the least number of users needed to call two items similar
     * @param numMinUsers
     */
    public void setNumMinUsers(int numMinUsers);
    public double findUserSimilarity(DataReader dataReader, int uid1, int uid2);
    public void setNumMinMovies(int numMinMovies);
}
