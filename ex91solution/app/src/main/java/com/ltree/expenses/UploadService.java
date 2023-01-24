package com.ltree.expenses;

import android.util.Log;
import android.widget.Toast;

import com.ltree.expenses.data.Expense;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

public class UploadService extends AbstractSyncService {

    private static final String TAG = UploadService.class.getSimpleName();

    private String serverURL = "https://10.0.2.2:8443/expenses";

    public UploadService() {
        super("UploadService");
    }

    public void doExport(Expense[] expenses) {
        try {
            // Call the toJSON() method to convert the expenses array into JSON
            String jsonData = toJSON(expenses);
            // Pass the jsonData into the postToWebService method
            postToWebService(jsonData);
        } catch (JSONException e) {
            Log.e(TAG, "Failed to convert expenses to JSON", e);
        } catch (Exception e) {
            Log.e(TAG,  getString(R.string.commx_failed));
        }
    }

    /**
     * Format expenses as JSON data
     *
     * @param expenses the array of expenses to return
     * @return The expenses array in JSON format
     */
    String toJSON(Expense[] expenses) throws JSONException {

        // Use Expense.Helper.expenseArrayToJSON() to convert our expenses to a JSON array
        JSONArray jExpenses = Expense.Helper.expenseArrayToJSON(expenses);
        // Create a new JSONObject to represent the outer wrapper or root of our JSON data
        JSONObject jsonRoot = new JSONObject();
        // put the JSON expenses array into the jsonRoot as a property called expense
        jsonRoot.put("expense", jExpenses);
        // return the JSON data as a String
        return jsonRoot.toString();
    }

    /**
     * Send the converted data to the Upload web service
     *
     * @param msgBody The expenses array as a JSON body
     * @throws IOException        If the transfer goes south
     */
    public void postToWebService(String msgBody) throws IOException {
        HttpsURLConnection.setDefaultHostnameVerifier((hostname, sslSession) ->
            hostname.equals("10.0.2.2") || hostname.equals("127.0.0.1")
        );
        // *******  Set the IP address of localhost on the development machine where the service is running
        URL serviceUrl = new URL(serverURL);
        // open a new connection
        HttpURLConnection urlConnection = (HttpURLConnection) serviceUrl.openConnection();
        // set the request method to POST
        urlConnection.setRequestMethod("POST");
        // enable output on the urlConnection
        urlConnection.setDoOutput(true);
        
        // set the content type to application/json
        urlConnection.setRequestProperty("content-type", "application/json");

        try {
            // get an output stream from the URLConnection
            OutputStream output = urlConnection.getOutputStream();
            // Write the msgBody to the outputstream
            output.write(msgBody.getBytes());
            // Make the connection by requesting the response code
            int responseCode = urlConnection.getResponseCode();
            makeAndShowToast("HTTP response code from service: ", Integer.toString(responseCode));
            Log.i(TAG, "HTTP response code from service: " + responseCode);
            if (responseCode > 299) {
                makeAndShowToast("ERROR: Server response " + responseCode, "");
                Log.i(TAG, "ERROR: Server response " + responseCode);
            }
        } catch (MalformedURLException e) {
            String message = "Invalid URL! " + e;
            makeAndShowToast("Error", message);
            Log.e(TAG, message);
            throw e;
        } catch (IOException ex) {
            makeAndShowToast("Error", getString(R.string.commx_failed));
            Log.e(TAG, ex.toString());
            throw ex;
        } finally {
            // disconnect the connection to release resources
            urlConnection.disconnect();
        }
    }

	private void makeAndShowToast(String s1, String s2) {
		Toast.makeText(this, TAG + ": " + s1 + " " + s2, Toast.LENGTH_LONG).show();
	}
}
