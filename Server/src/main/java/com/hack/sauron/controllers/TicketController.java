package com.hack.sauron.controllers;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
public class TicketController {

	@Autowired
	TicketService ticketService;

	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Response> regTicket(@RequestParam("file") MultipartFile multipartFile,
			@RequestParam String ticketData) {


		Response response = new Response("200", true, "");
		//Gson gson = new Gson();
		//Ticket ticket = gson.fromJson(ticketData, Ticket.class);
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
}
