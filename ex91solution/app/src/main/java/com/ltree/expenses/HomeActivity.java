package com.ltree.expenses;

import static com.ltree.expenses.Constants.REQUEST_PERMISSIONS;

import android.annotation.TargetApi;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ContentUris;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.DragEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;
import androidx.fragment.app.ListFragment;

import io.flutter.embedding.android.FlutterActivity;

import com.google.android.material.snackbar.Snackbar;
import com.ltree.expenses.data.Expense;

public class HomeActivity extends AppCompatActivity implements ExpensesListFragment.OnFragmentInteractionListener {

    private static final String TAG="HomeActivity";
    private ExpenseEntryFragment mCurrentExpenseEditfrag;
    private ExpensesListFragment mListFrag;
    boolean flShowTrash;
    private Menu mOptionMenu;
	private SharedPreferences prefs;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Check for login pin req'd to use app
        prefs = getSharedPreferences("com.ltree.expenses_preferences", 0);
        if (pinRequired()) {
            String pin = prefs.getString(getString(R.string.key_pin_value), null);
            if (pin == null || pin.isEmpty()) {
                String message = getString(R.string.pin_required_not_set);
                Log.e(TAG, message);
                AlertDialog dlg = new AlertDialog.Builder(this)
                        .setTitle(R.string.pin_required_not_set)
                        .setMessage(R.string.pin_required_not_set)
                        .setPositiveButton("OK", (x,y) -> System.exit(1))
                        .create();
                        dlg.show();
                // What should we do here anyway? Allow the user in?
                // Or force them to root, if it's a real device?
                // Hint: there's a way to avoid this situation.
            } else {
                AlertDialog dlg = new AlertDialog.Builder(this)
                        .setTitle(R.string.pin_login_required)
                        .setView(R.layout.login_dialog)
                        .setPositiveButton(R.string.pin_dialog_OK, (dialog, which) -> {
                            Log.i(TAG, String.format("OK pressed, dialog=%s, which=%d", dialog, which));
                            EditText editText = ((Dialog) dialog).findViewById(R.id.pin_entry);
                            String ans = editText.getText().toString();
                            if (ans.isEmpty() || !ans.equals(pin)) {
                                System.exit(1);
                            }
                        })
                        .setNegativeButton(R.string.pin_dialog_CNX,
                                (dialog, which) -> System.exit(1)).create();
                dlg.show();
            }
        }

        new PermissionsManager(this).requestPermissionsIfNeeded();

        setContentView(R.layout.activity_home);
        ImageView mTrash = findViewById(R.id.main_iv_trash);

        showIconInActionBarv5();

        if (isDragAndDropSupported() && (mTrash != null)){
            // 	Set the OnDragListener for mTrash to be TrashDragEventListener()
            mTrash.setOnDragListener(new TrashDragEventListener());
        }

        // Gets the intent that started this Activity.
        Intent intent = getIntent();

        // If there is no data associated with the Intent, sets the data to the default URI, which
        // accesses a list of notes.
        if (intent.getData() == null) {
            intent.setData(Expense.ExpenseItem.CONTENT_URI);
        }

        // Dynamically create the list fragment. To prevent the dreaded crash when mixing dynamic and static fragments
        // Happens during screen rotation

