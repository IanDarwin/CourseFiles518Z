package com.ltree.expenses;


import android.annotation.TargetApi;
import android.content.ClipData;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import androidx.cursoradapter.widget.SimpleCursorAdapter;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.ListFragment;
import androidx.loader.app.LoaderManager;
import androidx.loader.content.CursorLoader;
import androidx.loader.content.Loader;

import com.ltree.expenses.data.DAO;
import com.ltree.expenses.data.Expense;

/**
 * A simple {@link Fragment} subclass.
 */
public class ExpensesListFragment extends ListFragment implements AdapterView.OnItemLongClickListener,LoaderManager.LoaderCallbacks<Cursor> {

    @SuppressWarnings("unused")
    private static final String TAG = "ExpenseListFragment"; // Changed for the Fragment
    private SimpleCursorAdapter mAdapter;
    private Uri mBaseUri;

    private OnFragmentInteractionListener mListener;

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public ExpensesListFragment() {
        // Required empty public constructor
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        // Get the Intent associated with this Activity
        Intent intent =getActivity().getIntent();

        // Configure the list to run in single item selection mode
        getListView().setChoiceMode(ListView.CHOICE_MODE_SINGLE);

        // set baseUri to the Uri specified with the launching Intent (as data)
        mBaseUri = intent.getData();
        // If no Data was passed in the launching Intent, then default it
        // to Expense.ExpenseItem.CONTENT_URI
        if (mBaseUri == null) {
            mBaseUri =Expense.ExpenseItem.CONTENT_URI;
        }

        // Call the queryExpenses method on the DAO you just created.
        // The first parameter is an array representing the columns you wish to
        // be returned
        // Use Expense.ExpenseItem.LIST_PROJECTION for this
        // We want to return all the expenses so selection and selectionArgs can both be null
        // Comment out this query from the last exercise which used the
        // DAO directly
        //Cursor cursor = dao.queryExpenses(Expense.ExpenseItem.LIST_PROJECTION, null, null);


        // The names of the cursor columns to display in the view, initialized
        // to the description column
        // Note the creation of these two arrays specifying the columns to be
        // displayed
        // and the resource ID's to use to display them
        // android.R.id.text1 is a built in resource to show simple text
        // Note that this is the same as when we used the DAO
        String[] dataColumns = { Expense.ExpenseItem.COLUMN_NAME_DESCRIPTION } ;
        int[] viewIDs = { android.R.id.text1 };


        // Create a new SimpleCursorAdapter
        // Creates the backing adapter for the ListView.
        // Replace cursor with null
        mAdapter = new SimpleCursorAdapter(getActivity(), // The Context for the ListView
                android.R.layout.simple_list_item_single_choice,      // Points to the XML for a list item
                null,                      // The cursor to get items from
                dataColumns,						// The array of Strings holding the names of the data columns to display
                viewIDs,						// The array of resource ids used to display the data
                0
                // Add the flags parameter (0) to method call
        );

        // Initialize the LoaderManager
        LoaderManager.getInstance(this).initLoader(0, null, this);

        // Change Adapter to display your content
        setListAdapter(mAdapter);

        // Register for a context menu
        // Dn81 can't have context and drag!
        //registerForContextMenu(getListView());
        getListView().setOnItemLongClickListener(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        mListener.showMenuItemsAddAndDelete(true);

    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        try {
            mListener = (OnFragmentInteractionListener) context;
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


    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);
        editExpenseItem(position, v);

//        if (null != mListener) {
//            // Notify the active callbacks interface (the activity, if the
//            // fragment is attached to one) that an item has been selected.
//            mListener.onFragmentInteraction(DummyContent.ITEMS.get(position).id);
//        }
    }


    private void editExpenseItem(int position, View v) {

        // Call getCheckedItemIds to get an array of all the items which are currently selected
        // Note: the list was set in single item select mode in onActivityCreated()
        // so there will only be one item in the array
        long[] checkedItems = getListView().getCheckedItemIds();

        // We can display everything in-place with fragments, so update
        // the list to highlight the selected item and show the data.
        getListView().setItemChecked(position, true);

        // Check to see if we are already editing this expense item
//		if (mShownCheckPosition != mCurCheckPosition) {
        // If we are not currently showing a fragment for the new
        // position, we need to create and install a new one.
        // use the newInstance() method of ExpenseEntryFragment to create a new ExpenseEntryFragment
        // Intialised to the id of the selected item (the only element in checkedItems[]
        ExpenseEntryFragment frag = ExpenseEntryFragment
                .newInstance(checkedItems[0], mBaseUri);

        mListener.showExpenseEditFragment(frag);


//		}


    }

    @Override
    public boolean onItemLongClick(AdapterView<?> parent, View v, int position, long id) {
        Intent intent = getActivity().getIntent();

        // Note: We are creating a new URI to rperesent the Provider URI for the list item
        Uri expenseUri = ContentUris.withAppendedId(intent.getData(), id);

        if(mListener.isDragAndDropSupported()){
            // Put the expense data in the clipboard as a ContentProvider URI
            // Hint: use the static helper method on ClipData
            ClipData data = ClipData.newUri(getActivity().getContentResolver(), "Drag data", expenseUri);

            // pass the ClipData into the startDrag method
            //v.startDrag(data, new ExpenseDragShadowBuilder(v), null, 0);
            v.startDrag(data, new View.DragShadowBuilder(v), null, 0);
        }

        return true;
    }


    // Remove the block comment around the three methods
    // implementing LoaderManager.LoaderCallbacks<Cursor>
    @Override
    public Loader<Cursor> onCreateLoader(int id, Bundle args) {
        // Modify the code to return a new CursorLoader. Note the parameters
        // The first parameter is the URI for the ContentProvider which
        // The remaining parameters are the same as the ones passed into
        // dao.queryExpenses (which you just commented out earlier)
        // with the addition of a sort order parameter (ascending / descending)
        return new CursorLoader(getActivity(), mBaseUri, // Use the URI stored in the
                // Intent for this Activity
                Expense.ExpenseItem.LIST_PROJECTION, // Return the expense
                // description and
                // amount
                null, // No where clause, return all records.
                null, // No where clause, therefore no where column values.
                Expense.ExpenseItem.DEFAULT_SORT_ORDER // Use the default sort
                // order.
        );

    }

    @Override
    public void onLoadFinished(Loader<Cursor> loader, Cursor data) {
        // Modify the code to swap the cursor on the adapter
        mAdapter.swapCursor(data);
    }

    @Override
    public void onLoaderReset(Loader<Cursor> loader) {
        // Modify the code to set cursor on the adapter to null
        mAdapter.swapCursor(null);
    }

    /** Reloads the list of expenses to respond to changes in the entry view */
    public void reloadList(){

        LoaderManager.getInstance(this).restartLoader(0, null, this);
    }

    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p/>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        boolean isDragAndDropSupported();
        void showExpenseEditFragment(ExpenseEntryFragment frag);
        void showMenuItemsAddAndDelete(boolean visible);
        void reloadExpensesList();
    }
}
