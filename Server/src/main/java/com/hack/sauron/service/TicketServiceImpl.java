package com.hack.sauron.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.geo.Circle;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.AmazonServiceException;
import com.hack.sauron.models.ListOfTickets;
import com.hack.sauron.models.Ticket;

public class TicketServiceImpl implements TicketService {

	@Autowired
	private MongoTemplate mongoTemplate;
	
	@Autowired
	private FileUploaderAsyncService fileUploaderAsyncService;

	@Override
	public List<Ticket> getTicketsWithinRadius(Double lat, Double lon, int radius) {
		Point point = new Point(lon, lat);
		Distance distance = new Distance(100, Metrics.KILOMETERS);
		Circle circle = new Circle(point, distance);
		Criteria geoCriteria = Criteria.where("location").withinSphere(circle);
		
		Query query = Query.query(geoCriteria);
		return mongoTemplate.find(query, Ticket.class);
	}

	public int addTicket(MultipartFile file, Ticket ticket) throws IOException {

		try {
		
			mongoTemplate.save(ticket);
			System.out.println("TicketId"+ticket.getTicketId());
			fileUploaderAsyncService.async(file, "", ticket.getUsername(), ticket.getDate(), ticket.getTicketId());
		} catch (AmazonServiceException ase) {
			ase.printStackTrace();
		}
		return 200;
	}

	@Override
	public List<Ticket> getTicketsForUser(String userName) {
		
		Criteria userCrit = Criteria.where("username").is(userName);
		Query query = Query.query(userCrit);
		List<Ticket> ticketList = mongoTemplate.find(query, Ticket.class);
		return ticketList;
	}



}
