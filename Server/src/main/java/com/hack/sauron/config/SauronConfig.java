package com.hack.sauron.config;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.data.mongodb.MongoDbFactory;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoDbFactory;
import org.springframework.security.config.oauth2.client.CommonOAuth2Provider;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
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
@PropertySource("classpath:api.properties")
public class SauronConfig {

	
	private static List<String> clients = Arrays.asList("google"/* , "facebook" */);

	@Value("${spring.security.oauth2.client.clientId}")
	private String clientId;
	
	@Value("${spring.security.oauth2.client.clientSecret}")
	private String clientSecret;
	
	@Value("${spring.security.oauth2.client.accessTokenUri}")
	private String accessTokenUri;
	
	@Value("${spring.security.oauth2.client.redirectUriTemplate}")
	private String redirectUriTemplate;
	
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
	

	@Bean
	public ClientRegistrationRepository clientRegistrationRepository() {
		List<ClientRegistration> registrations = clients.stream().map(c -> getRegistration(c))
				.filter(registration -> registration != null).collect(Collectors.toList());

		return new InMemoryClientRegistrationRepository(registrations);
	}

	private ClientRegistration getRegistration(String client) {
		if (clientId == null) {
			return null;
		}

		if (client.equals("google")) {
			return CommonOAuth2Provider.GOOGLE.getBuilder(client).clientId(clientId).clientSecret(clientSecret)
					.redirectUriTemplate(redirectUriTemplate).build();
		}

		if (client.equals("facebook")) {
			return CommonOAuth2Provider.FACEBOOK.getBuilder(client).clientId(clientId).clientSecret(clientSecret)
					.build();
		}
		return null;
	}

}
