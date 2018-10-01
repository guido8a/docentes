<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 01/10/18
  Time: 15:07
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Reportes de Evaluación</title>
    <style type="text/css">
    @page {
        size: 8.5in 11in;  /* width height */
        margin: 0.25in;
    }

    .item {
        width: 940px;
        height: 280px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }

    .imagen {
        width: 200px;
        height: 130px;
        float: left;
        padding: 20px;
    }

    .texto {
        width: 95%;
        padding-top: 10px;
        font-size: 15px;
        font-style: normal;
    }

    .fuera {
        margin-left: 15px;
        margin-top: 10px;
        background-color: rgba(114, 131, 147, 0.9);
        border: none;
    }

    .titl {
        font-family: 'open sans condensed';
        font-weight: bold;
        text-shadow: -2px 2px 1px rgba(0, 0, 0, 0.25);
        color: #0070B0;
        margin-top: 0px;
    }
    </style>
</head>

<body>
<div class="dialog">
    <div style="text-align: center;" class="row"><h2 class="titl">
        <p class="text-warning">Reportes de Evaluación</p> </h2>
    </div>


    <div class="row text-info" style="font-size: 11pt;">
        <g:if test="${session.perfil.codigo == 'ADMG'}">

            <div class="form-group col-md-3" style="margin-left: 100px">
                <div class="col-md-1">Universidad:</div>

                <div class="input-group">
                    <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                              class="form-control" style="width: 300px"
                              from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
                </div>
            </div>

            <div class="form-group col-md-1" style="margin-left: 10px">
                <div class="col-md-1">Período:</div>

                <div class="input-group">
                    <div class="col-md-2" id="divPeriodos">

                    </div>
                </div>
            </div>

            <div class="form-group col-md-6" style="margin-left: 10px">
                <div class="col-md-1">Facultad:</div>

                <div class="input-group col-md-12">
                    <div class="col-md-10" id="divFacultad">

                    </div>
                </div>
            </div>

        </g:if>
        <g:else>
            <div class="form-group col-md-1" style="margin-left: 180px">
                <div class="col-md-1">Período:</div>

                <div class="input-group">
                    <div class="col-md-2">
                        <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                  class="form-control" style="width: 90px"
                                  from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>
                    </div>
                </div>
            </div>

            <div class="form-group col-md-6" style="margin-left: 10px">
                <div class="col-md-1">Facultad:</div>

                <div class="input-group col-md-12">
                    <div class="col-md-10">
                        <g:select from="${docentes.Facultad.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id),[sort: 'nombre', order: 'asc'])}" optionValue="nombre"
                                  optionKey="id" name="facultad_name" id="facultad" class="form-control"
                                  noSelection="${[0:'Todas ...']}"/>
                    </div>
                </div>
            </div>
        </g:else>
    </div>

    <div class="body ui-corner-all"
         style="width: 1020px;position: relative;margin: auto;margin-top: 10px;height: 280px; ">

        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen" style="height: 100%; width: 200px;">
                    <img src="${resource(dir: 'images', file: 'evaluar.png')}" width="150px" height="auto"
                         style=" margin-top:0px"/>
                </div>
                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirNoEvaluados">
                        <span class="text-success"><strong>Profesores que NO han sido evaluados por los alumnos</strong>
                            profesores que no cuentan con evaluaciones
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirEvaluados">
                        <span class="text-success"><strong>Profesores que YA han sido evaluados por los alumnos</strong> profesores que tienen al menos una evaluación
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirNoAutoeva">
                        <span class="text-success"><strong>Profesores que NO han realizado su autoevaluación</strong>
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirAutoeva">
                        <span class="text-success"><strong>Profesores que YA han realizado su autoevaluación</strong>
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirEstudiante">
                        <span class="text-success"><strong>Estudiantes que han realizado la evaluación</strong></span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirNoEstudiante">
                        <span class="text-success"><strong>Estudiantes que NO han realizado la evaluación</strong>
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="asignaturas">
                        <span class="text-success"><strong>Asignaturas que faltan por evaluar</strong>
                        </span>
                    </div>
                </a>
            </div>
        </div>
    </div>
</div>



</div>


%{--<a href="${createLink(controller: 'reportes', action: 'reportedePrueba')}" class="btn btn-info" title="">--}%
%{--<i class="fa fa-graduation-cap"></i> Profesor--}%
%{--</a>--}%

%{--<a href="${createLink(controller: 'reportes', action: 'grafica')}" class="btn btn-warning" title="">--}%
%{--<i class="fa fa-map-marker"></i> Doble gráfica--}%
%{--</a>--}%

</div>




