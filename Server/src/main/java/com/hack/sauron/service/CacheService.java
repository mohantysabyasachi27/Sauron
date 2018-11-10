package com.hack.sauron.service;

import java.util.List;

public interface CacheService {

	void put(String key, String col, String value);

	String get(String key, String col);

	void evict(String key, List<String> col);

}
