1) Ejecuta en SQL Developer:
   @database/script_creacion.sql
   @database/crud_procedimientos.sql
   @database/datos_prueba.sql

2) En src/conexion/ConexionOracle.java ajusta URL/USER/PASS.

3) Compila y ejecuta:
   javac -d bin $(find src -name "*.java")
   java -cp bin main.App
(En Windows sin 'find', compila desde VS Code o usa una extensión Java.)
