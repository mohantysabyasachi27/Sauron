package com.hack.sauron.security.handlers;

import com.hack.sauron.models.CustomUserDetails;
import com.hack.sauron.models.User;

public interface UserLoginService {
	
	User getLoggedUser();

	CustomUserDetails getLoggedUserDetails();

	void logout();

	boolean isLoggedIn();

}
