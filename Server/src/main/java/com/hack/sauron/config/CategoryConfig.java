package com.hack.sauron.config;

import java.lang.*;
import java.util.HashMap;
import java.util.Map;

import org.springframework.context.annotation.Configuration;

@Configuration
public class CategoryConfig {

	private Map<Integer,String> categoryData;
	private Map<Integer,Double> pointsData;
	public CategoryConfig() {
		super();
		this.categoryData = new HashMap<>();
		this.pointsData = new HashMap<>();
		
		categoryData.put(1, "Wrong Parking");
		categoryData.put(2, "Lane Indiscipline");
		categoryData.put(3, "Reckless Driving");
		categoryData.put(4	, "Assault with a vehichle");
		categoryData.put(5, "Disregarding Traffic Signals");
		
		pointsData.put(1, 5.0);
		pointsData.put(2, 10.0);
		pointsData.put(3, 15.0);
		pointsData.put(4, 35.0);
		pointsData.put(5, 25.0);
		
	}
	public Map<Integer, String> getCategoryData() {
		return categoryData;
	}
	public void setCategoryData(Map<Integer, String> categoryData) {
		this.categoryData = categoryData;
	}
	public Map<Integer, Double> getPointsData() {
		return pointsData;
	}
	public void setPointsData(Map<Integer, Double> pointsData) {
		this.pointsData = pointsData;
	}
	
	
}
