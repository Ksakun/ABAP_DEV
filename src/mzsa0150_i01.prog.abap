*&---------------------------------------------------------------------*
*& Include          MZSA0150_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
*      PERFORM get_airline_name USING zssa0150-carrid
*                               CHANGING zssa0150-carrname.

    WHEN 'TAB1' OR 'TAB2'.
      ts_info-activetab = ok_code.

    WHEN 'SEARCH'.

      IF gv_r1 = 'X'.
        CLEAR: zssa0152, zssa0151, zssa0150-lifnr.
        "Get Inflight Info
        PERFORM get_meal_info USING zssa0150-carrid
                                    zssa0150-mealnumber
                              CHANGING zssa0151.

        "Set Domain fixed Value in Inflight
        PERFORM set_domain USING 'S_MEALTYPE'
                                 zssa0151-mealtype
                           CHANGING zssa0151-mtext.

        "Get Vendor Info
        PERFORM get_vendor_info USING zssa0151-carrid
                                      zssa0151-mealnumber
                                CHANGING zssa0152.

        "Set Domain fixed Value in VENDOR
        PERFORM set_domain USING 'ZEVENCA_A01'
                                 zssa0152-venca
                           CHANGING zssa0152-vtext.
      ELSEIF gv_r2 ='X'.
        CLEAR: zssa0152, zssa0151, zssa0150-carrid, zssa0150-mealnumber.
        "Get Inflight Info
        PERFORM get_meal_info USING zssa0150-carrid
                                    zssa0150-mealnumber
                              CHANGING zssa0151.

        "Set Domain fixed Value in Inflight
        PERFORM set_domain USING 'S_MEALTYPE'
                                 zssa0151-mealtype
                           CHANGING zssa0151-mtext.

        "Get Vendor Info
        PERFORM get_vendor_info USING zssa0151-carrid
                                      zssa0151-mealnumber
                                CHANGING zssa0152.

        "Set Domain fixed Value in VENDOR
        PERFORM set_domain USING 'ZEVENCA_A01'
                                 zssa0152-venca
                           CHANGING zssa0152-vtext.
      ENDIF.



  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check INPUT.
  IF zssa0150-carrid = 'AB'.
    MESSAGE e016(pn) WITH 'Check AB Again.'.
  ENDIF.
ENDMODULE.
