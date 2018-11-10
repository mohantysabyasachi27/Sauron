package com.hack.sauron;

import java.io.IOException;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.hack.sauron.models.User;

@SpringBootApplication
public class SauronApplication {

	public static void main(String[] args) throws JsonGenerationException, JsonMappingException, IOException {
		SpringApplication.run(SauronApplication.class, args);
/*		ObjectMapper mapp = new ObjectMapper();
		User user = new User();
		user.setFirstName("Sunny");
		user.setLastName("Mohanty");
		user.setEmailId("smohan31@asu.edu");
		user.setMobile("4806166215");
		user.setAddress("1028 E Orange St");
		System.out.println(mapp.writeValueAsString(user));*/
		
	}
}
