*&---------------------------------------------------------------------*
*& Report ZRSA01_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA01_15.
DATA gs_scarr TYPE scarr.
PARAMETERS pa_carr LIKE gs_scarr-carrid.
*PARAMETERS ps_carr TYPE scarr-carrid.

SELECT SINGLE carrid carrname currcode url "*
  FROM scarr
*  INTO gs_scarr
  INTO CORRESPONDING FIELDS OF gs_scarr
 WHERE carrid = pa_carr.

WRITE: gs_scarr-carrid,/ gs_scarr-carrname,/ gs_scarr-currcode,/ gs_scarr-url.

*DATA: gv_cat_name TYPE c LENGTH 10,
*      gv_cat_age  TYPE i.
*
*DATA: BEGIN OF gs_cat,
*  name TYPE c LENGTH 10,
*  age  TYPE i,
*  END OF gs_cat.

*TYPES: BEGIN OF ts_cat,
*        home TYPE c LENGTH 10,
*        name TYPE c LENGTH 10,
*        age  TYPE i,
*       END OF ts_cat.
*
*DATA gs_cat TYPE ts_cat.
*
*WRITe gs_cat-age.
