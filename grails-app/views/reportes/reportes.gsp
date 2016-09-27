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
        var url = "${createLink(controller: 'reportes', action: 'profesNoEvaluados')}";
        location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url + "&filename=NoEvaluados.pdf";
        %{--location.href = "${createLink(controller:'pdf',action:'pdfLink')}?url=" + url;--}%
        return false
    });
</script>





</body>
</html>