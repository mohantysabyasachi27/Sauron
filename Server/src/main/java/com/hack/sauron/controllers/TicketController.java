package com.hack.sauron.controllers;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hack.sauron.models.Response;
import com.hack.sauron.models.Ticket;
import com.hack.sauron.service.TicketService;

@RestController
@RequestMapping(value = "/ticket")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class TicketController {

	@Autowired
	TicketService ticketService;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Response> regTicket(@RequestParam("file") MultipartFile multipartFile,
			@RequestParam String ticketData) {

		Response response = new Response("200", true, "");
		ObjectMapper map = new ObjectMapper();

	/*	// System.out.println(ticketData);
		String data = (String) ticketData;
		StringBuilder sb = new StringBuilder(data);
		sb.setCharAt(0, '{');
		sb.setCharAt(sb.length() - 1, '}');
		data = sb.toString();
		System.out.println(data);*/

		System.out.println((String)ticketData);
		try {
			Ticket ticket = map.readValue(ticketData, Ticket.class);
			ticketService.addTicket(multipartFile, ticket);
			return new ResponseEntity<Response>(response, HttpStatus.OK);
		} catch (Exception e) {

			e.printStackTrace();
			response.setStatusCode("500");
			return new ResponseEntity<Response>(response, HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}
	
	@RequestMapping(method = RequestMethod.POST,value="/ios")
	public ResponseEntity<Response> regTicketIos(@RequestParam("file") MultipartFile multipartFile,
			@RequestParam Object ticketData) {

		Response response = new Response("200", true, "");
		ObjectMapper map = new ObjectMapper();

		// System.out.println(ticketData);
		String data = (String) ticketData;
		StringBuilder sb = new StringBuilder(data);
		sb.setCharAt(0, '{');
		sb.setCharAt(sb.length() - 1, '}');
		data = sb.toString();
		System.out.println(data);

		//System.out.println((String)ticketData);
		try {
			Ticket ticket = map.readValue(data, Ticket.class);
			ticketService.addTicket(multipartFile, ticket);
			return new ResponseEntity<Response>(response, HttpStatus.OK);
		} catch (Exception e) {

			e.printStackTrace();
			response.setStatusCode("500");
			return new ResponseEntity<Response>(response, HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}

	@RequestMapping(method = RequestMethod.GET, value = "/{userName}")
	public List<Ticket> getTickets(@PathVariable String userName) {

		if (StringUtils.isNotBlank(userName))
			return (List<Ticket>) ticketService.getTicketsForUser(userName);
		else
			return null;

	}

	@RequestMapping(method = RequestMethod.GET)
	public List<Ticket> getTicket(@RequestParam String adminUserId, @RequestParam String startDate,
			@RequestParam Boolean isPending) {
		Response response = new Response("200", true, "");
		try {
			DateFormat parser = new SimpleDateFormat("yyyy-MM-dd");
			Date date = (Date) parser.parse(startDate);
			List<Ticket> tickets = ticketService.getTickets(adminUserId, date, isPending);

			return tickets;
		} catch (Exception e) {

			response.setStatusCode("500");
			return null;
		}

	}

	@RequestMapping(method = RequestMethod.PUT)
	public ResponseEntity<Response> updateTicket(@RequestBody Ticket ticket) {
		Response response = new Response("200", true, "");
		try {
			ticketService.updateTicket(ticket);

			return new ResponseEntity<Response>(response, HttpStatus.OK);
		} catch (Exception e) {
			response.setStatusCode("500");
			return new ResponseEntity<Response>(response, HttpStatus.INTERNAL_SERVER_ERROR);

		}

	}

	@RequestMapping(method = RequestMethod.GET, value = "/aggregate")
	public Map<String, Integer> getTicketAll() {
		return ticketService.getTicketData();
	}

}
