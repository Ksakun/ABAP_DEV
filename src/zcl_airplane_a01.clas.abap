class ZCL_AIRPLANE_A01 definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_NAME type STRING
      !IV_PLANETYPE type SAPLANE-PLANETYPE
    exceptions
      WRONG_PLANETYPE .
  methods DISPLAY_ATTRIBUTE .
  class-methods CLASS_CONSTRUCTOR .
  class-methods DISPALY_N_O_AIRPLANES .
protected section.
private section.

  constants C_POS_1 type I value 30 ##NO_TEXT.
  data MV_NAME type STRING .
  data MV_PLANETYPE type SAPLANE-PLANETYPE .
  data MV_WEIGHT type SAPLANE-WEIGHT .
  data MV_TANKCAP type SAPLANE-TANKCAP .
  class-data GV_N_O_AIRPLANE type I .
  class-data MT_PLANETYPES type TY_PLANETYPES .
ENDCLASS.



CLASS ZCL_AIRPLANE_A01 IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.

    SELECT *
      FROM saplane
      INTO TABLE mt_planetypes.

  endmethod.


  METHOD constructor.

    mv_name = iv_name.
    mv_planetype = iv_planetype.

    DATA ls_planetype TYPE saplane.
    READ TABLE mt_planetypes INTO ls_planetype WITH KEY planetype = iv_planetype.

    IF sy-subrc = 0.
      gv_n_o_airplane = gV_n_o_airplane + 1.
      mv_weight = ls_planetype-weight.
      mv_tankcap = ls_planetype-tankcap.

    ELSE.
      RAISE wrong_planetype.
    ENDIF.


  ENDMETHOD.


  METHOD dispaly_n_o_airplanes.
    WRITE: / 'Number Of Airplanes : ', AT c_pos_1 gv_n_o_airplane.
  ENDMETHOD.


  METHOD display_attribute.

    WRITE: / icon_ws_plane AS ICON,
           / 'Airplane Name:', AT c_pos_1 mv_name,
           / 'Type of Plane: ', AT c_pos_1 mv_planetype,
           / 'Weight/Tank capacity: ', AT 20 mv_weight,  mv_tankcap.

  ENDMETHOD.
ENDCLASS.
