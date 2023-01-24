package com.ltree.expenses;

import static android.app.Activity.RESULT_CANCELED;
import static android.app.Activity.RESULT_OK;
import static androidx.core.content.FileProvider.getUriForFile;

import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.loader.app.LoaderManager;
import androidx.loader.content.CursorLoader;
import androidx.loader.content.Loader;

import com.google.android.material.snackbar.Snackbar;
import com.ltree.expenses.data.Expense;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


/**
 * A simple {@link Fragment} subclass.
 */
public class ExpenseEntryFragment extends Fragment implements LoaderManager.LoaderCallbacks<Cursor>, DateUpdater {

    private static final String TAG = "ExpenseEntryFragment";
    public static final int CAM_REQUEST_CODE = 103;

    private TextView mDescription;
    private TextView mAmount;
    private TextView mDateText;
    private Calendar mExpenseDate; // Keep a calendar in sync with the date text for efficiency

    private File mReceiptFilePath;
    private ImageView mReceiptImg;

    private long mExpenseId; // Expense item associated with this activity
    private Uri mExpenseUri;
    private Cursor mCursor;
    private FragmentActivity mParentActivity;

    public boolean mDontPopFragment;

    protected static DateFormat dateFormatter =
            SimpleDateFormat.getDateInstance();
    private boolean flShowTrash;
    private ExpensesListFragment.OnFragmentInteractionListener mListener;

    /**
     * Create a new instance of ExpenseEntryFragment, providing "expenseId" as
     * an argument. expenseId is the id of the expense associated with this
     * fragment
     */
    // Complete the declaration of a static method called newInstance
    // The method parameter is long expenseId
    // The return type is ExpenseEntryFragment
    static ExpenseEntryFragment newInstance(long expenseId, Uri baseUri) {

        // Create a new instance of ExpenseEntryFragment
        ExpenseEntryFragment f = new ExpenseEntryFragment();

        // Supply num input as an argument.
        Bundle args = new Bundle();
        // Add the expenseId as an argument called "expenseId" to the
        // bundle
        // Note: this is the best way of passing arguments into the new Fragment
        args.putLong(Constants.EXPENSE_ID, expenseId);
        // SAve the base URI in the bundle
        args.putParcelable(Constants.BASE_URI, baseUri);
        // Call f.setArguments passing in the bundle
        f.setArguments(args);

        return f;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle args = getArguments();
        if (args != null) {
            //  get the expenseId argument and store in mExpenseId
            Uri mBaseUri = args.getParcelable(Constants.BASE_URI);
            mExpenseId = args.getLong(Constants.EXPENSE_ID);
            mExpenseUri = ContentUris.withAppendedId(mBaseUri, mExpenseId);
            mExpenseDate = Calendar.getInstance();
        }
        Log.i(TAG, "onCreate");

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.activity_expense_entry, container, false);

        Button mSaveButton = v.findViewById(R.id.expEdt_bt_save);
        mDescription = v.findViewById(R.id.expEdt_et_description);
        mAmount = v.findViewById(R.id.expEdt_et_amount);
        ImageButton mReceiptButton = v.findViewById(R.id.expEdt_ib_receipt);
        mDateText = v.findViewById(R.id.expEdt_et_date);
        mReceiptImg = v.findViewById(R.id.expEdt_im_receipt);

        // Set up references to the view items and instantiate a Calendar to hold the actual date
        mExpenseDate = Calendar.getInstance();

        mSaveButton.setOnClickListener(v1 -> {
            Log.i(TAG, "Save button clicked");
            // To save the data, just call the finish() method to close the Activity
            saveExpenseItem();
            getActivity().getSupportFragmentManager().popBackStack();
        });

        registerDatePickerHandler(v);
        // Set up the on click listener for the receipt button (use the class
        // you just created
        mReceiptButton.setOnClickListener(new ReceiptButtonListener());

