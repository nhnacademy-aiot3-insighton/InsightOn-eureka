package com.nhnacademy.insightoneureka;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class InsightonEurekaApplication {

    public static void main(String[] args) {
        SpringApplication.run(InsightonEurekaApplication.class, args);
    }

}
