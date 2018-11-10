package com.hack.sauron.service;

import org.springframework.beans.factory.annotation.Autowired;

import com.hack.sauron.models.User;

public class UserServiceImpl implements UserService{

	@Autowired
	private UserRepository userRepository;
	
	@Override
	public Boolean addUser(User user) throws Exception{
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
