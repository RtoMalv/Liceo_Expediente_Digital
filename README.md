# Proyecto: Liceo_Expediente_Digital

##  Descripción general
El proyecto **Liceo_Expediente_Digital** tiene como objetivo el diseño e implementación de una base de datos centralizada que permita la **digitalización de los expedientes estudiantiles** en el **Liceo de Tarrazú**.  
Busca optimizar el acceso, seguridad y actualización de la información de los estudiantes, garantizando un manejo eficiente y controlado de los datos sensibles según el rol del usuario (asistentes, guardas y choferes).

La solución está desarrollada en **Oracle Database** con procedimientos almacenados (PL/SQL) y conectada mediante una aplicación elaborada en **Visual Studio Code**, empleando el lenguaje de programación **Java** y el controlador **JDBC**.

---

##  Objetivos del proyecto

- **Diseñar y construir** una base de datos relacional en Oracle que gestione información de estudiantes, encargados, rutas y permisos de salida.
- **Implementar procedimientos almacenados, funciones y cursores** para todas las operaciones CRUD de cada tabla.
- **Conectar la aplicación desarrollada en Java** (desde VS Code) a la base de datos mediante JDBC.
- **Controlar los accesos por roles**, garantizando la privacidad y seguridad de los datos institucionales.
- **Versionar el código y los scripts SQL** utilizando GitHub para mantener control de cambios y evidencias de avance.

---


## MUY IMPORTANTE ***************************!!!!!!!!!
-- El proyecto se realizó con VSC en un entorno MacOS pero la base de datos en una máquina virtual VMWare Fusion en Windows, por lo que la conexion a pesar de ser local debió conficugarse de manera que la aplicación Java se conectara a la ip de la máquina virtal. Esto se observa en DBConection.java en el proyecto
