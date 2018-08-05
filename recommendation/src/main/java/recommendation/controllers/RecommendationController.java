package recommendation.controllers;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class RecommendationController {

    @RequestMapping("/")
    public String index() {
        return "????";
    }

}
