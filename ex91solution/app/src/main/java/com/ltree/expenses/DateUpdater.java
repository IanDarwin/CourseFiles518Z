package com.ltree.expenses;

import java.util.Calendar;

/**
 * Interface which must be implemented by Activities or Fragments which are using
 * the DatePickerFragment.
 * Created by user on 2/20/2015.
 */
public interface DateUpdater {
    void updateDate(Calendar date);
}
