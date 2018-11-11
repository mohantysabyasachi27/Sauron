package com.hack.sauron.alpr;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Base64;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.json.simple.parser.ParseException;

import com.hack.sauron.models.Ticket;

public class AlprServiceImpl implements AlprService {

	private final static String secret_key = "sk_d832878b988d80b5dcda7306";
	private final static String publish_key = "pk_c517c0a5223b7a51c688dacb";

	private Path download(String sourceURL) throws IOException {
		String targetDirectory = "C:\\Users\\kumar\\Documents\\My Adobe Captivate Projects\\" + sourceURL.substring(sourceURL.lastIndexOf('/'));
		URL url = new URL(sourceURL);
		String fileName = sourceURL.substring(sourceURL.lastIndexOf('/') + 1, sourceURL.length());
		Path targetPath = new File(targetDirectory).toPath();
		Files.copy(url.openStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
		return targetPath;
	}

	@Override
	public void getLicensePlateFromImages(Ticket ticket, String tempPath) {
		try {

			Path path = download(ticket.getLink());
			byte[] data = Files.readAllBytes(path);
			byte[] encoded = Base64.getEncoder().encode(data);

			URL url = new URL("https://api.openalpr.com/v2/recognize_bytes?recognize_vehicle=1&country=us&secret_key="
					+ secret_key);
			URLConnection con = url.openConnection();
			HttpURLConnection http = (HttpURLConnection) con;
			http.setRequestMethod("POST"); // PUT is another valid option
			http.setFixedLengthStreamingMode(encoded.length);
			http.setDoOutput(true);
			try (OutputStream os = http.getOutputStream()) {
				os.write(encoded);
			}

			int status_code = http.getResponseCode();
			if (status_code == 200) {
				BufferedReader in = new BufferedReader(new InputStreamReader(http.getInputStream()));
				String json_content = "";
				String inputLine;
				while ((inputLine = in.readLine()) != null)
					json_content += inputLine;
				in.close();

				JsonParser parser = new JsonParser();
				try {
					JsonObject jsonResult = (JsonObject) parser.parse(json_content);
					JsonObject objJson = null;
					System.out.println("Got Json");
					JsonArray resultarr =null;
					if (jsonResult.has("results")) {
						System.out.println("Has results");
						resultarr = jsonResult.getAsJsonArray("results");
						objJson = (JsonObject) resultarr.get(0);
						ticket.setLicense(String.valueOf(objJson.get("plate")));
					}

					
			
					System.out.println(ticket.getLicense());

				} catch (Exception e) {
					System.out.println(e.getMessage());
					//e.printStackTrace();
				}

				System.out.println(ticket);
			} else {
				System.out.println("Got non-200 response: " + status_code);
			}

		} catch (MalformedURLException e) {
			System.out.println("Bad URL");
		} catch (IOException e) {
			System.out.println("Failed to open connection");
		}
	}

	@Override
	public void getLicensePlateFromVideos() {

	}
}