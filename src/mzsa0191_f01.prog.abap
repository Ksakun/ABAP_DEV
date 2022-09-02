*&---------------------------------------------------------------------*
*& Include          MZSA0190_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0190_CARRID
*&      <-- ZSSA0190_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING    VALUE(p_carrid)
                       CHANGING p_carrname.
  CLEAR p_carrname.
  SELECT SINGLE carrname
    FROM scarr
    INTO p_carrname
   WHERE carrid = p_carrid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0190_CARRID
*&      --> ZSSA0190_MEALNUMBER
*&      --> SY_LANGU
*&      <-- ZSSA0190_MEALNUMBER_T
*&---------------------------------------------------------------------*
FORM get_meal_text  USING    VALUE(p_carrid)
                             VALUE(p_mealno)
                             VALUE(p_langu)
                    CHANGING VALUE(p_meal_t).
  CLEAR p_meal_t.
  SELECT SINGLE text
    FROM smealt
    INTO p_meal_t
   WHERE carrid = p_carrid AND mealnumber = p_mealno
     AND sprache = p_langu.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_meal_info USING VALUE(p_carrid)
                         VALUE(p_mealno)
                   CHANGING ps_meal_info TYPE zssa0191.

  CLEAR ps_meal_info.
  "Meal Info
  SELECT SINGLE *
    FROM smeal
    INTO CORRESPONDING FIELDS OF ps_meal_info
   WHERE carrid = p_carrid
     AND mealnumber = p_mealno.

  "Airline Name
  PERFORM get_airline_name USING ps_meal_info-carrid
                           CHANGING ps_meal_info-carrname.
  "Meal Text
  PERFORM get_meal_text USING ps_meal_info-carrid
                              ps_meal_info-mealnumber
                              sy-langu
                        CHANGING ps_meal_info-mealnumber_t.
  "Get Price
  "Flag(V:Vendor, M:Meal), Vendor Id, Airline Code, Mealnumber
  DATA ls_vendor_info TYPE zssa0192.

  PERFORM get_vendor_info USING 'M' "Using Meal Number
                                ps_meal_info-carrid
                                ps_meal_info-mealnumber
                          CHANGING ls_vendor_info.

  ps_meal_info-price = ls_vendor_info-price.
  ps_meal_info-waers = ls_vendor_info-waers.

  "Get Meal Type text
  PERFORM get_domain_text USING 'S_MEALTYPE'
                                ps_meal_info-mealtype
                          CHANGING ps_meal_info-mealtype_t.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> PS_MEAL_INFO_CARRID
*&      --> PS_MEAL_INFO_MEALNUMBER
*&      <-- LS_VENDOR_INFO
*&---------------------------------------------------------------------*
FORM get_vendor_info  USING    VALUE(p_flag)
                               VALUE(p_code1)
                               VALUE(p_code2)
                      CHANGING ps_info TYPE zssa0192.

  DATA: BEGIN OF ls_cond,
          lifnr  TYPE ztsa0199-lifnr,
          carrid TYPE ztsa0199-carrid,
          mealno TYPE ztsa0199-mealnumber,
        END OF ls_cond.

  CASE p_flag.
    WHEN 'V'. "Vendor
      ls_cond-lifnr = p_code1.
    WHEN 'M'. "Meal
      ls_cond-carrid = p_code1.
      ls_cond-mealno = p_code2.

      SELECT SINGLE *
        FROM ztsa0199
        INTO CORRESPONDING FIELDS OF ps_info
       WHERE carrid = ls_cond-carrid
         AND mealnumber = ls_cond-mealno.

      SELECT SINGLE landx
        FROM t005t
        INTO ps_info-land1_t
       WHERE land1 = ps_info-land1
         AND spras = sy-langu.

    WHEN OTHERS.
      RETURN.
  ENDCASE.

  "Get Vendor Category Text
  PERFORM get_domain_text USING 'ZEVENCA_A01'
                                ps_info-venca
                          CHANGING ps_info-venca_t.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_domain_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_domain_text USING VALUE(p_dom_name)
                           VALUE(p_code)
                     CHANGINg VALUE(p_text).

  DATA: lv_domname   TYPE dd07l-domname,
        lt_dom_value TYPE TABLE OF dd07v,
        ls_dom_value LIKE LINE OF lt_dom_value.

  lv_domname = p_dom_name.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = lv_domname
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_dom_value
*     VALUES_DD07L    =
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR ls_dom_value.
  READ TABLE lt_dom_value WITH KEY domvalue_l = p_code
    INTO ls_dom_value.

  IF sy-subrc = 0.
    p_text = ls_dom_value-ddtext.
  ENDIF.
ENDFORM.