        return v;
    }


    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mParentActivity = getActivity();
    }

    private void loadExpenseDataFromCursor() {
        /*
         * mCursor is initialized, since onCreate() always precedes onResume for
         * any running process. This tests that it's not null, since it should
         * always contain data.
         */
        if (mCursor != null) {
            // Re-query in case something changed while paused
            // Done 51 remove the comments
            // and then requery the cursor by moving the cursor to the first row

            if (mCursor.moveToFirst()) {
                // populate the dialog fields

                // Done 52 Note how the view elements are populated from the cursor content
                mDescription.setText(mCursor.getString(0));
                mAmount.setText(mCursor.getString(1));

                /* The next section fetches the date as a string from the database and
                 * then converts to a GregorianCalendar to populate the DatePicker
                 */
                try {
                    // Convert the stored date to Calendar
                    // Done 53 Add the code to retrieve the data from the cursor
                    // The date is stored as a String and it's column index is 2
                    long lDate = Long.parseLong(mCursor.getString(2));
                    // Update the mExpenseDate calendar with the new date value
                    mExpenseDate.setTimeInMillis(lDate);
                    // Done 54 Note how we update the date text to reflect the stored date
                    mDateText.setText(dateFormatter.format(mExpenseDate.getTime()));
                } catch (NumberFormatException e) {
                    Log.i(TAG, "Date not loaded");
                }
            }
        }
    }


    private void registerDatePickerHandler(View layout) {
        View v1 = layout.findViewById(R.id.expEdt_et_date);
        v1.setOnClickListener(v -> {
            DatePickerFragment newFragment = new DatePickerFragment();
            Bundle args = new Bundle();
            args.putSerializable(DatePickerFragment.INPUT_DATE_MS, mExpenseDate);
            newFragment.setArguments(args);
            newFragment.show(getActivity().getSupportFragmentManager(), "datePicker");
        });
    }

    @Override
    public void onPause() {
        super.onPause();
        Log.i(TAG, "onPause");

        // call the local helper method saveExpenseItem()
        saveExpenseItem();
        View trash = getActivity().findViewById(R.id.main_iv_trash);
        if (null != trash) {
            trash.setVisibility(View.VISIBLE);
        }

    }


    @Override
    public void onResume() {
        super.onResume();
        Log.i(TAG, "onResume");

        View trash = getActivity().findViewById(R.id.main_iv_trash);
        if (null != trash) {
            if (flShowTrash) {
                trash.setVisibility(View.VISIBLE);
            } else {
                trash.setVisibility(View.INVISIBLE);
            }
        }

        // If loading an existing expense, load a cursor from the provided URI
        if (Constants.EXPENSE_ITEM_UNDEFINED != mExpenseId) {
            // Done 41 Initialise the Loader
            LoaderManager.getInstance(this).initLoader(0, null, this);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        // Check the resultCode is OK and
        // correlate the requestCode
        if (requestCode == CAM_REQUEST_CODE) {

            if (resultCode == RESULT_OK) {
                //use imageUri here to access the image
                // Process result
                Drawable camImage = BitmapDrawable.createFromPath(getReceiptFilePath().getAbsolutePath());

                mReceiptImg.setImageDrawable(camImage);

            } else if (resultCode == RESULT_CANCELED) {
                Snackbar.make(getView().findViewById(R.id.expEdt_layout), "Picture was not taken  - cancelled",
                        Snackbar.LENGTH_LONG)
                        .show();

            } else {

                Snackbar.make(getView().findViewById(R.id.expEdt_layout), "Picture was not taken ",
                        Snackbar.LENGTH_LONG)
                        .show();
            }
        } else {
            super.onActivityResult(requestCode, resultCode, intent);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        try {
            mListener = (ExpensesListFragment.OnFragmentInteractionListener) context;
        } catch (ClassCastException e) {
            throw new ClassCastException(context
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    private void saveExpenseItem() {

        if (Constants.EXPENSE_ITEM_UNDEFINED == mExpenseId) {
            // As the expenseItem was set to -1, create a new expense item
            // Insert a new (empty) expense item into the database (Hint: the
            // Uri for the ContentProvider is in the Intent)
            mExpenseUri = getActivity().getContentResolver().insert(
                    getActivity().getIntent().getData(), null);
            // Get the id of the new expense from the uri returned
            mExpenseId = ContentUris.parseId(mExpenseUri);

        }

        ContentValues values = new ContentValues();

        // Adds map entries for the user-controlled fields in the map
        // Note that we are not checking the field content here but the provider
        // code does do the checking
        // Get the date as a String representing mS value

        values.put(Expense.ExpenseItem.COLUMN_NAME_EXPENSE_DATE, mExpenseDate.getTimeInMillis() + "");

        values.put(Expense.ExpenseItem.COLUMN_NAME_AMOUNT, mAmount.getText()
                .toString());

        // Done 71 create a new element in the values object with a key of Expense.ExpenseItem.COLUMN_NAME_DESCRIPTION
        // and the value from the mDescription view element (see the lines above for a template)
        values.put(Expense.ExpenseItem.COLUMN_NAME_DESCRIPTION, mDescription.getText().toString());


        // Done 73 Call the update method on the ContentResolver to update the data with the
        // modified form elements (use null as the where clause parameters)
        // Important: use the provider URL stored mExpenseUri as it represents the
        // expense item associated with this Activity instance
        // Use null for the where clause and selection arguments
        mParentActivity.getContentResolver().update(mExpenseUri, values, null, null);
        // Dispose of this fragment
//        if (!mDontPopFragment) {
//            getActivity().getSupportFragmentManager().popBackStack();
//        }
        mListener.reloadExpensesList();
    }

    @Override
    public Loader<Cursor> onCreateLoader(int id, Bundle args) {
        // Done 45 modify the code to return a new CursorLoader. Note the parameters
        // The first parameter is the URI for the ContentProvider which is stored in member field mBaseUri"
        // The remaining parameters are the same as the ones passed into dao.queryExpenses (which you just commented out earlier)
        // with the addition of a sort order parameter (ascending / descending)
        return new CursorLoader(mParentActivity,
                mExpenseUri,                // Use the URI stored in the Intent for this Activity
                Expense.ExpenseItem.FULL_PROJECTION,    // Return the expense description and amount
                null,                                    // No where clause, return all records.
                null,                                    // No where clause, therefore no where column values.
                Expense.ExpenseItem.DEFAULT_SORT_ORDER  // Use the default sort order.
        );

    }


    @Override
    public void onLoadFinished(Loader<Cursor> loader, Cursor data) {

        mCursor = data;
        // Done 47 Call loadExpenseDataFromCursor();
        loadExpenseDataFromCursor();

    }

    @Override
    public void onLoaderReset(Loader<Cursor> loader) {

        mCursor = null;

    }

    @Override
    public void updateDate(Calendar date) {
        mDateText.setText(dateFormatter.format(new Date(date.getTimeInMillis())));
        mExpenseDate = date;
    }

    public void showTrash(boolean showTrash) {
        flShowTrash = showTrash;

    }

    //  Declare a class called ReceiptButtonListener which implements View.OnClickListener
    public class ReceiptButtonListener implements View.OnClickListener {


        //  Implement the onClick method
        @Override
        public void onClick(View v) {

            // Create an explicit Intent to start the Camera app (MediaStore.ACTION_IMAGE_CAPTURE)
            Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

            // Set up receiptFile to specify where the image should be stored
            // Need to pass in the ID of the expenseItem so we can
            // create the file name here.
            // Get the File object representing the External Public Pictures area
            // Hint: use a static method on Environment we discussed in Chapter 5
            // Hint2: Environment defines a constant to specify the location of the PICTURES directory
            File baseDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);

            // append the "receipts" path to the directory
            // Hint: you are just creating a sub-directory called receipts
            File receiptsDir = new File(baseDir, "receipts");

            // Create the directories if they do not yet exist
            if (!receiptsDir.exists()) {
                //  Create the directories if they do not yet exist
                // Embed the creation in the if test so a failure gets logged
                // Hint: you need the method on File which makes all the required directories
                if (!receiptsDir.mkdirs()) {
                    Log.e(TAG, "Failed to create directory to save receipts");
                    return;  // There is no point continuing if we can't save the file
                }
            }
            //  add the Id of the current expense into the file name
            // Hint: mExpenseId
            mReceiptFilePath = new File(receiptsDir, "receipt" + mExpenseId + ".jpg");
            if(mReceiptFilePath.exists()) {
                // Delete the current file if it exists
                mReceiptFilePath.delete();
            }
            Log.i(TAG, "Capturing recipt and storing in : " + mReceiptFilePath.getAbsolutePath());
            // Now convert the fileName into a Provider URI so it can be written to.
            // Convert the file path to a FileProvider URI using getUriForFile
            // The authority is "com.ltree.fileprovider"
            Uri uri = getUriForFile(getActivity(), "com.ltree.fileprovider", mReceiptFilePath);

            // Put the uri of the file into the Intent as Extra data with a name of MediaStore.EXTRA_OUTPUT
            intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);

            // Put the Extra data MediaStore.EXTRA_VIDEO_QUALITY as 1 (high quality)
            intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1);

            mDontPopFragment = true;// Prevent the fragment being closed when the pause method is called.
            // Use the Intent you created to start the Activity using startActivityForResult
            // Set the resultCode to be CAM_REQUEST_CODE
            // Note: starting the Activity using startActivityForResult will cause the onActivityResult
            // method below to be called on completion of the sub-activity
            startActivityForResult(intent, CAM_REQUEST_CODE);
        }



    }

    public File getReceiptFilePath() {
        return mReceiptFilePath;
    }
}
