package com.hack.sauron.service;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.hack.sauron.models.User;

public interface UserRepository extends MongoRepository<User, String> {
	
	public User findByUserName(String userName);

	public User findByEmailId(String userEmailId);

	public User findByMobile(String userContactNo);
	
}
