package com.hack.sauron;

import java.io.IOException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;

@SpringBootApplication
public class SauronApplication {
	
	public static void main(String[] args) throws JsonGenerationException, JsonMappingException, IOException {
		SpringApplication.run(SauronApplication.class, args);
		
	}
	
	/*@Bean
	EmbeddedServletContainerCustomizer containerCustomizer() throws Exception {
	   return (ConfigurableEmbeddedServletContainer container) -> {
	       if (container instanceof TomcatEmbeddedServletContainerFactory) {
	           TomcatEmbeddedServletContainerFactory tomcat = (TomcatEmbeddedServletContainerFactory) container;
	           tomcat.addConnectorCustomizers(
	               (connector) -> {
	                   connector.setMaxPostSize(10000000); // 10 MB
	               }
	           );
	       }
	   };
	}*/
}
