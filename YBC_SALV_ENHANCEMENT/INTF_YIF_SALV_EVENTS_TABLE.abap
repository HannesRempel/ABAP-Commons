CLASS cl_gui_alv_grid DEFINITION DEFERRED PUBLIC.
CLASS ycl_salv_changes DEFINITION DEFERRED PUBLIC.
*"* components of interface YIF_SALV_EVENTS_TABLE
interface YIF_SALV_EVENTS_TABLE
  public .


  events AFTER_DATA_CHANGE
    exporting
      value(I_CHANGES) type ref to YCL_SALV_CHANGES .
  events BEFORE_DATA_CHANGE
    exporting
      value(I_CHANGES) type ref to YCL_SALV_CHANGES .
  events GRID_CREATED
    exporting
      value(I_GRID) type ref to CL_GUI_ALV_GRID .
endinterface.