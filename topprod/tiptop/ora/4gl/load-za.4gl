DATABASE ds

MAIN
DEFINE l_prg VARCHAR(20)
DEFINE l_za  VARCHAR(20)

LET l_prg=ARG_VAL(1)
LET l_za=ARG_VAL(2)

DISPLAY "LOAD FROM ",l_prg,".za"

DELETE FROM za_file WHERE za01=l_prg
LOAD FROM l_za INSERT INTO za_file

END MAIN
