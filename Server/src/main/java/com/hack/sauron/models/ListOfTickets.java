package com.hack.sauron.models;

import java.io.Serializable;
import java.util.List;

public class ListOfTickets implements Serializable {

	private static final long serialVersionUID = 1L;
	private List<Ticket> listTicket;
	public ListOfTickets(List<Ticket> listTicket) {
		super();
		this.listTicket = listTicket;
	}
	public List<Ticket> getListTicket() {
		return listTicket;
	}
	public void setListTicket(List<Ticket> listTicket) {
		this.listTicket = listTicket;
	}
	
	
}
