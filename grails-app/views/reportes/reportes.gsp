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
        <i class="fa fa-print"></i> Profesores NO evaluados
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
                                var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}?periodo=" + periodo;
                                location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=NoEvaluados.pdf";
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