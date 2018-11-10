package com.hack.sauron.security.handlers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.hack.sauron.models.CustomUserDetails;
import com.hack.sauron.models.User;
import com.hack.sauron.service.UserRepository;

@Service
public class UserAuthService implements UserDetailsService {

	@Autowired
	private UserRepository userRepository;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		User user = userRepository.findByUserName(username);
		if (null != user) {
			CustomUserDetails customUserDetails = new CustomUserDetails(user);
			Authentication authentication= new UsernamePasswordAuthenticationToken(customUserDetails, null, customUserDetails.getAuthorities()) ; 
			SecurityContextHolder.getContext().setAuthentication(authentication);
			return customUserDetails;
		}
		throw new UsernameNotFoundException("User is not found in the system");
	}

}
