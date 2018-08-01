package recommendation;

import java.util.ArrayList;
import java.util.HashMap;
import recommendation.reader.DataReader;
import recommendation.utilities.Pair;
import recommendation.utilities.Key;
import recommendation.utilities.Triple;
import recommendation.utilities.DoublePair;

//TODO: combine methods better so less copied code - steinbel
public class PearsonSimilarityMethod implements SimilarityMethod {
    private int numMinUsers = 2;
    private int numMinMovies = 2;

    public DoublePair findSimilarity(DataReader dataReader, HashMap<Key, ArrayList<DoublePair>>ratings, int mid1, int mid2) {
        DoublePair r = new DoublePair(0.0,0.0);
        r.b=0;
        //ArrayList<Pair> commonUserRatings = dataReader.getCommonUserRatings(mid1, mid2);
        ArrayList<DoublePair>commonUserRatings = ratings.get(new Key(mid1,mid2));
        if(commonUserRatings==null) {
            r.a=-150.0;
            return r;
        }
        if (commonUserRatings.size() < numMinUsers) {
            r.a=-100.0;
            return r;
        }
        double num = 0.0, den1 = 0.0, den2 = 0.0;
        double avg1 = dataReader.getAverageMovieRatingFromMemory(mid1);
        double avg2 = dataReader.getAverageMovieRatingFromMemory(mid2);
        for (DoublePair u : commonUserRatings) {
            double diff1 = u.a - avg1;
            double diff2 = u.b - avg2;
            num += diff1 * diff2;
            den1 += diff1 * diff1;
            den2 += diff2 * diff2;
        }
        double den = Math.sqrt(den1) * Math.sqrt(den2);
        if (den == 0.0) {
            r.a=0.0;
            return r;
        }
        r.a = num / den;
        r.b = commonUserRatings.size();
        return r;
    }

    /* (non-Javadoc)
     * @see netflix.algorithms.modelbased.itembased.method.SimilarityMethod#setNumMinUsers(int)
     */
    public void setNumMinUsers(int numMinUsers) {
        this.numMinUsers = numMinUsers;
    }
    
    /**
     * @author steinbel, based off setNumMinUsers by tuladhaa
     * Accessor method to set minimum number of common movies between two users.
     * @param numMinMovies
     */
    public void setNumMinMovies(int numMinMovies) {
    	this.numMinMovies = numMinMovies;
    }
    
    /**
     * @author steinbel, based off findSimilarity by tuladhaa
     * Finds the Pearson similarity between two users.
     * @param dataReader - reads from the data on this dataset
     * @param uid1 - one of the users to compare
     * @param uid2 - the other user to compare
     * @return - the similarity between user 1 and user 2
     */
    public double findUserSimilarity(DataReader dataReader, int uid1, int uid2) {
    	ArrayList<Pair> commonMovieRatings = dataReader.getCommonMovieRatings(uid1, uid2);
    	if (commonMovieRatings.size() < numMinMovies)
    		return -100.0;
    	double num = 0.0, den1 = 0.0, den2 = 0.0, diff1 = 0.0, diff2 = 0.0;
    	double avg1 = dataReader.getAverageRatingForUser(uid1);
    	double avg2 = dataReader.getAverageRatingForUser(uid2);
    	for (Pair m : commonMovieRatings) {
    		diff1 = m.a - avg1;
    		diff2 = m.b - avg2;
    		num += diff1*diff2;
    		den1 += diff1*diff1;
    		den2 += diff2*diff2;
      	}
    	double den = Math.sqrt(den1)* Math.sqrt(den2);
    	if (den == 0.0)
    		return 0.0;
    	return num / den;
    }

}
