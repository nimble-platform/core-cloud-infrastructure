package eu.nimble.core.infrastructure.gateway.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationStartedEvent;
import org.springframework.cloud.netflix.ribbon.SpringClientFactory;
import org.springframework.cloud.netflix.ribbon.apache.RibbonLoadBalancingHttpClient;
import org.springframework.cloud.netflix.zuul.filters.ZuulProperties;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import java.util.Map;

// https://github.com/spring-cloud/spring-cloud-netflix/issues/1334

@Component
public class RibbonEarlyInstantiator implements ApplicationListener<ApplicationStartedEvent> {

    private static Logger logger = LoggerFactory.getLogger(RibbonEarlyInstantiator.class);

    @Autowired
    private ZuulProperties zuulProperties;

    @Autowired
    private SpringClientFactory springClientFactory;

    @Override
    public void onApplicationEvent(ApplicationStartedEvent event)
    {
        Map<String, ZuulProperties.ZuulRoute> routes = zuulProperties.getRoutes();
        routes.values()
                .stream()
                .filter(route -> route.getServiceId() != null)
                .map(ZuulProperties.ZuulRoute::getServiceId)
                .distinct()
                .forEach(serviceId -> {
                    logger.info("Instantiating the context for the client '{}'", serviceId);
                    springClientFactory.getClient(serviceId, RibbonLoadBalancingHttpClient.class); //Or RestClient.class if you still use it
                });
    }
}
