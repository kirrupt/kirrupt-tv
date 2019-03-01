package recommendation.controllers;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import recommendation.db.DatabaseImpl;
import recommendation.reader.DataReaderFromDB;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@RestController
public class RecommendationController {
    private List<Integer> getShowsForQuery(String sql) throws SQLException {
        System.out.println(sql);
        DatabaseImpl dbi = DatabaseImpl.getInstance();
        dbi.openConnection();

        Statement stmt = dbi.con.createStatement();

        List<Integer> ids = new ArrayList<>();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            ids.add(rs.getInt(1));
        }

        stmt.close();

        return ids;
    }

    @RequestMapping("/me")
    public List<Integer> me(@RequestHeader(value="x-user") String user) throws ParseException, SQLException

    {
        JSONObject o = (JSONObject)new JSONParser().parse(user);
        Integer userId = Integer.valueOf(o.get("Id").toString());

        String sql = "SELECT mid2, (similarity*weight) as o" +
                "    FROM  `recommendation_item_similarity`" +
                "    LEFT JOIN recommendation_top_users_ratings us" +
                "    ON us.mid = mid2 AND us.uid = " + userId +
                "    where us.uid is null" +
                "    AND mid1 in (" +
                "" +
                "SELECT mid" +
                "                     FROM  `recommendation_top_users_ratings`" +
                "                     WHERE  `uid` = " + userId +
                "                     ORDER BY `rating` DESC" +
                ")" +
                "    ORDER BY o DESC" +
                "    LIMIT 100";

        return getShowsForQuery(sql);
    }

    @RequestMapping("/show/{id}")
    public List<Integer> show(@PathVariable(value="id") Integer showId) throws ParseException, SQLException {
        String sql = "SELECT mid2," +
                "        (weight*similarity) as o" +
                "      FROM  `recommendation_item_similarity`" +
                "      WHERE mid1 = " + showId +
                "      ORDER BY o DESC" +
                "      LIMIT 0 , 50";

        return getShowsForQuery(sql);
    }
}
