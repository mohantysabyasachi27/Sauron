package com.hack.sauron.models;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexType;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "Ticket")
public class Ticket implements Serializable {
	private static final long serialVersionUID = 1L;
	@Id
	private String ticketId;
	private String username;
	private Date date;
	private Double latitude;
	private Double longitude;
	private Boolean isVideo;
	private String links;
	private String status;

	@GeoSpatialIndexed(type = GeoSpatialIndexType.GEO_2DSPHERE)
	private GeoJsonPoint location;

	public Ticket() {
		
	}
	public Ticket(String id, String username, Date date, Double latitude, Double longitude, String isApproved,
			Boolean isVideo,String link) {
		super();
		this.ticketId = id;
		this.username = username;
		this.date = date;
		this.latitude = latitude;
		this.longitude = longitude;
		this.setStatus(isApproved);
		this.isVideo = isVideo;
		this.location = new GeoJsonPoint(longitude, latitude);
	

	}

	public String getLink() {
		return links;
	}
	
	public void setLink(String link)
	{
		links =link;
	}
	
	public Boolean getIsVideo() {
		return isVideo;
	}

	public void setIsVideo(Boolean isVideo) {
		this.isVideo = isVideo;
	}


	public String getTicketId() {
		return ticketId;
	}
	public void setTicketId(String ticketId) {
		this.ticketId = ticketId;
	}
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public Double getLatitude() {
		return latitude;
	}

	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public Double getLongitude() {
		return longitude;
	}

	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}



	public GeoJsonPoint getLocation() {
		return location;
	}

	public void setLocation(GeoJsonPoint location) {
		this.location = location;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
