package recommendation.controllers;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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
    private String getShowsForQuery(String sql) throws SQLException {
        DatabaseImpl dbi = DatabaseImpl.getInstance();
        dbi.openConnection();

        Statement stmt = dbi.con.createStatement();

        List<Integer> ids = new ArrayList<>();
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            ids.add(rs.getInt(1));
        }

        stmt.close();;

        JSONObject obj = new JSONObject();
        obj.put("shows", ids);
        return obj.toJSONString();
    }

    @RequestMapping("/me")
    public String me(@RequestHeader(value="x-user") String user) throws ParseException, SQLException

    {
        JSONObject o = (JSONObject)new JSONParser().parse(user);

        String sql = "SELECT mid" +
                "     FROM  `recommendation_top_users_ratings`" +
                "     WHERE  `uid` = " + Integer.valueOf(o.get("Id").toString()) +
                "     ORDER BY `rating` DESC";

        return getShowsForQuery(sql);
    }

    @RequestMapping("/show/")
    public String show(@RequestHeader(value="x-user") String user) {
        return user;
    }
}
