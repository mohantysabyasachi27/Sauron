package com.hack.sauron.service;

import java.io.IOException;
import java.util.Collections;
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
	private TicketRepository ticketRepository;

	@Override
	public List<Ticket> getTicketsWithinRadius(Double lat, Double lon, Double radius, Date startDate,
			Boolean isPending) {
		Point point = new Point(lon, lat);
		Distance distance = new Distance(100, Metrics.KILOMETERS);
		Circle circle = new Circle(point, distance);
		Criteria geoCriteria = Criteria.where("location").withinSphere(circle);
		geoCriteria.andOperator(Criteria.where("date").gte(startDate));
		if (isPending)
			geoCriteria.andOperator(
					Criteria.where("status").in(SauronConstant.REJECTED_TICKET, SauronConstant.APPROVED_TICKET));
		else
			geoCriteria.andOperator(Criteria.where("status").in(SauronConstant.PENDING_TICKET));

		Query query = Query.query(geoCriteria);
		return mongoTemplate.find(query, Ticket.class);
	}

	public int addTicket(MultipartFile file, Ticket ticket) throws IOException {

		try {

			// ticketRepository.save(ticket);
			// System.out.println("TicketId"+ticket.getTicketId());

			String address = revGeoCodeService.reverseGeocode(ticket.getLatitude(), ticket.getLongitude());
			ticket.setAddress(address);
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

			if (admin.getIsAdmin()) {
				return getTicketsWithinRadius(admin.getOfficeLatLng()[0], admin.getOfficeLatLng()[1], 10.0, startDate,
						isPending);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return Collections.<Ticket>emptyList();
	}

	@Override
	public void updateTicket(Ticket ticket) {
		ticketRepository.save(ticket);
	}

}
