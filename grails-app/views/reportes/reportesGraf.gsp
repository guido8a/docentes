<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Reportes</title>
    <style type="text/css">
    @page {
        size: 8.5in 11in;  /* width height */
        margin: 0.25in;
    }

    .item {
        width: 940px;
        height: 340px;
        float: left;
        margin: 4px;
        font-family: 'open sans condensed';
        background-color: #eceeff;
        border: 1px;
        border-color: #5c6e80;
        border-style: solid;
    }

    .imagen {
        width: 300px;
        height: 250px;
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
    <div style="text-align: center;"><h2 class="titl">
        <p class="text-warning">Reportes Gráficos - Tendencias</p>
    </h2>
    </div>

    <div class="row text-info" style="font-size: 11pt">
        <div class="col-md-1"></div>
        <div class="col-md-2">Seleccione el periodo de evaluaciones:</div>

        <div class="col-sm-1"><g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                        class="form-control" style="width: 90px"
                                        from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
        </div>

        <div class="col-md-1" style="margin-top: 10px; margin-left: 20px">Facultad:</div>

        <div class="col-md-5">
            <g:select from="${docentes.Facultad.list([sort: 'nombre', order: 'asc'])}" optionValue="nombre"
                      optionKey="id" name="facultad_name" id="facultad" class="form-control"
                      noSelection="${[0:'Todas ...']}"/>
        </div>
%{--
        <div class="col-md-2">
            <g:link action="reportes" class="btn btn-info">
                <i class="fa fa-bar-chart"></i> Reportes
            </g:link>
        </div>
--}%

    </div>


    <div class="body ui-corner-all"
         style="width: 1020px;position: relative;margin: auto;margin-top: 10px;height: 360px; ">

        <div class="ui-corner-all item fuera">
            <div class="ui-corner-all item">
                <div class="imagen" style="height: 100%; width: 300px;">
                    <img src="${resource(dir: 'images', file: 'grafico.png')}" width="250px" height="auto"
                         style=" margin-top:50px"/>
                </div>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirClases">
                        <span class="text-success"><strong>Profesores por desempeño</strong><br/>
                            Clasificación de profesores en "A", "B" y "C" conforme el índice de calidad fijado para mínimo y óptimo
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirFactores">
                        <span class="text-success"><strong>Profesores alineados con los factores de éxito</strong><br/>
                            Gráfico porcentual de los profesores del as distintas facultades que se alinean con
                            las estrategias de la Universidad
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirPotenciadores">
                        <span class="text-success"><strong>Potenciadores de nivel y Cuellos de botella</strong><br/>
                            Gráfico comparativo de potenciadores de nivel, cuelllos de botella y otros docentes.
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirCopartivo">
                        <span class="text-success"><strong>Comparativo de desempeño general</strong><br/>
                            Gráfico comparativo del promedio del desempeño docente entre las facultades de la universidad
                        </span>
                    </div>
                </a>

            </div>
        </div>
    </div>
</div>

<div class="body ui-corner-all"
     style="width: 1020px;position: relative;margin: auto;margin-top: 0px;height: 360px; ">

    <div class="ui-corner-all item fuera">
        <div class="ui-corner-all item" style="height: 340px">
            <div class="imagen" style="height: 100%; width: 300px;">
                <img src="${resource(dir: 'images', file: 'tendencia.png')}" width="250px" height="auto"
                     style=" margin-top:50px"/>
            </div>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirRecomendados">
                    <span class="text-success"><i class="fa fa-pie-chart"></i><strong> Docentes con recomendaciones: </strong>
                        Gráfico comparativo de docentes que han resultado con recomendaciones
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirRecomendados">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Clasificación general por tipo de evaluación: </strong>
                        Gráfico comparativo general del promedio obtenido por tipo de evaluación
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirRecomendados">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Indicador general por variables: </strong>
                        Gráfico comparativo de los prmedios alcanzados en las distintas variables
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirRecomendados">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Cuellos de botella por docente: </strong>
                        Listado de docentes con su principal cuello de botella o característica negativa percibida por los alumnos
                        %{--tipos "A" en prittipo columna cb_tipo --}%
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirRecomendados">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Potenciadores de nivel por docente: </strong>
                        Listado de docentes con su principal factor potenciador de nivel o característica positiva percibida por los alumnos
                        %{--tipos "B" en prittipo columna cb_tipo --}%
                    </span>
                </div>
            </a>

        </div>
    </div>
</div>


<script type="text/javascript">

    $("#imprimirClases").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes', action: 'profesoresClases')}?periodo=" + prdo +
                "&facultad=" + facl + "&tipo=" + 1;
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