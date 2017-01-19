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
        height: 250px;
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
    <div style="text-align: center;"><h2 class="titl">
        <p class="text-warning">Reportes</p>
    </h2>
    </div>

    <div class="row">
        <div class="col-md-1"></div>
        <div class="col-md-2">Seleccione el periodo de evaluaciones:</div>

        <div class="col-sm-2"><g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                        class="form-control"
                                        from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/>
        </div>

        <div class="col-md-1">Facultad:</div>

        <div class="col-md-5">
            <g:select from="${docentes.Facultad.list([sort: 'nombre', order: 'asc'])}" optionValue="nombre"
                      optionKey="id"
                      name="facultad_name" id="facultad" class="form-control"/>
        </div>

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
                        <span class="text-success"><strong>Profesores que NO han sido evaluados por los alumnos</strong> profesores que no cuentan con evaluaciones
                        </span>
                    </div>
                </a>

                <a href="#" style="text-decoration: none">
                    <div class="texto" id="imprimirEvaluados">
                        <span class="text-success"><strong>Profesores que YA han sido evaluados por los alumnos</strong> profesores que no tienen almenos una evaluaciones
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
            </div>
        </div>
    </div>
</div>

<div class="body ui-corner-all"
     style="width: 1020px;position: relative;margin: auto;margin-top: 0px;height: 300px; ">

    <div class="ui-corner-all item fuera" style="height: 280px">
        <div class="ui-corner-all item" style="height: 280px">
            <div class="imagen" style="height: 100%; width: 200px;">
                <img src="${resource(dir: 'images', file: 'evaluar-3.png')}" width="150px" height="auto"
                     style=" margin-top:20px"/>
            </div>
            <a href="${createLink(controller: 'reportes', action: 'reportedePrueba')}" style="text-decoration: none">
                <div class="texto" id="bton_variables">
                    <span class="text-success"><strong>Desempeño académico</strong> de los profesores por variables
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirDesempeno">
                    <span class="text-success"><strong>Informe del desempeño académico</strong> de los profesores
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirNoAutoeva">
                    <span class="text-success"><strong>Recomendaciones</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirAutoeva">
                    <span class="text-success"><strong>Cuellos de botella</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirEstudiante">
                    <span class="text-success"><strong>Factores de potenciación</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirNoEstudiante">
                    <span class="text-success"><strong>Factores de éxito</strong></span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirNoEvaluados">
                    <span class="text-success"><strong>Totales del desempeño académico</strong> de los profesores por variables
                    </span>
                </div>
            </a>

            <a href="#" style="text-decoration: none">
                <div class="texto" id="imprimirNoEvaluados">
                    <span class="text-success"><strong>Clasificación del desempeño académico</strong> de los profesores
                    </span>
                </div>
            </a>

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

    $("#imprimirDesempeno").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        location.href = "${createLink(controller: 'reportes', action: 'desempeno')}?periodo=" + prdo + "&facultad=" + facl;
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
        var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + prdo + "Wfacl=" + facl + "Wtipo=" + 2;
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

    $("#imprimirNoEstudiante").click(function () {
        var prdo = $("#periodoId").val();
        var facl = $("#facultad").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'facultad_ajax')}',
            data: {facl: facl},
            success: function (msg) {
                var b = bootbox.dialog({
                    id: "dlgFacultad",
                    title: "Seleccionar Escuela y Período",
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


</script>

</body>
</html>