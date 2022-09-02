*&---------------------------------------------------------------------*
*& Include ZRSA01_40_TOP                            - Report ZRSA01_40
*&---------------------------------------------------------------------*
REPORT ZRSA01_40.

"Input PERNR
PARAMETERS pa_emp TYPE ztsa0101-pernr.

"Variable of List gs_list, gt_list
DATA: gs_list TYPE zssa01list,
      gt_list LIKE TABLE OF gs_list. "gt_list TYPE zssa01list_t
