*&---------------------------------------------------------------------*
*& Include          MZSA0101_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_PERNR
*&      <-- ZSSA0031
*&---------------------------------------------------------------------*
FORM get_data  USING   VALUE(p_pernr)
               CHANGING ps_info TYPE zssa0031.
  CLEAR ps_info.
  "Emp / Dep table
  SELECT SINGLE *
        FROM ztsa0001 AS emp INNER JOIN ztsa0002 AS dep
          ON emp~depid = dep~depid
        INTO CORRESPONDING FIELDS OF zssa0031
        WHERE emp~pernr = gv_pernr.
  "예외처리
  IF sy-subrc <> 0.
    MESSAGE i016(pn) WITH 'No suck Employee'.
    RETURN.
  ENDIF.
  "Dep Text Table
  SELECT SINGLE dtext
    FROM ztsa0002_t
    INTO ps_info-dtext
    WHERE depid = ps_info-depid AND spras = sy-langu.
  "Get Gender Text Domain의 fixed value를 사용하지 않을 때
*    CASE ps_info-gender.
*      WHEN '1'.
*        ps_info-gender_t = '남성'(T01).
*      WHEN '2'.
*        ps_info-gender_t = '여성'(T02).
*      when OTHERS.
*        ps_info-gender_t = 'None'(T03).
*    ENDCASE.
  "Get Gender Text Domain의 fixed value를 사용할 때 with Function
  DATA: lt_domain TYPE TABLE OF dd07v,
        ls_domain LIKE LINE  OF lt_domain.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING "functino한테 던져서 exporting
      domname         = 'ZDGENDER_A00'
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_domain "domain의 fixed value를 가지고있게된다.
*     VALUES_DD07L    =
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE lt_domain WITH KEY domvalue_l = ps_info-gender
  INTO ls_domain.
  ps_info-gender_t = ls_domain-ddtext.

ENDFORM.
