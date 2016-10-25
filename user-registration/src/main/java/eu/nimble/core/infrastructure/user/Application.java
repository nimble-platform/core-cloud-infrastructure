package eu.nimble.core.infrastructure.user;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.feign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@Configuration
@ComponentScan
@EnableAutoConfiguration
@RestController
@EnableFeignClients
@EnableEurekaClient
public class Application {

    private static Logger log = LoggerFactory.getLogger(Application.class);

    @RequestMapping("/user/{userId}")
    public String getUser(@PathVariable("userId") String userId) {

        log.info("Handling user with id " + userId);

        return "Returning user with id: " + userId;
    }

    @RequestMapping("/")
    public String home() {
        return "home";
    }

    public static void main(String[] args) {
        new SpringApplicationBuilder(Application.class).web(true).run(args);
    }
}

