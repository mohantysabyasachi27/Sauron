package com.hack.sauron.alpr;

import com.hack.sauron.models.Ticket;

public interface AlprService {

	void getLicensePlateFromImages(Ticket ticket, String tempPath);
	
	void getLicensePlateFromVideos();
	
}
