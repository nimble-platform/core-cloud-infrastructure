package eu.nimble.core.infrastructure.gateway.filter;

import com.netflix.zuul.ZuulFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.netflix.zuul.context.RequestContext;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CustomCorsFilter extends ZuulFilter {

    private static Logger log = LoggerFactory.getLogger(CustomCorsFilter.class);

    @Override
    public String filterType() {
        return "post";
    }

    @Override
    public int filterOrder() {
        return 1;
    }

    @Override
    public boolean shouldFilter() {
        return true;
    }

    @Override
    public Object run() {
        RequestContext ctx = RequestContext.getCurrentContext();
        HttpServletRequest request = ctx.getRequest();

        log.info(String.format("%s request to %s", request.getMethod(), request.getRequestURL().toString()));

        // adding CORS header
        HttpServletResponse response = ctx.getResponse();
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, PUT, GET, OPTIONS, DELETE, PATCH");
        response.setHeader("Access-Control-Allow-Headers", "origin, content-type, accept, x-requested-with");
        response.setHeader("Access-Control-Max-Age", "3600");

        return null;
    }

}