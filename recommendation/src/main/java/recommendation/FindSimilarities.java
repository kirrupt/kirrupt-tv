package recommendation;

import recommendation.PearsonSimilarityMethod;
import recommendation.reader.DataReaderFromDB;
import recommendation.ItemBasedModelBuilder;
import recommendation.writer.SimilarityWriterToDB;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class FindSimilarities {

    public static void main(String[] args) {
        System.out.println("Hello, World");


        JSONParser parser = new JSONParser();

        String host="", name="", user="", password="";

        try {

            Object obj = parser.parse(new FileReader("./config.json"));

            JSONObject jsonObject = (JSONObject) obj;

            host = (String) jsonObject.get("host");
            user = (String) jsonObject.get("user");
            name = (String) jsonObject.get("name");
            password = (String) jsonObject.get("password");

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        DatabaseImpl dbi = new DatabaseImpl(name, "recommendation_top_users_ratings", "recommendation_movie", "recommendation_top_users", "recommendation_item_similarity");
        dbi.host = host;
        dbi.user = user;
        dbi.password = password;
        DataReaderFromDB db = new DataReaderFromDB(dbi);
        
        PearsonSimilarityMethod sim = new PearsonSimilarityMethod();

        //double findSimilarity(DataReader dataReader, int mid1, int mid2)

        //double x=  sim.findSimilarity(db, 10,20);
        //System.out.println(x);

        SimilarityWriterToDB sw = new SimilarityWriterToDB(dbi, "recommendation_item_similarity");
        ItemBasedModelBuilder builder = new ItemBasedModelBuilder(db, sw, sim);
        builder.buildModel(false, false);
    }

}
