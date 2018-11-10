package com.hack.sauron.service;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.CompletableFuture;

import org.apache.logging.log4j.LogManager;
//import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.hack.sauron.config.AmazonS3Config;
import com.hack.sauron.models.Ticket;

@Component
public class FileUploaderAsyncService 
{

	//public static Logger logger = (Logger) LogManager.getLogger(FileUploaderAsyncService.class);
	
	   @Autowired
	   private AmazonS3Config awsS3Config;
	
	@Async("fileUploader")
	public  CompletableFuture<Void> async(MultipartFile file, Ticket ticket) throws IOException {
		InputStream  stream =null;
	  	   String url = null;
	    try {
	    	 byte[] bytes = file.getBytes();
	  	   
	    	 System.out.println(awsS3Config.getAccessKey()+"AccessKey");
			   System.out.println();
			   AWSCredentials awsCreds = new BasicAWSCredentials(awsS3Config.getAccessKey(), awsS3Config.getSecret());
			   AmazonS3 amazonS3 = AmazonS3Client.builder()
					    .withRegion(Regions.US_WEST_2)
					    .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
					    .build();
			   String fileName = file.getOriginalFilename();
			  stream = new ByteArrayInputStream(bytes);
			   System.out.println(ticket.getUsername());
			   ObjectMetadata objMetData = new ObjectMetadata();
			   objMetData.setContentLength(bytes.length);
			   objMetData.setContentType("video/jpeg");
			   String key = ticket.getUsername()+"/"+ticket.getDate()+"/"+fileName;
			   Long time = System.currentTimeMillis();
			  
	           amazonS3.putObject(new PutObjectRequest(awsS3Config.getBucketName(), key, stream, objMetData).withCannedAcl(CannedAccessControlList.PublicRead));
	           System.out.println(System.currentTimeMillis()-time);
			   //amazonS3.putObject(new PutObjectRequest(awsS3Config.getBucketName(), key, stream, objMetData));
			  //url =((AmazonS3Client) AmazonS3ClientBuilder.defaultClient()).getResourceUrl(awsS3Config.getBucketName(), key);
			  // url="https://"+"s3-"+Regions.US_WEST_2+"-"+awsS3Config.getBucketName()+".s3.amazonaws.com+"+key;
	         // url =amazonS3.generatePresignedUrl(new GeneratePresignedUrlRequest(awsS3Config.getBucketName(), key, HttpMethod.PUT)).toString();
	           url = String.valueOf(amazonS3.getUrl(awsS3Config.getBucketName()	, key));
			   System.out.println(url);
			   
			  stream.close();
			  
	        
	    } catch (Throwable t) {
	    	System.out.println("error"+t.getMessage());
	       // logger.debug(t.getMessage());
	    }finally {
	    	stream.close();
	    }
		return CompletableFuture.completedFuture(null);
	   
	}

}
