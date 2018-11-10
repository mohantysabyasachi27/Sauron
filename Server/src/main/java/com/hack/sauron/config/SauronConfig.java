package com.hack.sauron.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.MongoDbFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoDbFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.client.RestTemplate;

import com.hack.sauron.security.handlers.SpringLogoutSuccessHandler;
import com.hack.sauron.security.handlers.SpringSecurityUserLoginService;
import com.hack.sauron.security.handlers.UserLoginService;
import com.hack.sauron.service.CacheService;
import com.hack.sauron.service.CacheServiceImpl;
import com.hack.sauron.service.ReverseGeocodeService;
import com.hack.sauron.service.ReverseGeocodeServiceImpl;
import com.hack.sauron.service.TicketService;
import com.hack.sauron.service.TicketServiceImpl;
import com.hack.sauron.service.UserService;
import com.hack.sauron.service.UserServiceImpl;
import com.mongodb.MongoClient;

@Configuration
public class SauronConfig {
	
	@Bean
	public UserLoginService userLoginService() {
		return new SpringSecurityUserLoginService();
	}

	@Bean
	public ReverseGeocodeService reverseGeocodeService() {
		return new ReverseGeocodeServiceImpl();
	}
	
	@Bean
	public UserService userService() {
		return new UserServiceImpl();
	}
	
	@Bean
	public CacheService cacheService() {
		return new CacheServiceImpl();
	}
	
	@Bean
	public RestTemplate restTemlate() {
		return new RestTemplate();
	}
	
	@Bean
	public TicketService ticketService() {
		return new TicketServiceImpl();	
	}

	public @Bean MongoDbFactory mongoDbFactory() throws Exception {
		return new SimpleMongoDbFactory(new MongoClient(), "sauron");
	}

	@Bean
	public MongoTemplate mongoTemplate() throws Exception {
		MongoTemplate mongoTemplate = new MongoTemplate(mongoDbFactory());
		return mongoTemplate;
	}

	@Bean
	public PasswordEncoder passwordencoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public SpringLogoutSuccessHandler springLogoutSuccessHandler() {
		return new SpringLogoutSuccessHandler();
	}

}
