package com.hack.sauron.service;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.hack.sauron.models.Ticket;

public interface TicketRepository extends MongoRepository<Ticket, String> {

	
}
