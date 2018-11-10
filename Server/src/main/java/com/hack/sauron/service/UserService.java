package com.hack.sauron.service;

import com.hack.sauron.models.User;

public interface UserService {

	public Boolean addUser(User user) throws Exception;
	
	public Boolean updateUser(User user) throws Exception;
	
	public User getUser(String userName) throws Exception;
	
}
