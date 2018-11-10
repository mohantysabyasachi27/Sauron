package com.hack.sauron.models;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexType;
import org.springframework.data.mongodb.core.index.GeoSpatialIndexed;
import org.springframework.data.mongodb.core.mapping.Document;

import com.hack.sauron.constants.SauronConstant;

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
	private String violationType;
	private String details;

	private Integer status = SauronConstant.PENDING_TICKET; // pending tickets , 0 for rejected, 1 for approved

	private String address;

	@GeoSpatialIndexed(type = GeoSpatialIndexType.GEO_2DSPHERE)
	private GeoJson location;

	public Ticket() {

	}

	public String getLink() {
		return links;
	}

	public void setLink(String link) {
		links = link;
	}

	public Boolean getIsVideo() {
		return isVideo;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
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

	public String getLinks() {
		return links;
	}

	public void setLinks(String links) {
		this.links = links;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public GeoJson buildGeoJson() {

		GeoJson geo = new GeoJson();
		geo.setType("Point");
		List<Double> list = new ArrayList<>();
		list.add(longitude);
		list.add(latitude);
		geo.setCoordinates(list);
		this.location = geo;
		return this.location;

	}

	public String getViolationType() {
		return violationType;
	}

	public void setViolationType(String violationType) {
		this.violationType = violationType;
	}

	public String getDetails() {
		return details;
	}

	public void setDetails(String details) {
		this.details = details;
	}

}
