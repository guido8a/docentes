<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 15/09/16
  Time: 12:15
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Preguntas a aplicarse en la encuesta</title>


</head>

<body>



<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="pregunta" action="list" class="btn btn-primary" title="Regresar a la lista de preguntas">
            <i class="fa fa-chevron-left"></i> Lista
        </g:link>
        <a href="#" class="btn btn-success btnGuardar" >
            <i class="fa fa-save"></i> Guardar
        </a>
        <a href="#" class="btn btn-warning btnRegistrar" title="Registrar la pregunta">
            <i class="fa fa-check-circle-o"></i> Registrar
        </a>
        <g:link controller="profesor" action="profesor" class="btn btn-info">
            <i class="fa fa-file-o"></i> Nuevo
        </g:link>

    </div>
</div>

<div class="row">
    <div class="col-md-1 negrilla control-label">Variable: </div>
    <div class="col-md-5">
        <g:select name="variable" id="variableId" optionKey="id" optionValue="descripcion"
                  class="form-control" from="${docentes.Variables.list([sort: 'descripcion', order: 'asc'])}" value=""/>
    </div>
    <div class="col-md-1 negrilla control-label">Tipo de Valoración: </div>
    <div class="col-md-3">
        <g:select name="vloración" id="valoracionId" optionKey="id" optionValue="descripcion"
                  class="form-control" from="${docentes.TipoRespuesta.list([sort: 'descripcion', order: 'asc'])}" value=""/>
    </div>
</div>

<div class="row">
    <div class="col-md-1 negrilla control-label">Código: </div>
    <div class="col-md-1">
        <g:textField name="codigo_name" id="codigoPregunta" value="" class="form-control required" maxlength="8"/>
    </div>
    <div class="col-md-1 negrilla control-label">Respuestas: </div>
    <div class="col-md-1">
        <g:textField name="numero_name" id="numeroRespuestas" value="" class="form-control required number"/>
    </div>
    <div class="col-md-1 negrilla control-label">Estrategia: </div>
    <div class="col-md-5">
        <g:textArea name="estrategia_name" id="estrategiaPregunta" value="" class="form-control" maxlength="127" style="resize: none"/>
    </div>
</div>
<div class="row">
    <div class="col-md-1 negrilla control-label">Pregunta: </div>
    <div class="col-md-9">
        <g:textArea name="descripcion_name" id="descripcionPregunta" value="" class="form-control required" maxlength="255" style="height: 200px; resize: none"/>
    </div>
</div>



<div class="col-md-12">
    <ul class="nav nav-pills">
        <li class="active"><a data-toggle="tab" href="#home">Usuarios</a></li>
        <li><a data-toggle="tab" href="#menu1">Estación</a></li>
        <li><a data-toggle="tab" href="#menu4">Metodología</a></li>
    </ul>

    <div class="tab-content">
        <div id="home" class="tab-pane fade in active">
            <ul class="fa-ul">
                <li class="margen">
                    <g:link controller="prfl" class="over" action="list">
                        <i class="fa fa-credit-card"> Perfiles de usuario </i>
                    </g:link>
                    <div class="descripcion hidden">
                        <h4>Perfiles</h4>
                        <p>Administración de los perfiles, los cuales se asignan a los usuarios para acceder al sistema SADA.
                        </p>
                    </div>
                </li>

                <li class="margen">
                    <g:link controller="consultora" class="over" action="list">
                        <i class="fa fa-leaf"> Consultora ambiental </i>
                    </g:link>
                    <div class="descripcion hidden">
                        <h4>Consultora</h4>

                        <p>Administración de la Consultora ambiental a la cual pertenece el usuario del sistema o el personal que realizará la auditoría.
                        </p>
                    </div>
                </li>
            </ul>
        </div>
        <div id="menu1" class="tab-pane fade">
            <ul class="fa-ul">
                <li class="margen">
                    <g:link controller="comercializadora" class="over" action="list">
                        <i class="fa fa-car"> Comercializadora </i>
                    </g:link>
                    <div class="descripcion hidden">
                        <h4>Comercializadora</h4>

                        <p>Comercializadora de combustibles a la cual pertenece una estación de servicios
                        </p>
                    </div>
                </li>
                <li class="margen">
                    <g:link controller="provincia" class="over" action="list">
                        <i class="fa fa-map-marker"> Provincia </i>
                    </g:link>
                    <div class="descripcion hidden">
                        <h4>Provincia</h4>
                        <p>Administración de la provincia en la que se encuentra ubicada la estación de servicio.
                        </p>
                    </div>
                </li>
                <li class="margen">
                    <g:link controller="canton" class="over" action="list">
                        <i class="fa fa-map-marker"> Cantón </i>
                    </g:link>
                    <div class="descripcion hidden">
                        <h4>Cantón</h4>
                        <p>Administración del cantón donde encuentra ubicada la estación de servicio.
                        </p>
                    </div>
                </li>
            </ul>
        </div>
         <div id="menu4" class="tab-pane fade">
            <ul class="fa-ul">
                <li class="margen">
                    <g:link controller="metodologia" class="over" action="metodologia">
                        <i class="fa fa-book"> Metodología</i>
                    </g:link>
                    <div class="descripcion hidden">
                        <h4> Metodología </h4>
                        <p>Metodología usada en la auditoría ambiental</p>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>


</body>
</html>