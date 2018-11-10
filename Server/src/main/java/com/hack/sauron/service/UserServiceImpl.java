package com.hack.sauron.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.hack.sauron.models.User;

public class UserServiceImpl implements UserService{

	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private PasswordEncoder passwordencoder;
	
	@Override
	public Boolean addUser(User user) throws Exception{
		user.setPassword(passwordencoder.encode(user.getPassword()));
		userRepository.save(user);
		System.out.println(user.getId());
		return true;
	}

	@Override
	public Boolean updateUser(User user) {
		userRepository.save(user);
		
		
		return true;
	}

	@Override
	public User getUser(String userName) throws Exception {
		return userRepository.findByEmailId(userName);
	}



}
