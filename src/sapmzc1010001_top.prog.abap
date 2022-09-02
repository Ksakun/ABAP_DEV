*&---------------------------------------------------------------------*
*& Include SAPMZC1010001_TOP                        - Module Pool      SAPMZC1010001
*&---------------------------------------------------------------------*
PROGRAM sapmzc1010001 MESSAGE-ID zmcsa01.

DATA: ok_code TYPE sy-ucomm.

"DATA BEGIN OF 할 것이냐, 바로 참조할것이냐
"참조
*DATA: gs_data TYPE ztsa01mm.
"Make Structure
DATA: BEGIN OF gs_data,
        matnr TYPE ztsa01mm-matnr, "Material
        werks TYPE ztsa01mm-werks, "Plant
        mtart TYPE ztsa01mm-mtart, "Mat.Type
        matkl TYPE ztsa01mm-matkl, "Mat.Group
        menge TYPE ztsa01mm-menge, "Quantity
        meins TYPE ztsa01mm-meins, "Unit
        dmbtr TYPE ztsa01mm-dmbtr, "Price
        waers TYPE ztsa01mm-waers, "Currency
      END OF gs_data,

      gt_data like TABLE OF gs_data.



"For ALV

DATA: gcl_container TYPE REF TO cl_gui_custom_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_layout     TYPE lvc_s_layo,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_variant    TYPE disvariant.
