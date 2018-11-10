package com.hack.sauron.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource("classpath:api.properties")
public class AmazonS3Config {
	
	@Value("${s3.accesskey}")
	private String accessKey;
	@Value("${s3.secret}")
	private String secret;
	@Value("${s3.bucketName}")
	private String bucketName;
	


	public String getAccessKey() {
		return accessKey;
	}
	
	public String getSecret() {
		return secret;
	}

	public String getBucketName() {
		return bucketName;
	}

	
	
	


}
