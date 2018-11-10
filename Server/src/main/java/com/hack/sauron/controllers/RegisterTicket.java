package com.hack.sauron.controllers;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.hack.sauron.models.Response;
import com.hack.sauron.models.Ticket;
import com.hack.sauron.service.RegisterTicketService;

@RestController
@RequestMapping(value = "/ticket")
public class RegisterTicket {

	@Autowired
	RegisterTicketService registerService;

	@RequestMapping("/register")
	public ResponseEntity<Response> regTicket(@RequestParam("file") MultipartFile multipartFile,
			@RequestParam String ticketData) {
		Response response = new Response("200", true, "");
		 Gson gson = new Gson();
	        Ticket ticket = gson.fromJson( ticketData, Ticket.class ); 
		try {
			registerService.registerTicket(multipartFile, ticket);
			return new ResponseEntity<Response>(response, HttpStatus.OK);
		} catch (Exception e) {

			response.setStatusCode("500");
			return new ResponseEntity<Response>(response, HttpStatus.INTERNAL_SERVER_ERROR);

		}

	}
}
