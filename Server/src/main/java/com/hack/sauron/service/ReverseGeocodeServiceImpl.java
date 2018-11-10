package com.hack.sauron.service;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.client.RestTemplate;

import com.google.maps.GeoApiContext;
import com.google.maps.GeocodingApi;
import com.google.maps.model.GeocodingResult;
import com.google.maps.model.LatLng;

public class ReverseGeocodeServiceImpl implements ReverseGeocodeService {

	@Autowired
	private RestTemplate restTemplate;

	public static String baseGoogleUrl = "https://maps.googleapis.com/maps/api/geocode/json?";

	public String reverseGeocode(Double lat, Double lon) {
		/**
		 * StringBuilder url = new StringBuilder(); url.append(baseGoogleUrl);
		 * url.append("latlng=").append(lat).append(",").append(lon).append("&key=").append(ReverseGeocodeService.apiKey);
		 * URL _url; try { _url = new URL(url.toString()); Object json =
		 * restTemplate.getForObject(_url.toURI(), Object.class);
		 * System.out.println(json); } catch (MalformedURLException |
		 * RestClientException | URISyntaxException e) { // TODO Auto-generated catch
		 * block e.printStackTrace(); }
		 * 
		 * return null;
		 **/
		GeoApiContext gtx = new GeoApiContext().setApiKey(ReverseGeocodeService.apiKey);
		try {
			GeocodingResult[] gResp = GeocodingApi.newRequest(gtx).latlng(new LatLng(lon, lat)).await();
			System.out.println(gResp[0].formattedAddress);
			int i = 0;
			while (StringUtils.isBlank(gResp[i].formattedAddress)) {
				i++;
			}
			return gResp[i].formattedAddress;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			// e.printStackTrace();

		}
		return null;

	}
}
