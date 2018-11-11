package com.hack.sauron.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.geo.Circle;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.util.CollectionUtils;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.AmazonServiceException;
import com.hack.sauron.config.CategoryConfig;
import com.hack.sauron.constants.SauronConstant;
import com.hack.sauron.models.Ticket;
import com.hack.sauron.models.User;

public class TicketServiceImpl implements TicketService {

	@Autowired
	private MongoTemplate mongoTemplate;

	@Autowired
	private FileUploaderAsyncService fileUploaderAsyncService;

	@Autowired
	private ReverseGeocodeService revGeoCodeService;

	@Autowired
	private UserService userService;

	@Autowired
	private UserRepository userRepo;

	@Autowired
	private TicketRepository ticketRepository;
	@Autowired
	CategoryConfig categoryConfig;

	@Override
	public List<Ticket> getTicketsWithinRadius(Double lat, Double lon, Double radius, Date startDate,
			Boolean isPending) {
		Point point = new Point(lon, lat);
		Distance distance = new Distance(radius, Metrics.KILOMETERS);
		Circle circle = new Circle(point, distance);
		Criteria geoCriteria = Criteria.where("location").withinSphere(circle);
		geoCriteria.and("date").gte(startDate);
		if (isPending)
			geoCriteria.and("status").is(2);
		else
			geoCriteria.and("status").ne(2);
		Query query = Query.query(geoCriteria);
		return mongoTemplate.find(query, Ticket.class);
	}

	public int addTicket(MultipartFile file, Ticket ticket) throws IOException {

		try {
			String address = revGeoCodeService.reverseGeocode(ticket.getLongitude(), ticket.getLatitude());
			ticket.setAddress(address);
			ticket.setCategory(categoryConfig.getCategoryData().get(ticket.getCategoryId()));
			ticket.buildGeoJson();
			mongoTemplate.save(ticket);

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

	@Override
	public List<Ticket> getTickets(String adminUserId, Date startDate, Boolean isPending) {
		User admin;
		try {
			admin = userService.getUser(adminUserId);
			List<Ticket> list = new ArrayList<>();
			if (admin != null && admin.getIsAdmin()) {
				list = getTicketsWithinRadius(admin.getOfficeLatLng()[0], admin.getOfficeLatLng()[1], 10.0,
						startDate, isPending);
			}
			return list;

		} catch (Exception e) {
			System.out.println(e.getMessage());
			//e.printStackTrace();
		}
		return Collections.<Ticket>emptyList();
	}

	@Override
	public void updateTicket(Ticket ticket) {

		Double points = categoryConfig.getPointsData().get(ticket.getCategoryId());
		ticket.setPoints(points);
		/*
		 * Criteria crit = Criteria.where("username").is(ticket.getUsername()); Query
		 * query = Query.query(crit);
		 */
		User user = userRepo.findByUserName(ticket.getUsername());
		if (null != user) {
			user.setTotalPoints(user.getTotalPoints() + points);
			mongoTemplate.save(user, "User");

		}
		ticketRepository.save(ticket);
	}

	@Override
	public Map<String, Integer> getTicketData() {

		Map<String, Integer> mapTickets = new HashMap<>();
		Criteria userCrit = Criteria.where("status").is(1);
		Query query = Query.query(userCrit);

		List<Ticket> approvedTickets = mongoTemplate.find(query, Ticket.class, "Ticket");
		List<Ticket> allTickets = mongoTemplate.findAll(Ticket.class, "Ticket");

		if (null != approvedTickets)
			mapTickets.put("Approved", approvedTickets.size());
		else
			mapTickets.put("Approved", 0);
		if (null != approvedTickets)
			mapTickets.put("All", allTickets.size());
		else
			mapTickets.put("Approved", 0);

		return mapTickets;

	}

}
