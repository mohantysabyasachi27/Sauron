package com.hack.sauron.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.AmazonServiceException;
import com.hack.sauron.models.Ticket;

@Service
public class RegisterTicketService {

	@Autowired
	private FileUploaderAsyncService fileUploaderAsyncService;

	public int registerTicket(MultipartFile file, Ticket ticket) throws IOException {

		try {
			fileUploaderAsyncService.async(file, ticket);

		} catch (AmazonServiceException ase) {

			ase.printStackTrace();
		}

		return 200;
	}

	public String getDate(Date date) {

		String strDate = new SimpleDateFormat("yyyy/MM/DD HH:mm:ss").format(date);

		System.out.println(strDate.substring(0, 10));
		return strDate;
	}
}
