package com.hack.sauron.service;

public interface ReverseGeocodeService {

	public static final String apiKey = "AIzaSyD2QY6skAiuN9T60lP1eLTm3-OpkMga5UU";
	
	String reverseGeocode(Double lat, Double lon);
	
	
}
