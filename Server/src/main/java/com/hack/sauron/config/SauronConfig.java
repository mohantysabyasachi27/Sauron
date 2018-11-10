package com.hack.sauron.config;

import org.jasypt.util.password.StrongPasswordEncryptor;
import org.springframework.context.annotation.Bean;
import org.springframework.data.mongodb.MongoDbFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoDbFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.client.RestTemplate;

import com.hack.sauron.security.handlers.SpringLogoutSuccessHandler;
import com.hack.sauron.security.handlers.SpringSecurityUserLoginService;
import com.hack.sauron.security.handlers.UserLoginService;
import com.mongodb.MongoClient;

public class SauronConfig {

	@Bean
	public UserLoginService userLoginService() {
		return new SpringSecurityUserLoginService();
	}

	@Bean
	public RestTemplate restTemlate() {
		return new RestTemplate();
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
	public StrongPasswordEncryptor strongPasswordEncryptor() {
		return new StrongPasswordEncryptor();
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
