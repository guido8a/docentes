<%@ page import="docentes.Facultad" contentType="text/html;charset=UTF-8" %>
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
        <p class="text-warning">Reportes Generales</p> </h2>
    </div>


    <div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">

        <g:if test="${session.perfil.codigo == 'ADMG'}">
            <div class="col-sm-3 row" style="text-align: right">
                Universidad
            </div>

            <div class="col-sm-6">
                <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                          class="form-control" value="${session.univ}"
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
     style="width: 1020px;position: relative;margin: auto;margin-top: 0px;height: 280px; ">

    <div class="ui-corner-all item fuera" style="height: 290px">
        <div class="ui-corner-all item" style="height: 290px">
            <div class="imagen" style="height: 100%; width: 200px;">
                <img src="${resource(dir: 'images', file: 'evaluar-3.png')}" width="150px" height="auto"
                     style=" margin-top:20px"/>
            </div>
            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirPorAvariables">
                    <span class="text-success"><i class="fa fa-graduation-cap"></i><strong> Desempeño académico</strong> de los profesores por variables
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirDesempeno">
                    <span class="text-success"><i class="fa fa-pie-chart"></i><strong> Informe del desempeño académico</strong> de los profesores
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirReco">
                    <span class="text-success"><i class="fa fa-star"></i><strong> Recomendaciones</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirBotella">
                    <span class="text-success"><i class="fa fa-flask"></i><strong> Cuellos de Botella</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirProfesoresXBotella">
                    <span class="text-success"><i class="fa fa-flask"></i><strong> Profesores X Cuellos de Botella</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirPotencia">
                    <span class="text-success"><i class="fa fa-flash"></i><strong> Factores de Potenciación</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirProfesoresXPotencia">
                    <span class="text-success"><i class="fa fa-flash"></i><strong> Profesores X Factores de Potenciación</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirExito">
                    <span class="text-success"><i class="fa fa-sun-o"></i><strong> Factores de Éxito</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirTotales">
                    <span class="text-success"><i class="fa fa-line-chart"></i><strong> Totales del desempeño académico</strong> de los profesores por variables
                    </span>
                </div>
            </a>

            %{--<a href="#" style="text-decoration: none">--}%
            %{--<div class="texto" id="imprimirClasificacion">--}%
            %{--<span class="text-success"><i class="fa fa-signal"></i><strong> Clasificación del desempeño académico</strong> de los profesores--}%
            %{--</span>--}%
            %{--</div>--}%
            %{--</a>--}%

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirCatego">
                    <span class="text-success"><i class="fa fa-bars"></i><strong> Ordenamiento por variables </strong> de profesores
                    </span>
                </div>
            </a>
        </div>
    </div>
</div>





