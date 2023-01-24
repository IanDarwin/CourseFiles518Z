package com.ltree.expenses;

import android.app.Activity;
import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import com.ltree.expenses.data.Expense;

/**
 * Common abstract parent {@link IntentService}
 * for handling asynchronous task requests in
 * a service on a separate handler thread.
 * <p/>
 */
public abstract class AbstractSyncService extends IntentService {
	static final String TAG = AbstractSyncService.class.getSimpleName();
	public static final String NOTIFICATION_CHANNEL_EXPENSES = "ExpensesChannel";
	NotificationManager notManager;
	private static final int NOTIFICATION_ID = 1;
	Intent intent;

	public AbstractSyncService(String serviceName) {
		super(serviceName);
	}

	public abstract void doExport(Expense[] expenses);

	@Override
	public void onCreate() {
		super.onCreate();
		Log.i(TAG, "onCreate() called");
		notManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		Log.i(TAG, "Processing Started");

		this.intent = intent; // For subclass use

		// Create a notification that the service started OK
		createNotification(NOTIFICATION_ID,"Starting", getString(R.string.svc_str_started));

		Log.i(TAG, "Service Started");

		// If there is no data associated with the Intent, sets the data to the default URI, which
		// accesses a list of expenses.
		if (intent.getData() == null) {
			intent.setData(Expense.ExpenseItem.CONTENT_URI);
		}

		//  Note the expense data is being retrieved from the Content Provider as a cursor
		ContentResolver resolver = getContentResolver();
		try (Cursor cursor = resolver.query(
				intent.getData(), // Use the default content URI for the provider.
				Expense.ExpenseItem.FULL_PROJECTION, //PROJECTION,                       // Return the note ID and title for each note.
				null,                             // No where clause, return all records.
				null,                             // No where clause, therefore no where column values.
				Expense.ExpenseItem.DEFAULT_SORT_ORDER  // Use the default sort order.
			)
		) {
			//  Call the helper method in Expense.Helper which converts the cursor to an array of expenses
			// TODO 10 Note that we are converting the cursor into an array of expenses (nothing to change)
			Expense[] expenses = Expense.Helper.getExpensesFromCursor(cursor);

			doExport(expenses);

			Log.i(TAG, "Processing finished");
			cancelNotification(NOTIFICATION_ID);
		}
	}

	/**
	 * Creates a simple notification to indicate that the service has started
	 */
	void createNotification(int id, String title, String message) {
		createNotificationChannel();
		// Add an Intent to the Notification.
		// NB: Using a Dummy Activity which does nothing when selected,
		// as we don't want to re-start the (running) main activity.
		Intent notificationIntent = new Intent(this, DummyActivity.class);
		// Create the PendingIntent
		PendingIntent contentIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

		// Create a Notification
		NotificationCompat.Builder notiBuilder = new NotificationCompat.Builder(this);
		// Set the icon, ticker text and notification time
		notiBuilder.setTicker(message).setSmallIcon(R.mipmap.ic_launcher_round)
				// Instruct the notification to clear itself when clicked
				.setAutoCancel(false)
				.setChannelId(NOTIFICATION_CHANNEL_EXPENSES)
				// Specify the title, text and PendingIntent for the notification
				.setContentText(message)
				.setContentTitle(title)
				.setContentIntent(contentIntent);
		// Get the notification to use
		Notification notification = notiBuilder.build();

		// Fire the notification
		notManager.notify(id, notification);
	}

	void cancelNotification(int id) {
		notManager.cancel(id);
	}

    private void createNotificationChannel(){
        if (Build.VERSION.SDK_INT < 26) {
            return;
        }
        NotificationManager notificationManager =
                (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);
        NotificationChannel channel = new NotificationChannel(NOTIFICATION_CHANNEL_EXPENSES,
                "Expenses Channel",
                NotificationManager.IMPORTANCE_DEFAULT);
        channel.setDescription("Notifications from the Expenses app");
        notificationManager.createNotificationChannel(channel);
    }

	/**
	 * Dummy class to allow a notification to be created which does not actually do anything!
	 */
	static class DummyActivity extends Activity {
		@Override
		protected void onCreate(Bundle savedInstanceState) {
			super.onCreate(savedInstanceState);
			finish();
		}
	}
}
