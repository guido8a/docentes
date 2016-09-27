<!--
  To change this template, choose Tools | Templates
  and open the template in the editor.
-->

<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
  <head>
    <meta name="layout" content="main" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quanto</title>
      <style>
        .caja {
            text-align: center;
            padding: 30px;
            margin-top: 40px;
            margin-left: 440px;
            border-style:solid;
            border-width: thin;
        }
        .cajaProf {
            color: #116;
        }
        .cajaEstd {
            color: #055;
        }
        .cajaErr {
            color: #611;
        }

      </style>
  </head>
  <body>
    <div class="contenido ui-widget-content ui-corner-all " style="position: absolute;left: 10px;">
      ${estudiante}
      <div class=" filaEntera ui-corner-all " >
        <div style="float: left"><img src="${resource(dir:'images',file:'quanto.jpg')}" width="410px" height="415px"/></div>
        Usted está a punto de inicar la Evaluación<br><br>

        Por favor lea  y entienda bien las preguntas y señale la opción de respuesta que más se aplique.<br><br>

    %{--UNACH--}%
        <g:if test="docentes"> Si aun no ha ingresado las materias en las que se halla matriculado, hágalo usando el botón "registrar materias"
        </g:if>
        modulo: ${persona}
    %{--Fin UNACH--}%

      %{--UPEC1--}%
%{--
        <g:if test="${(!prsn)}">
            <div class="caja cajaErr">
                <p>Error</p>
                <p style="font-weight: bold">La cédula que ingresó no se halla registrada</p>
                <p>Consulte con el Administrador del Sistema</p>
            </div>
        </g:if>
        <g:else>
        <g:if test="${(persona == 'P')}">
            <div class="caja cajaProf">
                <p>Usted se halla registrado en el sistema como Docente</p>
                <p style="margin-top: 20px;">Bienvenido</p><p style="margin-top: 30px; font-weight: bold">${prsn}</p>
            </div>
        </g:if>
        <g:if test="${(persona == 'E')}">
            <div class="caja cajaEstd">
            <p>Usted se halla registrado en el sistema como Estudiante</p>
            <p style="margin-top: 20px;">Bienvenido</p><p style="margin-top: 30px; font-weight: bold">${prsn}</p>
            </div>
        </g:if>
        </g:else>
--}%
        %{--fin UPEC1--}%

      </div>
      <div style=" width: 230px;height: 45px;position: absolute; bottom: 20px;left:20px;"><a href="${createLink(controller: 'inicio', action: 'inicio')}" class="btn"><font size="3">Abandonar la Encuesta</font></a></div>

    %{--UPEC2--}%
%{--
      <g:if test="${(prsn)}">
      <div style=" width: 130px;height: 45px;position: absolute; bottom: 20px;right:20px;"><a href="#" id="emp" class="btn"><font size="5">Empezar</font></a></div>
      </g:if>
--}%
    %{--fin UPEC2--}%

       %{--UNACH--}%
        <div style=" width: 130px;height: 45px;position: absolute; bottom: 20px;right:20px;"><a href="#" id="emp" class="btn"><font size="5">Empezar</font></a></div>
       %{--Fin UNACH--}%

    </div>
  </body>

</html>



