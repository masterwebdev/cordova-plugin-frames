/**
*/
package com.autovitalsinc.frames;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import java.util.Date;

public class Frames extends CordovaPlugin {
	private static final String TAG = "Frames";
	
	private CallbackContext cbContext;

	public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
		
		this.cbContext=callbackContext;
		
		String path = args.getString(0);
		String time = args.getString(0);
		
		if(action.equals("getframe")) {
			
			
			
		}
		return true;
	}

	private void getframe(String message) {
	    if (message != null && message.length() > 0) {
	        this.cbContext.success(message);
	    } else {
	        this.cbContext.error("Expected one non-empty string argument.");
	    }
	}
}