<div class="body ui-corner-all"
     style="width: 1020px;position: relative;margin: auto;margin-top: 0px;height: 150px; ">

    <div class="ui-corner-all item fuera" style="height: 150px">
        <div class="ui-corner-all item" style="height: 150px">
            <div class="imagen" style="height: 100%; width: 200px;">
                <img src="${resource(dir: 'images', file: 'survey.png')}" width="100px" height="auto"
                     style=" margin-top:0px; margin-left: 30px"/>
            </div>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirEncuesta">
                    <span class="text-success"><i class="fa fa-pencil-square-o"></i><strong> Encuestas </strong> de profesores
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirFactores">
                    <span class="text-success"><i class="fa fa-pencil-square-o"></i><strong> Factores de éxito</strong>
                    </span>
                </div>
            </a>
            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirEvaluacionesPro">
                    <span class="text-success"><i class="fa fa-pencil-square-o"></i><strong> Evaluaciones del profesor</strong>
                    </span>
                </div>
            </a>
        </div>
    </div>
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




    $("#imprimirDesempeno").click(function () {
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        if($("#facultad").val() != null){
            location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" +
                    facultad + "&pantalla=" + 1 + "&escl=" + escuela;
        }else{
            log("Seleccione una facultad","info")
        }
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

        var facultad = $("#facultad option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        if($("#facultad").val() != null){
            if(escuela != null){
                $.ajax({
                    type: 'POST',
                    url: '${createLink(controller: 'reportes', action: 'variables_ajax')}',
                    data: {facl: facultad},
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
                                        var facl = $("#facultad option:selected").val();
                                        var tipo = $("#variableDesem").val();
                                        location.href = "${createLink(controller: 'reportes', action: 'reporteVariables')}?periodo=" + prdo + "&facl=" + facl + "&tipo=" + tipo + "&escl=" + escuela;
                                    }
                                }

                            } //buttons
                        }); //dialog
                    }
                });
            }else{
                log("Seleccione una escuela","info")
            }
        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirTotales").click(function () {
        var facultad = $("#facultad option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        if($("#facultad").val() != null){
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'variables_ajax')}',
                data: {facl: facultad},
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
                                    location.href = "${createLink(controller: 'reportes', action: 'reporteTotalesDesempeno')}?periodo=" + prdo + "&facl=" + facl + "&tipo=" + tipo + "&escl=" + escuela;
                                }
                            }
                        } //buttons
                    }); //dialog
                }
            });
        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirCatego").click(function () {
        var facultad = $("#facultad option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        if($("#facultad").val() != null){
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'variables_ajax')}',
                data: {facl: facultad},
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
                                    location.href = "${createLink(controller: 'reportes', action: 'reporteOrdenamiento')}?periodo=" + prdo + "&facl=" + facl + "&tipo=" + tipo + "&escl=" + escuela;
                                }
                            }
                        } //buttons
                    }); //dialog
                }
            });
        }
        else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirReco").click(function () {
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        if($("#facultad").val() != null){
            location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" + facultad + "&pantalla=" + 2 + "&escl=" + escuela;
        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirBotella").click(function () {
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();

        if($("#facultad").val() != null){
            location.href = "${createLink(controller: 'reportes2', action: 'botella')}?periodo=" + prdo + "&facultad=" + facultad;
        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirPotencia").click(function () {
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();

        if($("#facultad").val() != null){
            location.href = "${createLink(controller: 'reportes2', action: 'potencia')}?periodo=" + prdo + "&facultad=" + facultad;
        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirExito").click(function () {
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();

        if($("#facultad").val() != null){
            location.href = "${createLink(controller: 'reportes2', action: 'exito')}?periodo=" + prdo + "&facultad=" + facultad;
        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirClasificacion").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes2', action: 'clasificacion')}?periodo=" + prdo + "&facultad=" + facl;
    });

    $("#imprimirEncuesta").click(function () {
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        if($("#facultad").val() != null){
            location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" + facultad + "&pantalla=" + 3 + "&escl=" + escuela;
        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirFactores").click(function () {
        var facultad = $("#facultad option:selected").val();

        if($("#facultad").val() != null){
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'escuelas_ajax')}',
                data: {facl: facultad},
                success: function (msg) {
                    var b = bootbox.dialog({
                        id: "dlgEscuelas",
                        title: "Seleccionar la Escuela",
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
                                    var escl = $("#escuelaId").val();
                                    location.href = "${createLink(controller: 'reportes2', action: 'factores')}?periodo=" + prdo + "&facultad=" + facl + "&escuela=" + escl;
                                }
                            }
                        } //buttons
                    }); //dialog
                }
            });

        }else{
            log("Seleccione una facultad","info")
        }
    });

    $("#imprimirEvaluacionesPro").click(function () {
        var prdo = $("#periodoId").val();
        var facultad = $("#facultad option:selected").val();

        if($("#facultad").val() != null){
            location.href = "${createLink(controller: 'reportes2', action: 'evaluacionesProfe')}?periodo=" + prdo + "&facultad=" + facultad;
        }else{
            log("Seleccione una facultad","info")
        }
    });

</script>

</body>
</html>