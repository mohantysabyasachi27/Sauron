package com.hack.sauron.service;

import java.net.MalformedURLException;
import java.net.URISyntaxException;
import java.net.URL;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

public class ReverseGeocodeServiceImpl implements ReverseGeocodeService {

	
	
	@Autowired
	private RestTemplate restTemplate;
	
	
	public static String baseGoogleUrl="https://maps.googleapis.com/maps/api/geocode/json?";
	
	public String reverseGeocode(Double lat, Double lon) {
		StringBuilder url = new StringBuilder();
		url.append(baseGoogleUrl);
		url.append("latlng=").append(lat).append(",").append(lon).append("&key=").append(ReverseGeocodeService.apiKey);
		URL _url;
		try {
			_url = new URL(url.toString());
			Object json = restTemplate.getForObject(_url.toURI(), Object.class);
			System.out.println(json);
		} catch (MalformedURLException | RestClientException | URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return null;

	}
	

}
