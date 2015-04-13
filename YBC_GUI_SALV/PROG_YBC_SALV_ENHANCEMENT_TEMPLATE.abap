*&---------------------------------------------------------------------*
*& Report
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT.



*----------------------------------------------------------------------*
*       CLASS lcl_report DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_report DEFINITION FINAL.

  TYPE-POOLS: abap, icon.

  PUBLIC SECTION.
    CLASS-METHODS main.

  PRIVATE SECTION.
    CLASS-DATA gt_data TYPE STANDARD TABLE OF t005.

    CLASS-METHODS:
      _select_data,
      _display_data
        RAISING
          cx_salv_access_error
          cx_salv_error,
      _on_added_function
        FOR EVENT added_function OF if_salv_events_functions
        IMPORTING
          sender
          e_salv_function,
      _on_double_click
        FOR EVENT double_click OF if_salv_events_actions_table
        IMPORTING
          sender,
      _on_before_data_change
        FOR EVENT before_data_change OF yif_salv_events_table
        IMPORTING
          changes,
      _on_after_data_change
        FOR EVENT after_data_change OF yif_salv_events_table
        IMPORTING
          sender
          changes,
      _toggle
        IMPORTING
          i_table TYPE REF TO cl_salv_table,
      _save.

ENDCLASS.                    "lcl_report DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_report IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION.

  METHOD main.

    DATA: lx_root TYPE REF TO cx_root
        .


    TRY.
        _select_data( ).
        _display_data( ).

      CATCH cx_static_check cx_dynamic_check INTO lx_root.
        IF sy-batch EQ abap_true.
          MESSAGE lx_root TYPE 'E'.
        ELSE.
          MESSAGE lx_root TYPE 'I' DISPLAY LIKE 'E'.
        ENDIF.
    ENDTRY.

  ENDMETHOD.                    "main

  METHOD _select_data.

    SELECT *
          FROM t005
          INTO CORRESPONDING FIELDS OF TABLE gt_data.

  ENDMETHOD.                    "_select_data

  METHOD _display_data.

    DATA: lo_table TYPE REF TO cl_salv_table
        , lo_columns TYPE REF TO cl_salv_columns_table
        , lo_column TYPE REF TO cl_salv_column_list
        , lo_events TYPE REF TO cl_salv_events_table
        , lo_functions TYPE REF TO cl_salv_functions_list
        , lo_selections TYPE REF TO cl_salv_selections
        , lo_change_settings TYPE REF TO ycl_salv_change_settings
        .


    CALL METHOD cl_salv_table=>factory2
      IMPORTING
        r_salv_table = lo_table
      CHANGING
        t_table      = gt_data.

    lo_columns = lo_table->get_columns( ).
    lo_columns->set_optimize( ).
    lo_columns->set_editable(
        i_value = abap_true
        i_keys  = abap_false
           ).
    lo_column = lo_columns->get_column2( 'MANDT' ).
    lo_column->set_technical( ).

    lo_events = lo_table->get_event( ).
    SET HANDLER _on_double_click
                _on_added_function
                _on_before_data_change
                _on_after_data_change
                FOR lo_events.

    lo_functions = lo_table->get_functions( ).
    lo_functions->set_all( ).
    lo_functions->add_function2( icon_toggle_display_change ).

    lo_selections = lo_table->get_selections( ).
    lo_selections->set_selection_mode( if_salv_c_selection_mode=>cell ).

    lo_change_settings = lo_table->get_change_settings( ).
    lo_change_settings->register_edit_event_enter( ).

    lo_table->display( ).

  ENDMETHOD.                    "_display_data

  METHOD _on_added_function.

    DATA: lo_table TYPE REF TO cl_salv_table
        .


    CASE e_salv_function.
      WHEN icon_toggle_display_change.
        lo_table = cl_salv_table=>get_table_by_object( sender ).
        _toggle( lo_table ).

      WHEN cl_gui_alv_grid=>mc_fc_data_save.
        _save( ).
    ENDCASE.

  ENDMETHOD.                    "_on_ADDED_FUNCTION

  METHOD _on_double_click.

    DATA: lo_table TYPE REF TO cl_salv_table
        .


    lo_table = cl_salv_table=>get_table_by_object( sender ).
    lo_table->set_function( cl_gui_alv_grid=>mc_fc_detail ).

  ENDMETHOD.                    "_on_DOUBLE_CLICK

  METHOD _on_before_data_change.

*    DATA: lt_change TYPE ybc_salv_t_change
*        , ls_change TYPE REF TO ybc_salv_s_change
*        .
*
*
*    lt_change = changes->get_changes( ).
*    LOOP AT lt_change REFERENCE INTO ls_change.
*      " do something
*    ENDLOOP.

  ENDMETHOD.                    "_on_before_data_change

  METHOD _on_after_data_change.

*    DATA: lo_table TYPE REF TO cl_salv_table
*        .
*
*
*    " do something and refresh if needed
*    lo_table = cl_salv_table=>get_table_by_object( sender ).
*    lo_table->refresh( ).

  ENDMETHOD.                    "_on_after_data_change

  METHOD _toggle.

    DATA: lo_columns TYPE REF TO cl_salv_columns_table
        , lv_editable TYPE abap_bool
        .


    lo_columns = i_table->get_columns( ).
    lv_editable = lo_columns->has_editable( ).
    TRANSLATE lv_editable USING 'X  X'.
    lo_columns->set_editable( lv_editable ).

  ENDMETHOD.                    "_toggle

  METHOD _save.

    " do something

  ENDMETHOD.                    "_save

ENDCLASS.                    "lcl_report IMPLEMENTATION



START-OF-SELECTION.
  lcl_report=>main( ).