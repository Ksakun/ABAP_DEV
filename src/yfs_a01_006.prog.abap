*&---------------------------------------------------------------------*
*& Report YTEST0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yfs_a01_006.

** 예제 1 --- 가장 기본.
*DATA :  pv_data TYPE c.
*
*field-symbols : <fs> type c.
*
*ASSIGN pv_data TO <fs>.
*<fs> = 'A'.
*
*write : / <fs> , pv_data.
*
*
*UNASSIGN <FS>.





* 예제 2 dynamic table access.

PARAMETERS : p_tab TYPE string OBLIGATORY.

TYPES : BEGIN OF ty_type .
          INCLUDE TYPE sflight.
TYPES :   carrname TYPE scarr-carrname.
TYPES : END OF ty_type.



DATA : gt_scarr TYPE TABLE  OF scarr,
       gt_sflt  TYPE TABLE  OF ty_type,
       gt_sbook TYPE TABLE  OF sbook.



FIELD-SYMBOLS : <fs_tab>  TYPE ANY TABLE,
                <fs_tab1> TYPE ANY TABLE,
                <fs_line1> TYPE ty_type  ,    "any.
                <fs_line> TYPE any.
CASE p_tab.
  WHEN 'SCARR'.
    ASSIGN gt_scarr TO <fs_Tab>.

  WHEN 'SBOOK'.
    ASSIGN gt_sbook TO <fs_tab>.

  WHEN 'SFLIGHT'.
    ASSIGN gt_sflt  TO <fs_tab>.
ENDCASE.



IF <fs_tab> IS ASSIGNED.
  "break-point.
  SELECT * FROM (p_tab)
        UP TO 100 ROWS INTO CORRESPONDING FIELDS OF TABLE <fs_tab>.


*-- field symbol 로 internal table을 assign 한 경우 modify 구문이 필요 없음.
  IF p_tab = 'SFLIGHT'.
    LOOP AT <fs_tab> ASSIGNING <fs_line1>.
      SELECT SINGLE carrname INTO <fs_line1>-carrname
            FROM scarr WHERE carrid = <fs_line1>-carrid.

    ENDLOOP.
  ENDIF.




  CALL METHOD cl_demo_output=>display_data
    EXPORTING
      value = <fs_tab>.
*     name  =


*  IF p_tab = 'SCARR'.

*    LOOP AT <fs_tab> ASSIGNING  <fs_line>.
**      WRITE : / <fs_line>-carrid, <fs_line>-carrname.
*         write : / <fs_line>.
*    ENDLOOP.
*  ENDIF.
ENDIF.
