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
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.hack.sauron.models.Ticket;

public class AlprServiceImpl implements AlprService {

	private final static String secret_key = "sk_d832878b988d80b5dcda7306";
	private final static String publish_key = "pk_c517c0a5223b7a51c688dacb";

	private Path download(String sourceURL) throws IOException {
		String targetDirectory = "/tmp/" + sourceURL.substring(sourceURL.lastIndexOf('/'));
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

				JSONParser parser = new JSONParser();
				try {
					JSONObject json = (JSONObject) parser.parse(json_content);
					JSONObject objJson = null;
					if (json.has("results")) {
						JSONArray resultarr = json.getJSONArray("results");
						objJson = (JSONObject) resultarr.get(0);
						ticket.setLicense(objJson.getString("plate"));
					}

					if (json.has("make_model")) {

						JSONArray resultarr = json.getJSONArray("make_model");
						objJson = (JSONObject) resultarr.get(0);
						ticket.setMakeModel(objJson.getString("plate"));

					}

				} catch (ParseException | JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
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