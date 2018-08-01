package kirrupt.tvrecommendation.findSimilarities;

import java.util.Comparator;
import java.util.TreeSet;
import java.util.HashMap;
import java.util.ArrayList;

import kirrupt.tvrecommendation.findSimilarities.SimilarityMethod;
import kirrupt.tvrecommendation.findSimilarities.reader.DataReader;

import kirrupt.tvrecommendation.findSimilarities.writer.SimilarityWriter;
//import netflix.algorithms.modelbased.writer.UserSimKeeper;

import kirrupt.tvrecommendation.findSimilarities.utilities.Key;
import kirrupt.tvrecommendation.findSimilarities.utilities.DoublePair;
import kirrupt.tvrecommendation.findSimilarities.utilities.Pair;
import kirrupt.tvrecommendation.findSimilarities.utilities.IntDoubleIntTriple;
import kirrupt.tvrecommendation.findSimilarities.utilities.IntDoublePair;
import kirrupt.tvrecommendation.findSimilarities.utilities.Timer227;

/**
 * General class for writing an item-based model builder.
 * @author Amrit Tuladhar
 *
 */
public class ItemBasedModelBuilder {
    DataReader dataReader;
    SimilarityWriter similarityWriter;
    SimilarityMethod similarityMethod;
    int numSimilarItems;
    String fileName;

    public ItemBasedModelBuilder(DataReader dataReader,
            SimilarityWriter similarityWriter,
            SimilarityMethod similarityMethod) {
        this.dataReader = dataReader;
        this.similarityWriter = similarityWriter;
        this.similarityMethod = similarityMethod;
        this.numSimilarItems = 50;
    }

    public ItemBasedModelBuilder(DataReader dataReader,
            SimilarityWriter similarityWriter,
            SimilarityMethod similarityMethod,
            int numSimilarItems) {
        this.dataReader = dataReader;
        this.similarityWriter = similarityWriter;
        this.similarityMethod = similarityMethod;
        this.numSimilarItems = numSimilarItems;
    }
    
    /**
     * @author steinbel
     * Sets the name of the file to which the UserSimKeeper should be serialized if
     * we're working in memory
     * @param name - the filename
     */
    public void setFileName(String name) {
    	this.fileName = name;
    }
    
    //overloaded method added for backwards compatibility - steinbel
    public boolean buildModel() {
    	return buildModel(false, false);
    }


    
    /**
     * @author tuladara
     * Modified by steinbel to work with users.
     * @param inMemory - if the results should be written to a serializable object.
     * @param users - if we're calculating on users instead of movies
     * @return - true on completion
     */
    public boolean buildModel(boolean inMemory, boolean users) {
        Timer227 tim = new Timer227();
        Timer227 modelTim = new Timer227();
        ArrayList<IntDoubleIntTriple> similarMovies = new ArrayList<IntDoubleIntTriple>();

        ArrayList<Integer>ids = dataReader.getMovieIDs();

        int numberOfMovies = ids.size();
        if (users)
        	numberOfMovies = ids.size();
        int firstMovieId = 0;

        int startMovieId = 0;
        modelTim.start();
        try {
            for (int m=startMovieId; m<numberOfMovies; m++) {
                similarMovies.clear();
                //System.out.print("Building model for " + m + " id="+ids.get(m)+"...");
               // tim.start();

                HashMap<Key, ArrayList<DoublePair>>ratings = dataReader.getCommonUserRatingsForMid(ids.get(m));

                //System.out.println(ratings.size());


                for (int n=firstMovieId; n<numberOfMovies; n++) {
                    if (m!=n) {
                    	DoublePair sim = null;
                    	//if (users)
                    		//sim = similarityMethod.findUserSimilarity(dataReader, ratings, ids.get(m), ids.get(n));
                    	//else
                    		sim = similarityMethod.findSimilarity(dataReader,ratings, ids.get(m), ids.get(n));
                        if(sim.a>-100) {
                           similarMovies.add(new IntDoubleIntTriple((int)ids.get(n), sim.a, (int)sim.b)); 
                        }
                        
                    }
                }
                int count = 1;

                if(similarMovies.size()>0) {
                    similarityWriter.writeBatch(ids.get(m), similarMovies);
                }

                /*for (IntDoublePair p : similarMovies) {
                  //  if (count > numSimilarItems)
                  //      break;
                    similarityWriter.write(ids.get(m), p.a, p.b);
                    count++;
                }*/
                //tim.stop();
                //System.out.println("done: " + tim.getMilliTime() + " ms");
                //tim.resetTimer();
            }

            dataReader.close();
            if (inMemory) {
            	//UserSimKeeper.serialize(fileName, (UserSimKeeper) similarityWriter);
            }
            similarityWriter.close();
        } catch(Exception e) {
            e.printStackTrace();
        }

        modelTim.stop();
        System.out.println("Model done: " + modelTim.getMilliTime() + " ms");
        

        return true;
    }


    protected class RatingComparator implements Comparator<IntDoublePair> {
        public int compare(IntDoublePair p1, IntDoublePair p2) {
            // Reverse order stored
            if (p1.b <= p2.b) {
                return 1;
            }
            return -1;
        }        
    }
}
