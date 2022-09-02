class ZCL_IM_BADI_BOOK01_IMP_V1 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK01 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_BOOK01_IMP_V1 IMPLEMENTATION.


  method IF_EX_BADI_BOOK01~CHANGE_VLINE.

    c_pos = c_pos + 47.
  endmethod.


  METHOD if_ex_badi_book01~output.
    DATA: name TYPE scustom-name.

    SELECT SINGLE name INTO name FROM scustom
      WHERE id = i_booking-customid.

    WRITE: name, i_booking-order_date.
  ENDMETHOD.
ENDCLASS.
