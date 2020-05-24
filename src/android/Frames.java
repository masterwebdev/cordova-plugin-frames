/**
*/
package com.autovitalsinc.frames;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.UUID;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.text.TextUtils;
import android.util.Log;

public class Frames extends CordovaPlugin {
	private static final String TAG = "Frames";
	
	private CallbackContext cbContext;
	
	private String path;
	private ArrayList<Integer> times;
	private Integer time;
	private String results[];

	public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
		
		cbContext=callbackContext;
		
		path = args.getString(0);
		
		System.out.println("PATH:"+path);
		
		JSONArray time = args.getJSONArray(1);
		
		times=new ArrayList<Integer>();

        for(int i = 0; i < time.length(); i++){
        	System.out.println("JSON OUTPUT->"+time.getInt(i));
        	times.add(time.getInt(i));
        }
		
		if(action.equals("getframe")) {
			
			getframe();
			
		}
			
		
		return true;
	}

	private void getframe() {
	    if (times != null && times.size() >= 0) {
	    	
	    	// new Thread() {
		    //	  public void run() {
	    	
	    	try{
	    	MediaMetadataRetriever retriever = new MediaMetadataRetriever();
	    	
	    	retriever.setDataSource(path);

	    	FileOutputStream outStream = null;
	        
	    	String[] results = new String[times.size()];
	    	
	    	for(int i = 0; i < times.size(); i++){
	    		
		        Bitmap bitmap = retriever.getFrameAtTime(times.get(i)*1000,MediaMetadataRetriever.OPTION_CLOSEST);

		        bitmap=resize(bitmap, 133, 100);
	        
	        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

		        bitmap.compress(Bitmap.CompressFormat.JPEG, 85, byteArrayOutputStream);

		        byte[] data = byteArrayOutputStream.toByteArray();

		        //String encoded = Base64.encodeToString(byteArray, Base64.DEFAULT);
	    	
		        String fname = "frame_"+(UUID.randomUUID().toString().replace("-", ""))+"_"+System.currentTimeMillis() + ".jpg";

				String outpath=String.format(this.cordova.getActivity().getApplicationContext().getExternalFilesDir(null)+"/%s" , fname);

		        outStream = new FileOutputStream(outpath);

		        outStream.write(data);

		        outStream.close();

		        results[i]=outpath;

	    	}
	    	
	    	Log.e(TAG,TextUtils.join("|", results));

	    	
	        cbContext.success(TextUtils.join("|", results));
	        Log.e(TAG,path);
	    	}catch(Exception e){
	    		this.cbContext.error("Error getting frame");
	    	}
	        
		  //  	  }
		  //    }.start();
	    } else {
	        this.cbContext.error("Expected frame time.");
	    }
	}
	
	private static Bitmap resize(Bitmap image, int maxWidth, int maxHeight) {
	    if (maxHeight > 0 && maxWidth > 0) {
	        int width = image.getWidth();
	        int height = image.getHeight();
	        float ratioBitmap = (float) width / (float) height;
	        float ratioMax = (float) maxWidth / (float) maxHeight;

	        int finalWidth = maxWidth;
	        int finalHeight = maxHeight;
	        if (ratioMax > 1) {
	            finalWidth = (int) ((float)maxHeight * ratioBitmap);
	        } else {
	            finalHeight = (int) ((float)maxWidth / ratioBitmap);
	        }
	        image = Bitmap.createScaledBitmap(image, finalWidth, finalHeight, true);
	        return image;
	    } else {
	        return image;
	    }
	}
}