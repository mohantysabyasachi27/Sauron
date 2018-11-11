package com.hack.sauron.controllers;

import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.hack.sauron.models.Response;
import com.hack.sauron.models.User;
import com.hack.sauron.service.ReverseGeocodeService;
import com.hack.sauron.service.UserService;

@RestController
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class UserController {

	public static Logger logger = LogManager.getLogger(UserController.class);

	@Autowired
	private UserService userService;

	@Autowired
	private ReverseGeocodeService reverseGeocodeService;

	@RequestMapping(value = "/geocode", method = RequestMethod.GET, produces = "application/json")
	public ResponseEntity<String> getListOfMovies(HttpServletRequest request) {
		reverseGeocodeService.reverseGeocode(40.714224, -73.961452);
		return new ResponseEntity<String>("success", HttpStatus.OK);
	}

	@RequestMapping(method = RequestMethod.POST, value = "/users")
	public @ResponseBody ResponseEntity<Response> addUser(@RequestBody User user) {
		logger.info("Entering the Register User Method", user);
		Boolean response;
		if(null==user)
			System.out.println("Null");
			
		try {
			response = userService.addUser(user);
		} catch (Exception e) {
			return new ResponseEntity<Response>(new Response("200", false, "Non Unique EmailId"), HttpStatus.OK);
		}
		return new ResponseEntity<Response>(new Response("200", response, null), HttpStatus.OK);
	}

	@RequestMapping(method = RequestMethod.PUT, value = "/users")
	public @ResponseBody ResponseEntity<?> changePassword(@RequestBody User user) {
		Response response = new Response(null, false, null);
		ResponseEntity<Response> responseBody = new ResponseEntity<Response>(response, HttpStatus.OK);
		try {
			userService.updateUser(user);
		} catch (Exception e) {
			response = new Response("200", false, "Failed to Update");
			return new ResponseEntity<Response>(response, HttpStatus.OK);
		}
		return responseBody;
	}

	@RequestMapping(method = RequestMethod.GET, value = "/users/{userName}")
	public @ResponseBody ResponseEntity<?> getUser(@PathVariable String userName) {
		User userDetails = null;
		try {
			userDetails = userService.getUser(userName);
			return new ResponseEntity<User>(userDetails, HttpStatus.OK);
		} catch (Exception ex) {
			return new ResponseEntity<Response>(new Response(HttpStatus.FORBIDDEN.toString(), false, ex.getMessage()),
					HttpStatus.OK);
		}

	}

	@RequestMapping(method = RequestMethod.GET, value = "/admin/users")
	public Boolean createAdmin() throws Exception {
		// Create Admin user
		User user = new User();
		user.setFirstName("Admin");
		user.setLastName("Admin");
		user.setEmailId("admin@asu.edu");
		user.setPassword("admin");
		user.setMobile("7795641569");
		user.setAddress("El Paisano Market");
		user.setIsAdmin(Boolean.TRUE);
		user.setOfficeLatLng(new Double[] { 33.4164308, -111.924745, });
		userService.addUser(user);
		return true;
	}

}
