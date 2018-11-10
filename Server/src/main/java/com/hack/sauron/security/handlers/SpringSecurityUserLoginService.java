package com.hack.sauron.security.handlers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.request.RequestContextHolder;

import com.hack.sauron.models.CustomUserDetails;
import com.hack.sauron.models.User;
import com.hack.sauron.service.UserRepository;

public class SpringSecurityUserLoginService implements UserLoginService {

	@Autowired
	private UserLoginService userLoginService;

	@Autowired
	private UserRepository userRepository;

	public SpringSecurityUserLoginService() {

	}

	@Override
	public void logout() {
		// SecurityContextHolder.getContext().setAuthentication(null);
		System.out.println(userLoginService.getLoggedUserDetails().getUserName());
		SecurityContextHolder.clearContext();
	}

	@Override
	public boolean isLoggedIn() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		return isAuthenticated(authentication);
	}

	@Override
	public CustomUserDetails getLoggedUserDetails() {
		CustomUserDetails loggedUserDetails = null;
		String sessionId = RequestContextHolder.currentRequestAttributes().getSessionId();
		System.out.println(sessionId);
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (isAuthenticated(authentication)) {
			Object principal = authentication.getPrincipal();
			if (principal instanceof CustomUserDetails) {
				loggedUserDetails = ((CustomUserDetails) principal);
			}
		}
		return loggedUserDetails;
	}

	private boolean isAuthenticated(Authentication authentication) {
		return authentication != null && !(authentication instanceof AnonymousAuthenticationToken)
				&& authentication.isAuthenticated();
	}

	@Override
	public User getLoggedUser() {
		User loggedUser = null;
		CustomUserDetails userDetails = getLoggedUserDetails();
		if (userDetails != null) {
			loggedUser = userRepository.findByUserName(userDetails.getUserName());
		}
		return loggedUser;
	}

}
