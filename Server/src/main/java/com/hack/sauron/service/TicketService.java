package com.hack.sauron.service;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.hack.sauron.models.Ticket;

public interface TicketService {
	
	public int addTicket(MultipartFile multipartFile, Ticket ticket) throws IOException;

	public List<Ticket> getTicketsForUser(String userName);

	public List<Ticket> getTickets(String adminUserId, Date startDate, Boolean isPending);

	public void updateTicket(Ticket ticket);

	List<Ticket> getTicketsWithinRadius(Double lat, Double lon, Double radius, Date startDate, Boolean isPending);
	
}
