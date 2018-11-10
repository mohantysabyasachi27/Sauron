package com.hack.sauron.models;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import com.hack.sauron.constants.SauronConstant;

@Document(collection = "UserDetails")
public class User implements Serializable{

	private static final long serialVersionUID = 1L;
	@Id
	private String id;
	private String firstName;
	private String lastName;
	private Set<Role> roles = new HashSet<>();
	private String userName;
	private String password;
	@Indexed(name = "emailId_index", unique=true)
	private String emailId;
	private String mobile;
	private String address;

	public User(User user) {
		super();
		this.firstName = user.getFirstName();
		this.lastName = user.getLastName();
		this.userName = user.getEmailId();
		this.password = user.getPassword();
		this.emailId = user.getEmailId();
		this.mobile = user.getMobile();
		this.address = user.getAddress();
		this.roles.add(new Role(SauronConstant.DEFAULT_ROLE_ID, userName));
	}

	public User(String firstName, String lastName, String userName, String userPassword, String userEmailId,
			String userContactNo, Date userDOB, String userCity, String userAddress, String userPinCode) {
		super();
		this.roles.add(new Role(SauronConstant.DEFAULT_ROLE_ID, userName));
		this.firstName = firstName;
		this.lastName = lastName;
		this.userName = userEmailId;
		this.password = userPassword;
		this.emailId = userEmailId;
		this.mobile = userContactNo;
		this.address = userAddress;
	}

	public User() {

	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public Set<Role> getRoles() {
		return roles;
	}

	public void setRoles(Set<Role> roles) {
		this.roles = roles;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmailId() {
		return emailId;
	}

	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", firstName=" + firstName + ", lastName=" + lastName + ", roles=" + roles
				+ ", userName=" + userName + ", password=" + password + ", emailId=" + emailId + ", mobile=" + mobile
				+ ", address=" + address + "]";
	}

}
