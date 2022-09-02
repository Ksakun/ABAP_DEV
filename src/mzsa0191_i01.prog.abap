*&---------------------------------------------------------------------*
*& Include          MZSA0190_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'ENTER'.
      "Get Airline Name Subroutine
      PERFORM get_airline_name USING zssa0190-carrid
                               CHANGING zssa0190-carrname.
      "Get Meal Text
      PERFORM get_meal_text USING zssa0190-carrid
                                  zssa0190-mealnumber
                                  sy-langu "가연성을 줄 수 있음 ex 한국어 로그인에서 영어를 볼 수 있게 할수 잇음
                            CHANGING zssa0190-mealnumber_t.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      PERFORM get_meal_info USING zssa0190-carrid
                                  zssa0190-mealnumber
                            CHANGING zssa0191.
       " 밑의 2개의 subroutine을 get_meal_info에 넣어야 보기 편해진다.
*      "Get Airline Name Subroutine
*      PERFORM get_airline_name USING zssa0190-carrid
*                               CHANGING zssa0190-carrname.
*      "Get Meal Text
*      PERFORM get_meal_text USING zssa0190-carrid
*                                  zssa0190-mealnumber
*                                  sy-langu "가연성을 줄 수 있음 ex 한국어 로그인에서 영어를 볼 수 있게 할수 잇음
*                            CHANGING zssa0190-mealnumber_t.
      PERFORM get_vendor_info USING 'M'
                                    zssa0190-carrid
                                    zssa0190-mealnumber
                              CHANGING zssa0192.
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
