package recommendation.reader;

import java.util.ArrayList;
import java.util.HashMap;

import recommendation.db.DatabaseImpl;

import recommendation.utilities.DoublePair;
import recommendation.utilities.Pair;
import recommendation.utilities.Triple;
import recommendation.utilities.Key;

/**
 * A DataReader that reads in movies data from a database
 * @author Amrit Tuladhar
 *
 */
public class DataReaderFromDB implements DataReader {
    DatabaseImpl databaseImpl;
    
    public DataReaderFromDB(DatabaseImpl databaseImpl) {
        this.databaseImpl = databaseImpl;
        if (!databaseImpl.openConnection()) {
            System.out.println("Could not open database connection.");
            System.exit(1);
        }
    }
    public int getNumberOfMovies() {
        Pair movieBounds = databaseImpl.getMaxAndMinMovie();
        return movieBounds.b;
    }
    public int getRating(int uid, int mid) {
        return databaseImpl.getRatingForUserAndMovie(uid, mid);
    }
    public ArrayList<Pair> getCommonUserRatings(int mId1, int mId2) {
        return databaseImpl.getCommonUserRatings(mId1, mId2);
    }
    public ArrayList<Triple> getCommonUserRatAndAve(int mId1, int mId2) {
        return databaseImpl.getCommonUserAverages(mId1, mId2);
    }

    public ArrayList<Integer>getMovieIDs() {
        return databaseImpl.getMovieIDs();
    }

    public HashMap<Key, ArrayList<DoublePair>> getCommonUserRatingsForMid(int mid) {
        return databaseImpl.getCommonUserRatingsForMid(mid);
    }
    
    public double getAverageMovieRating(int mid) {
        return databaseImpl.getAverageMovieRating(mid);
    }

    public double getAverageMovieRatingFromMemory(int mid) {
        return databaseImpl.getAverageMovieRatingFromMemory(mid);
    }
    
    public int getRatingFromComposite(int composite) {
        return composite;
    }
    public void close() {
        databaseImpl.closeConnection();
    }
	public ArrayList<Pair> getCommonMovieRatings(int uid1, int uid2) {
		// TODO Auto-generated method stub
		return null;
	}
	public double getAverageRatingForUser(int uid1) {
		// TODO Auto-generated method stub
		return 0;
	}
	public ArrayList<Triple> getCommonMovieRatAndAve(int uid1, int uid2) {
		// TODO Auto-generated method stub
		return null;
	}
	public int getNumberOfUsers() {
		// TODO Auto-generated method stub
		return 0;
	}
}
