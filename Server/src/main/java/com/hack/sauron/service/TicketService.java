package com.hack.sauron.service;

import java.io.IOException;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.hack.sauron.models.ListOfTickets;
import com.hack.sauron.models.Ticket;

public interface TicketService {

	public List<Ticket> getTicketsWithinRadius(Double lat, Double lon, int radius);
	
	public int addTicket(MultipartFile multipartFile, Ticket ticket) throws IOException;

	public List<Ticket> getTicketsForUser(String userName);
	
}
