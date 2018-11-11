package com.hack.sauron.models;

import java.io.Serializable;

public class Category implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8912989812L;
	private String categoryTitle;
	private int categoryId;
	private Double points;
	public Category(String categoryTitle, int categoryId, Double points) {
		super();
		this.categoryTitle = categoryTitle;
		this.categoryId = categoryId;
		this.points = points;
	}
	public String getCategoryTitle() {
		return categoryTitle;
	}
	public void setCategoryTitle(String categoryTitle) {
		this.categoryTitle = categoryTitle;
	}
	public int getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}
	public Double getPoints() {
		return points;
	}
	public void setPoints(Double points) {
		this.points = points;
	}
	
	
}
