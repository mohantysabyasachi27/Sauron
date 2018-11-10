package com.hack.sauron.controllers;

import java.util.Date;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.hack.sauron.models.ListOfTickets;

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

		try {
			Ticket ticket = map.readValue(ticketData.getBytes(), Ticket.class);
			ticketService.addTicket(multipartFile, ticket);
			return new ResponseEntity<Response>(response, HttpStatus.OK);
		} catch (Exception e) {

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
	public ResponseEntity<Response> getTicket(@RequestParam String adminUserId, @RequestParam Date startDate,
			@RequestParam Boolean isPending) {
		Response response = new Response("200", true, "");
		try {
			ticketService.getTickets(adminUserId, startDate, isPending);
			return new ResponseEntity<Response>(response, HttpStatus.OK);
		} catch (Exception e) {

			response.setStatusCode("500");
			return new ResponseEntity<Response>(response, HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}

	@RequestMapping(method = RequestMethod.PUT)
	public ResponseEntity<Response> updateTicket(@RequestParam Ticket ticket) {
		Response response = new Response("200", true, "");
		try {
			ticketService.updateTicket(ticket);
			return new ResponseEntity<Response>(response, HttpStatus.OK);
		} catch (Exception e) {
			response.setStatusCode("500");
			return new ResponseEntity<Response>(response, HttpStatus.INTERNAL_SERVER_ERROR);

		}

	}

}
