package recommendation.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import recommendation.db.DatabaseImpl;
import recommendation.reader.DataReaderFromDB;
import recommendation.similarities.ItemBasedModelBuilder;
import recommendation.similarities.PearsonSimilarityMethod;
import recommendation.writer.SimilarityWriterToDB;

import java.sql.SQLException;




@RestController
public class TaskController {
    @RequestMapping("/tasks/find-similarities")
    public String findSimilarities() throws SQLException {
        DatabaseImpl dbi = DatabaseImpl.getInstance();

        DataReaderFromDB db = new DataReaderFromDB(dbi);

        dbi.createTables();

        dbi.calculateUserRatings();
        dbi.calculateMovieRating();
        dbi.calculateTopUsers();

        // We truncate here, but the table should be removed and recreated in `createTables()` anyways.
        dbi.truncateSimilarityTable();

        PearsonSimilarityMethod sim = new PearsonSimilarityMethod();

        //double findSimilarity(DataReader dataReader, int mid1, int mid2)

        //double x=  sim.findSimilarity(db, 10,20);
        //System.out.println(x);

        SimilarityWriterToDB sw = new SimilarityWriterToDB(dbi, "recommendation_item_similarity");
        ItemBasedModelBuilder builder = new ItemBasedModelBuilder(db, sw, sim);
        builder.buildModel(false, false);

        return "yeah";
    }
}
