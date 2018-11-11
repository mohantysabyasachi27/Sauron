package com.hack.sauron.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


import com.hack.sauron.config.CategoryConfig;
import com.hack.sauron.models.Category;


@RestController
@RequestMapping("/category")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class CategoryController {
	
	@Autowired
	CategoryConfig categoryConfig;

	@RequestMapping(method=RequestMethod.GET)
	public List<Category> getCategoryList()
	{
		List<Category>  listCategory = new ArrayList<>();
		
		Map<Integer,String> mapCategory = categoryConfig.getCategoryData();
		Map<Integer,Double> mapPoints = categoryConfig.getPointsData();
		
		for(java.util.Map.Entry<Integer, String> entry:mapCategory.entrySet())
		{
			listCategory.add(new Category(entry.getValue(), entry.getKey(), mapPoints.get(entry.getKey())));
		}
		
		return listCategory;
		
	}

}
