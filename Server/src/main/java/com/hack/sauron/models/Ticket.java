package com.hack.sauron.models;

import java.io.Serializable;
import java.util.Date;

import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexType;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexed;

public class Ticket implements Serializable {
	private static final long serialVersionUID = 1L;
	private String id;
	private String username;
	private Date date;
	private Double latitude;
	private Double longitude;
	private Boolean isVideo;
	private String isApproved;

	@GeoSpatialIndexed(type = GeoSpatialIndexType.GEO_2DSPHERE)
	private GeoJsonPoint location;

	public Ticket(String id, String username, Date date, Double latitude, Double longitude, String isApproved,
			Boolean isVideo) {
		super();
		this.id = id;
		this.username = username;
		this.date = date;
		this.latitude = latitude;
		this.longitude = longitude;
		this.isApproved = isApproved;
		this.isVideo = isVideo;
		this.location = new GeoJsonPoint(longitude, latitude);

	}

	public Boolean getIsVideo() {
		return isVideo;
	}

	public void setIsVideo(Boolean isVideo) {
		this.isVideo = isVideo;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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

	public String getIsApproved() {
		return isApproved;
	}

	public void setIsApproved(String isApproved) {
		this.isApproved = isApproved;
	}

	public GeoJsonPoint getLocation() {
		return location;
	}

	public void setLocation(GeoJsonPoint location) {
		this.location = location;
	}

}
