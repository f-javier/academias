* * * * * * * * * * *
* Programa .........: Gestion para Academias v1.00
* Subprograma ......: Compactacion y Reindexacion de Ficheros.
* Programador ......: Fco. Javier Pérez.
* * * * * *
* Compactar()  : Funcion general para la compactacion de las bases de datos.
* CompactDis() : Funcion para compactar Alumnos.
* * * * *

MEMVAR cCNormal, cCMenus

//
FUNCTION Compactar()
   LOCAL nMenu := 1
   LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
   LOCAL aFDistrib

   DO WHILE .T.
      CajaTitulo( 6,13,22,67,2," COMPACTACION DE FICHEROS DE DATOS ", "" )
      @  7,15 PROMPT " 1) Compactacion de Alumnos                        "
      @  8,15 PROMPT " 2) Compactacion de Todos los Ficheros             "

      MENU TO nMenu
      DO CASE
         CASE nMenu == 1
              CompactAlu()
         CASE nMenu == 2
              CompactAlu()
         ENDCASE
         RESTSCREEN( 6,13,22,67,cPantalla )
         RETURN NIL
      ENDDO
 RETURN NIL

//
STATIC FUNCTION CompactAlu()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\ALUMNOS.DBF" ) EXCLUSIVE ALIAS ALU033 NEW
   PACK
   INDEX ON CODIGO TO ( "DATOS\ALUMNOS.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\ALUMNOS.NT2" )
   ALU033->(DBCLOSEAREA() )
 RETURN NIL
