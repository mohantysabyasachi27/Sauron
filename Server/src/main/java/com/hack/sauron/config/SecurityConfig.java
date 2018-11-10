package com.hack.sauron.config;

import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.hack.sauron.security.handlers.SpringLogoutSuccessHandler;
import com.hack.sauron.security.handlers.UserAuthenticationFailureHandler;
import com.hack.sauron.security.handlers.UserAuthenticationSuccessHandler;

@EnableWebSecurity
@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	private UserDetailsService userDetailsService;

	@Autowired
	private PasswordEncoder passwordencoder;

	@Autowired
	private SpringLogoutSuccessHandler springLogoutSuccessHandler;

/*	@Autowired
	private AuthenticationEntryPoint authEntryPoint;*/

	/*@Autowired
	private UserGoogleAuthenticationSuccessHandler userGoogleAuthenticationHandler;
	*/
	
	@Autowired
	private UserAuthenticationFailureHandler userAuthenticationFailureHandler;
	
	@Autowired
	private UserAuthenticationSuccessHandler userAuthenticationSuccessHandler;

	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(userDetailsService).passwordEncoder(passwordencoder);
	}

	@Autowired
	public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
		auth.userDetailsService(userDetailsService).passwordEncoder(passwordencoder);
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.csrf().disable();
		http.cors();
		http.authorizeRequests().antMatchers("/login/**").authenticated().anyRequest().permitAll().and().formLogin()
				.failureUrl("/login?error").failureHandler(userAuthenticationFailureHandler)
				.successHandler(userAuthenticationSuccessHandler)
				.permitAll().and().logout()
				.deleteCookies("MYSESSIONID").invalidateHttpSession(true)
				.logoutUrl("/logout").logoutSuccessHandler(springLogoutSuccessHandler);
	}

	@Bean
	CorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration configuration = new CorsConfiguration();
		configuration.setAllowedOrigins(Arrays.asList("*"));
		configuration.setAllowedMethods(Arrays.asList("GET", "POST"));
		configuration.addAllowedHeader("*");
		configuration.addAllowedMethod("*");
		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", configuration);
		return source;
	}

}
