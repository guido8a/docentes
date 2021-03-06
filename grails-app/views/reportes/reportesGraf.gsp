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

    <div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">

        <g:if test="${session.perfil.codigo == 'ADMG'}">
            <div class="col-sm-3 row" style="text-align: right">
                Universidad
            </div>

            <div class="col-sm-6">
                <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                          class="form-control"
                          from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
            </div>
            <div class="col-md-1">Período:</div>
        </g:if>
        <g:else>
            <div class="col-sm-3 row" style="text-align: right">
                Universidad
            </div>

            <div class="col-sm-6">
                <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                          class="form-control" from="${seguridad.Persona.get(session.usuario.id)?.universidad}"/>
            </div>

            <div class="col-md-1">Periodo:</div>

        </g:else>

        <div class="col-md-2" id="divPeriodos">

        </div>

    </div>
    <div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">
        <div class="col-md-1">Facultad</div>
        <div class="col-md-5" id="divFacultad">

        </div>

        <div class="col-md-1">Carrera</div>
        <div class="col-md-5" id="divEscuela">

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
                <div class="texto" id="imprimirClases">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Profesores por desempeño</strong>
                        Clasificación de profesores en "A", "B" y "C" conforme el índice de calidad fijado para mínimo y óptimo
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirRecomendados">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Docentes con recomendaciones: </strong>
                        Listado de docentes que han resultado con recomendaciones
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirCuellosBotella">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Cuellos de botella por docente: </strong>
                        Listado de docentes con su principal cuello de botella o característica negativa percibida por los alumnos
                        %{--tipos "A" en prittipo columna cb_tipo --}%
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirPotenciador">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Potenciadores de nivel por docente: </strong>
                        Listado de docentes con su principal factor potenciador de nivel o característica positiva percibida por los alumnos
                        %{--tipos "B" en prittipo columna cb_tipo --}%
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirTipoEncuesta">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Clasificación general por tipo de evaluación: </strong>
                        Reporte comparativo general del promedio obtenido por tipo de evaluación
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirIndicadorVariables">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Indicador general por variables: </strong>
                        Reporte comparativo de los promedios alcanzados en las distintas variables
                    </span>
                </div>
            </a>

        </div>
    </div>
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
            url: '${createLink(controller: 'reportesGraf', action: 'facultadSel_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divFacultad").html(msg)
            }
        });
    }



    %{--cargarPeriodo($("#universidadId").val());--}%
    %{--cargarFacultad($("#universidadId").val());--}%

    %{--$("#universidadId").change(function () {--}%
    %{--var id = $("#universidadId option:selected").val();--}%
    %{--cargarPeriodo(id);--}%
    %{--cargarFacultad(id);--}%
    %{--});--}%

    %{--function cargarPeriodo(id) {--}%
    %{--$.ajax({--}%
    %{--type: 'POST',--}%
    %{--url: '${createLink(controller: 'reportesGraf', action: 'periodo_ajax')}',--}%
    %{--data:{--}%
    %{--universidad: id--}%
    %{--},--}%
    %{--success: function (msg){--}%
    %{--$("#divPeriodos").html(msg)--}%
    %{--}--}%
    %{--});--}%
    %{--}--}%


    %{--function cargarFacultad (id) {--}%
    %{--$.ajax({--}%
    %{--type: 'POST',--}%
    %{--url: '${createLink(controller: 'reportesGraf', action: 'facultad_ajax')}',--}%
    %{--data:{--}%
    %{--universidad: id--}%
    %{--},--}%
    %{--success: function (msg){--}%
    %{--$("#divFacultad").html(msg)--}%
    %{--}--}%
    %{--});--}%
    %{--}--}%

    $("#imprimirCuellosBotella").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escu = $("#escuelaId option:selected").val();
        if(escu != null){
            var url = "${createLink(controller: 'reportes', action: 'cuellosBotella')}?periodo=" + prdo + "Wfacultad=" + facl + "Wescl=" + escu;
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=cuellosBotella.pdf";
        }else{
            log("Seleccione una carrera","info")
        }

    });


    $("#imprimirPotenciador").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escu = $("#escuelaId option:selected").val();
        if(escu != null){
            var url = "${createLink(controller: 'reportes', action: 'potenciadores')}?periodo=" + prdo + "Wfacultad=" + facl + "Wescl=" + escu;
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=potenciadores.pdf";
        }else{
            log("Seleccione una carrera","info")
        }
    });

    $("#imprimirClases").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escu = $("#escuelaId option:selected").val();
        var universidad = $("#universidadId option:selected").val();

        if(escu != null){
            var url = "${createLink(controller: 'reportes', action: 'reporteDesempeno')}?periodo=" + prdo + "Wfacultad=" + facl + "Wescuela=" + escu + "Wuniv=" + universidad;
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=desempeno.pdf";
        }else{
            log("Seleccione una carrera","info")
        }
    });

    $("#imprimirRecomendados").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escu = $("#escuelaId option:selected").val();
        if(escu != null){
            var url = "${createLink(controller: 'reportes', action: 'recomendaciones')}?periodo=" + prdo + "Wfacultad=" + facl + "Wescuela=" + escu;
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=recomendados.pdf";
        }else{
            log("Seleccione una carrera","info")
        }
    });

    $("#imprimirTipoEncuesta").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escu = $("#escuelaId option:selected").val();
        if(escu != null){
            var url = "${createLink(controller: 'reportes', action: 'reporteTipoEncuesta')}?periodo=" + prdo + "Wfacultad=" + facl;
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=tipoEncuesta.pdf";
        }else{
            log("Seleccione una carrera","info")
        }

    });

    $("#imprimirIndicadorVariables").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        var escu = $("#escuelaId option:selected").val();
        if(escu != null){
            var url = "${createLink(controller: 'reportes', action: 'reporteDesempenoVariables')}?periodo=" + prdo + "Wfacultad=" + facl;
            location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=desempenoPorVariables.pdf";
        }else{
            log("Seleccione una carrera","info")
        }
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
        location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" + facl + "&pantalla=" + 2
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