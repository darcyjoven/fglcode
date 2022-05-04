DATABASE ds

MAIN
DEFINE l_db     LIKE type_file.chr50  #VARCHAR(40)
DEFINE l_file   LIKE type_file.chr50  #VARCHAR(40)
DEFINE l_table  LIKE type_file.chr50  #VARCHAR(40)
DEFINE l_sql    LIKE type_file.chr100 #VARCHAR(60)
DEFINE l_msg    STRING

WHENEVER ERROR CONTINUE

LET l_db=ARG_VAL(1)
LET l_file=ARG_VAL(2)
LET l_table=ARG_VAL(3)

LET l_sql="INSERT INTO ",l_table
IF fgl_getenv('JAVACLIENT') != 'Y' THEN
   DISPLAY "LOAD FROM ",l_file," ",l_sql
END IF

DATABASE l_db
LOAD FROM l_file l_sql
#DISPLAY SQLERRMESSAGE
IF SQLCA.SQLCODE THEN
   LET l_msg=  "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
   DISPLAY l_msg
END IF

END MAIN