        mListFrag = new ExpensesListFragment();
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        ft.replace(R.id.frag_expenses_list, mListFrag  );
        ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN);
        ft.commit();
    }
	
	boolean pinRequired() {
		return prefs.getBoolean(getString(R.string.key_pin_required), false);
	}

    /**
     * Seems to be required to get the icon to show in the actionbar on lollipop!
     */
    private void showIconInActionBarv5() {
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            getSupportActionBar().setDisplayShowHomeEnabled(true);
            getSupportActionBar().setLogo(R.mipmap.ic_launcher);
            getSupportActionBar().setDisplayUseLogoEnabled(true);
        } else {
            Log.w(TAG, "Failed to get the support action bar");
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu, menu);
        mOptionMenu = menu; // Take a local copy of the reference to the menu so we can easily enable / disable options
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        switch (id) {
            case R.id.menu_upload:
                startUpload();
                return true;
            case R.id.menu_add:
                addExpenseItem();
                return true;
            case R.id.menu_delete:
                deleteExpenseItem();
                return true;
            case R.id.menu_help:
                //T Invoke the Flutter Action here, using standard Android startActivity()
                //R Toast.makeText(this, "Help not implemented, sorry", Toast.LENGTH_LONG).show();
		        //-
                startActivity(FlutterActivity.createDefaultIntent(this));
		        //+
                return true;
            case R.id.menu_export:
                startExport();
                return true;
            case R.id.menu_settings:
                showSettings();
                return true;
            default:
                return super.onOptionsItemSelected(item);	// Same as the default action
        }
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        // Invoked each time the menu is prepared
        // Note that in API VERSION_CODES.HONEYCOMB and above, invalidateOptionsMenu()
        // must be called to cause this event to make this event occur
        // Check if a list item is selected

        ExpensesListFragment listFrag = getExpensesListFragment();

        if (null != listFrag) {
            // listFrag should never be null but stay defensive
            // Get a reference to the delete menu option
            MenuItem delMenuItem = menu.findItem(R.id.menu_delete);
            long[] checkedItems = listFrag.getListView().getCheckedItemIds();
            delMenuItem.setVisible(null != checkedItems && checkedItems.length > 0);
        }
        return super.onPrepareOptionsMenu(menu);
    }

    private void startUpload() {
        Snackbar.make(findViewById(R.id.frag_expenses_list), "Sending Expenses to HR Dept",
                Snackbar.LENGTH_LONG)
                .show();

        Intent startServiceIntent = new Intent(this, UploadService.class);
        startService(startServiceIntent);
    }

    private void startExport() {
        Snackbar.make(findViewById(R.id.frag_expenses_list), "Backing Up Expenses Locally",
                Snackbar.LENGTH_LONG)
                .show();

        // DONE 21 Create an Intent with BackupService as the target
        Intent startServiceIntent = new Intent(this, BackupService.class);

        // DONE 22 Use the Intent to start the service
        startService(startServiceIntent);
    }

    private void showSettings() {
        Intent settingsIntent = new Intent(this, SettingsActivity.class);
        startActivity(settingsIntent);
    }

    /**
     * Should be the only way the UI can trigger an expense being added
     */
    private void addExpenseItem() {
        // Clear any existing selections from the list
        ListFragment listFrag = getExpensesListFragment();
        int checkedItem = listFrag.getListView().getCheckedItemPosition();
        listFrag.getListView().setItemChecked(checkedItem, false);

        // Create a new fragment with an ID of Constants.EXPENSE_ITEM_UNDEFINED to flag it as new
        ExpenseEntryFragment frag = ExpenseEntryFragment.newInstance(Constants.EXPENSE_ITEM_UNDEFINED, getIntent().getData());
        showExpenseEditFragment(frag);

    }

    /**
     * Display the expense entry fragment.
     * <p>Determines if the R.id.frag_expense_details place holder is visible. If so, replaces it.
     * If the place-holder is not visible, it will load the fragment over the top of the frag_expense_list.
     * This allows different layouts to enable / disable the display of the two fragments along side each other

     * @param frag The ExpenseEntryFragment
     */
    public void showExpenseEditFragment(ExpenseEntryFragment frag) {
        // Vital to get the FragmentTransaction this way. Any other technique will fail
        // when running with the support library
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

        // Find out if the R.id.frag_expense_details is visible.
        //		Yes then replace that with the edit screen
        //		No then replace the list fragment
        ViewGroup containingView = findViewById(R.id.frag_expense_details);

        if(containingView.getVisibility() != View.GONE){
            flShowTrash = true; // Make sure we do show the trash can if in multiple fragment mode
            // Display the edit fragment alongside the list
            ft.add(R.id.frag_expense_details, frag, Constants.EXPENSE_FRAG_TAG );
            // Force an update of the options menu so the delete button is enabled (if appropriate)
            invalidateOptionsMenu();
        } else {
            flShowTrash = false; // Make sure we do not show the trash can if in single fragment mode
            // Display the edit fragment instead of the list
            // Must disable the Add button on the action bar

            ft.replace(R.id.frag_expenses_list, frag, Constants.EXPENSE_FRAG_TAG);
            showMenuItemsAddAndDelete(false);

        }
        frag.showTrash(flShowTrash);
        ft.addToBackStack("details");	// Name is just a label for the transaction on the stack
        ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN);

        ft.commit();
        mCurrentExpenseEditfrag = frag;
    }

    public void showMenuItemsAddAndDelete(boolean visible){
        if (mOptionMenu != null){
            invalidateOptionsMenu();
            MenuItem menuItem = mOptionMenu.findItem(R.id.menu_add);
            menuItem.setVisible(visible);
            menuItem = mOptionMenu.findItem(R.id.menu_delete);
            menuItem.setVisible(visible);
        }
    }

    private void  showTrash() {
        View trash = findViewById(R.id.main_iv_trash);
        if (null != trash) {
            if (flShowTrash) {
                trash.setVisibility(View.VISIBLE);
            } else {
                trash.setVisibility(View.INVISIBLE);
            }
        }
    }

    /**
     * Test if we are on a version which support Drag and Drop
     * e.g. post Honeycomb
     * BTW, we can probably no longer build for Honeycomb or earlier.
     * @return true if d&d is supported
     */
    public boolean isDragAndDropSupported() {
        return android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.HONEYCOMB;
    }

    /**
     * Force the options menu to be reloaded
     * Test if we are on a version which auto-invalidates the options menu
     * From Honeycomb on, this was changed (for the ActionBar) so that the app
     * must call invalidateOptionsMenu
     * If the version is pre-honeycomb, do nothing
     */
    public void invalidateOptionsMenu()
    {
        if( android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.HONEYCOMB){
            super.invalidateOptionsMenu();
        }
        // Older versions do auto-invalidate the options menu
    }

    /** Method to delete the current expense item */
    private void deleteExpenseItem() {
        ExpensesListFragment listFrag = getExpensesListFragment();
        if (null != listFrag){
            long[] checkedItems = listFrag.getListView().getCheckedItemIds();
            Uri expenseUri = ContentUris.withAppendedId(getIntent().getData(), checkedItems[0]);
            getContentResolver().delete(expenseUri, null, null);
            Toast.makeText(this, R.string.toast_str_item_deleted, Toast.LENGTH_LONG).show();
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.remove(mCurrentExpenseEditfrag);
            ft.commit();
        } else {
            Log.e(TAG, "Tried to delete an expense but could not locate the list");
        }
    }

    /**
     * The listener class to handle drag and drop events
     * @author mjrw
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB) // Only works in Honeycomb and above
    protected class TrashDragEventListener implements View.OnDragListener {

        // This is the method that the system calls when it dispatches a drag event to the
        // listener.
        public boolean onDrag(View v, DragEvent event) {
            ImageView theView = (ImageView)v;
            Log.i(TAG, "onDrag for trash: " + event.getAction() + "ID=" + v.getId());
            switch (event.getAction()) {
                // 31 complete and un-comment the case for drag STARTED

                case DragEvent.ACTION_DRAG_STARTED:
                    //  32 When the drag starts, change the trash icon to R.drawable.trash_can_ready
                    theView.setImageResource(R.drawable.trash_can_ready);
                    return true;

                case DragEvent.ACTION_DRAG_ENTERED:
                    // Item dragged over our potential target
                    //  33 When the drag moves over the trash can change the BACKGROUND color to Color.GREEN
                    theView.setBackgroundColor(Color.GREEN);
                    return true;

                case DragEvent.ACTION_DRAG_ENDED:
                    // The drag finally finishes
                    //  34 reset the image resource ID to R.drawable.trash_can
                    theView.setImageResource(R.drawable.trash_can);
                    return true;

                case DragEvent.ACTION_DRAG_EXITED:
                    //Drag exits or ends
                    Log.i(TAG, "Clearing background color");
                    //  35 set the background color to TRANSPARENT
                    theView.setBackgroundColor(Color.TRANSPARENT);
                    return true;

                case DragEvent.ACTION_DROP:
                    //  36 set the background color to RED to indicate the drop has happened
                    theView.setBackgroundColor(Color.RED);
                    ClipData data = event.getClipData();
                    ClipData.Item item = data.getItemAt(0);
                    Uri cpUri = item.getUri();
                    getContentResolver().delete(cpUri, null, null);
                    // Remove the current edit expense frag. It's probably the one being dragged
                    if(null != mCurrentExpenseEditfrag){
                        // In Portrait mode there will not be a currentExpenseEdit frag so don't try and remove
                        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
                        ft.remove(mCurrentExpenseEditfrag);
                        ft.commit();
                    }
                    theView.setBackgroundColor(Color.TRANSPARENT);
                    return true;

            }
            return false;
        }
    }

    /**
     * Returns a reference to the expenses list fragment
     * @return a reference to the expenses list fragment or null if it can not be located
     */
    private ExpensesListFragment getExpensesListFragment() {
        ExpensesListFragment listFrag = null;
        Fragment frag = getSupportFragmentManager().findFragmentById(R.id.frag_expenses_list);
        if (frag instanceof ExpensesListFragment){
            listFrag = (ExpensesListFragment)frag;
        }
        return listFrag;
    }

    public void onRequestPermissionsResult(int requestCode,
        String[] permissions,
        int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_PERMISSIONS) {
            if (grantResults.length == 1
                    && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "Permission granted", Toast.LENGTH_LONG).show();
            }
            // else permission was denied or request was cancelled
        }
    }

    @Override
    public void reloadExpensesList() {
        mListFrag.reloadList();
    }

}