<script type="text/javascript">


    cargarPeriodo($("#universidadId").val());
    cargarFacultad($("#universidadId").val());

    $("#universidadId").change(function () {
        var id = $("#universidadId option:selected").val();
        cargarPeriodo(id);
        cargarFacultad(id);
    });

    function cargarPeriodo(id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'periodo_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divPeriodos").html(msg)
            }
        });
    }


    function cargarFacultad (id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'facultad_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divFacultad").html(msg)
            }
        });
    }




    $("#imprimirDesempeno").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" + facl + "&pantalla=" + 1;
    });


    $("#imprimirNoEvaluados").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + prdo + "Wfacl=" + facl + "Wtipo=" + 1;
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=NoEvaluados.pdf";
    });


    $("#imprimirEvaluados").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        %{--var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + prdo + "Wfacl=" + facl + "Wtipo=" + 2;--}%
        var url = "${createLink(controller: 'reportes', action: 'profesEvaluados')}?periodo=" + prdo + "Wfacl=" + facl;
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=Evaluados.pdf";
    });


    $("#imprimirNoAutoeva").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + prdo + "Wfacl=" + facl + "Wtipo=" + 3;
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=NoAutoevaluados.pdf";
    });


    $("#imprimirAutoeva").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + prdo + "Wfacl=" + facl + "Wtipo=" + 4;
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=Autoevaluados.pdf";
    });

    $("#imprimirEstudiante").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + prdo + "Wfacl=" + facl + "Wtipo=" + 5;
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=EstudiantesNoEvaluacion.pdf";
    });

    $("#btonVariables").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var url = "${createLink(controller: 'reportes', action: 'reporteVariables')}?periodo=" + prdo + "&facl=" + facl;
        location.href = url;
    });

    $("#imprimirNoEstudiante").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var facultad = $("#facultad").find("option:selected").text();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'facultad_ajax')}',
            data: {facl: facl},
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgFacultad",
                    title: "Seleccionar Escuela de: " + facultad,
//                    class   : "long",
                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        },
                        aceptar: {
                            label: "<i class='fa fa-print'></i> Imprimir",
                            className: "btn-success",
                            callback: function () {
                                var escuela = $("#escuelaRprt").val();
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + prdo + "Wtipo=" + 6 + "Wescl=" + escuela;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=EstudiantesNoEvaluacion.pdf";
//                                return false
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $("#asignaturas").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var facultad = $("#facultad").find("option:selected").text();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'facultad_ajax')}',
            data: {facl: facl},
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgFacultad",
                    title: "Seleccionar Escuela de: " + facultad,
//                    class   : "long",
                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        },
                        aceptar: {
                            label: "<i class='fa fa-print'></i> Imprimir",
                            className: "btn-success",
                            callback: function () {
                                var escuela = $("#escuelaRprt").val();
                                var url = "${createLink(controller: 'reportes', action: 'asignaturas')}?periodo=" + prdo + "Wtipo=" + 7 + "Wescl=" + escuela;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=EstudiantesNoEvaluacion.pdf";
//                                return false
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $("#imprimirPorAvariables").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var facultad = $("#facultad").find("option:selected").text();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'variables_ajax')}',
            data: {facl: facl},
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgVariables",
                    title: "Seleccionar de Variables de Desempeño",
//                    class   : "long",
                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        },
                        aceptar: {
                            label: "<i class='fa fa-print'></i> Imprimir",
                            className: "btn-success",
                            callback: function () {
                                var prdo = $("#periodoId").val();
                                var facl = $("#facultad").val();
                                var tipo = $("#variableDesem").val();
                                location.href = "${createLink(controller: 'reportes', action: 'reporteVariables')}?periodo=" + prdo + "&facl=" + facl + "&tipo=" + tipo;
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $("#imprimirTotales").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var facultad = $("#facultad").find("option:selected").text();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'variables_ajax')}',
            data: {facl: facl},
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgVariablesTotales",
                    title: "Seleccionar Variables",
//                    class   : "long",
                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        },
                        aceptar: {
                            label: "<i class='fa fa-print'></i> Imprimir",
                            className: "btn-success",
                            callback: function () {
                                var prdo = $("#periodoId").val();
                                var facl = $("#facultad").val();
                                var tipo = $("#variableDesem").val();
                                location.href = "${createLink(controller: 'reportes', action: 'reporteTotalesDesempeno')}?periodo=" + prdo + "&facl=" + facl + "&tipo=" + tipo;
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $("#imprimirCatego").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var facultad = $("#facultad").find("option:selected").text();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'variables_ajax')}',
            data: {facl: facl},
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgVariablesCate",
                    title: "Seleccionar de Variables de Desempeño",
                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        },
                        aceptar: {
                            label: "<i class='fa fa-print'></i> Imprimir",
                            className: "btn-success",
                            callback: function () {
                                var prdo = $("#periodoId").val();
                                var facl = $("#facultad").val();
                                var tipo = $("#variableDesem").val();
                                location.href = "${createLink(controller: 'reportes', action: 'reporteOrdenamiento')}?periodo=" + prdo + "&facl=" + facl + "&tipo=" + tipo;
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $("#imprimirReco").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" + facl + "&pantalla=" + 2;
    });

    $("#imprimirBotella").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes2', action: 'botella')}?periodo=" + prdo + "&facultad=" + facl;
    });

    $("#imprimirPotencia").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes2', action: 'potencia')}?periodo=" + prdo + "&facultad=" + facl;
    });

    $("#imprimirExito").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes2', action: 'exito')}?periodo=" + prdo + "&facultad=" + facl;
    });

    $("#imprimirClasificacion").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes2', action: 'clasificacion')}?periodo=" + prdo + "&facultad=" + facl;
    });

    $("#imprimirEncuesta").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" + facl + "&pantalla=" + 3;
    });

    $("#imprimirFactores").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes2', action: 'factores')}?periodo=" + prdo + "&facultad=" + facl;
    });


    $("#imprimirEvaluacionesPro").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes2', action: 'evaluacionesProfe')}?periodo=" + prdo + "&facultad=" + facl;
    });

</script>

</body>
</html>