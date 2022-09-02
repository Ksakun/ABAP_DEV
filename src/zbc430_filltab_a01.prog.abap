*&---------------------------------------------------------------------*
*& Report  SAPBC430S_FILL_CLUSTER_TAB                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZBC430_FILLTAB_A01                                  .

DATA wa_scarr  TYPE saplane.


DATA my_error TYPE i VALUE 0.


START-OF-SELECTION.

* Replace # by Your user-number and remove all * from here

  DELETE FROM ztsaplane_a01.



  SELECT * FROM saplane INTO wa_scarr.
    INSERT INTO ztsaplane_a01 VALUES wa_scarr.
  ENDSELECT.

  IF my_error = 0.
    WRITE / 'Data transport successfully finished'.
  ELSE.
    WRITE: / 'ERROR:', my_error.
  ENDIF.
