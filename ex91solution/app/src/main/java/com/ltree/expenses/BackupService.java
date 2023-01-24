package com.ltree.expenses;

import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;

import com.ltree.expenses.data.Expense;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Save the expenses into a CSV file on-device.
 */
public class BackupService extends AbstractSyncService {

    final static String TAG = BackupService.class.getSimpleName();

    public BackupService() {
        super("BackupService");
    }

    public void doExport(Expense[] expenses) {
        String fileName = resolveFileNameForExpenses(intent);
        //  pass the array of expenses to the writeExpensesToCsvFile helper method
        // You will work on this method next
        writeExpensesToCsvFile(fileName, expenses);
    }

    private void writeExpensesToCsvFile(String fileName, Expense[] expenses) {
        PrintWriter pw = null;

        //  Get the state of the external storage (remove the null!)
        // HINT: See chapter 5
        String state = Environment.getExternalStorageState();

        // Test that the state is Environment.MEDIA_MOUNTED (accessible and writable)
        // Hint: don't forget that state is a String (use equals() to compare)
        if (state.equals(Environment.MEDIA_MOUNTED)) {
            try {
                // Get the File object representing the Public Downloads area
                // Hint: use a method on Environment
                File baseDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);

                // Ensure the directories in the path are actually created
                baseDir.mkdirs();

                // Create the file name we will use to write the CSV file
                // by appending the fileName to the baseDir
                // Hint: fileName is a parameter to the method you are working in
                File fullFileName = new File(baseDir, fileName);

                Log.d(TAG, "Outputting csv to: " + fullFileName.getAbsolutePath());
                //  Create a new PrintWriter to write the file (use the fullFileName )
                pw = new PrintWriter(fullFileName);

                // Pass the expenses array to Expense.Helper.expenseArrayToCsv then
                // use the PrintWriter to write the data to the CSV file
                // Hint: you may need to convert the returned StringBuilder to a string
                pw.write(Expense.Helper.expenseArrayToCsv(expenses).toString());
            } catch (IOException e) {
                // Left here as a good example of bad error reporting.
                e.printStackTrace();
                Log.e(TAG, "Failed to save expenses in service. Details:", e);
            } finally {
                if (null != pw) {
                    // close the PrintWriter
                    pw.close();
                }
            }
        }
    }

    /**
     * Helper method to set either a default file name or use one passed in with the intent
     *
     * @param intent The intent
     * @return the file name to write to
     */
    private static String resolveFileNameForExpenses(Intent intent) {
        String fileName = Constants.DEFAULT_CSV_FILENAME; // set a default file name
        Bundle extras = intent.getExtras();
        if (null != extras) {
            String tmpFName = extras.getString(Constants.EXPENSE_EXTRA_FILENAME);
            if (null != tmpFName) {
                fileName = tmpFName;
            }
        }
        return fileName;
    }
}
