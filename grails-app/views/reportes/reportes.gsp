<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 26/09/16
  Time: 12:28
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Reportes</title>
</head>

<body>


<div class="row">
    <a href="#" class="btn btn-info" id="imprimirNoEvaluados" title="Imprimir profesores NO evaluados">
        <i class="fa fa-print"></i> Profesores que NO han sido evaluados por los alumnos
    </a>
</div>
<div class="row">
    <a href="#" class="btn btn-info" id="imprimirEvaluados" title="Imprimir profesores YA evaluados">
        <i class="fa fa-print"></i> Profesores que YA han sido evaluados por los alumnos
    </a>
</div>
<div class="row">
    <a href="#" class="btn btn-info" id="imprimirNoAutoeva" >
        <i class="fa fa-print"></i> Profesores que NO han realizado su autoevaluación
    </a>
</div>
<div class="row">
    <a href="#" class="btn btn-info" id="imprimirAutoeva">
        <i class="fa fa-print"></i> Profesores que YA han realizado su autoevaluación
    </a>
</div>
<div class="row">
    <a href="#" class="btn btn-info" id="imprimirEstudiante">
        <i class="fa fa-print"></i> Estudiantes que han realizado la evaluación
    </a>
</div>
<div class="row">
    <a href="#" class="btn btn-info" id="imprimirNoEstudiante">
        <i class="fa fa-print"></i> Estudiantes que NO han realizado la evaluación
    </a>
</div>


<script type="text/javascript">
    $("#imprimirNoEvaluados").click(function () {

        $.ajax({
           type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'periodo_ajax')}',
            data:{

            },
            success: function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgPeriodo",
                    title   : "Seleccionar Período",
//                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var periodo = $("#periodoReporte").val();
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + periodo + "Wtipo=" + 1;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=NoEvaluados.pdf";
//                                return false
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });


    $("#imprimirEvaluados").click(function () {

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'periodo_ajax')}',
            data:{

            },
            success: function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgPeriodo",
                    title   : "Seleccionar Período",
//                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var periodo = $("#periodoReporte").val();
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + periodo + "Wtipo=" + 2;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=Evaluados.pdf";
//                                return false
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });


    $("#imprimirNoAutoeva").click(function () {

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'periodo_ajax')}',
            data:{

            },
            success: function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgPeriodo",
                    title   : "Seleccionar Período",
//                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var periodo = $("#periodoReporte").val();
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + periodo + "Wtipo=" + 3;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=NoAutoevaluados.pdf";
//                                return false
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });


    $("#imprimirAutoeva").click(function () {

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'periodo_ajax')}',
            data:{

            },
            success: function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgPeriodo",
                    title   : "Seleccionar Período",
//                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var periodo = $("#periodoReporte").val();
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + periodo + "Wtipo=" + 4;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=Autoevaluados.pdf";
//                                return false
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $("#imprimirEstudiante").click(function () {

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'periodo_ajax')}',
            data:{

            },
            success: function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgPeriodo",
                    title   : "Seleccionar Período",
//                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var periodo = $("#periodoReporte").val();
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + periodo + "Wtipo=" + 5;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=EstudiantesEvaluacion.pdf";
//                                return false
                            }
                        }

                    } //buttons
                }); //dialog
            }
        });
    });

    $("#imprimirNoEstudiante").click(function () {

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'periodo_ajax')}',
            data:{

            },
            success: function (msg) {
                var b =  bootbox.dialog({
                    id      : "dlgPeriodo",
                    title   : "Seleccionar Período",
//                    class   : "long",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        aceptar : {
                            label     : "<i class='fa fa-print'></i> Imprimir",
                            className : "btn-success",
                            callback  : function () {
                                var periodo = $("#periodoReporte").val();
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + periodo + "Wtipo=" + 6;
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