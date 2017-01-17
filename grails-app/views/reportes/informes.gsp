<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/01/17
  Time: 9:57
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Informes</title>
</head>

<body>

<div class="row">
    <a href="#" class="btn btn-info" id="desempe" title="Imprimir informe de desempeño">
        <i class="fa fa-print"></i> Informe del desempeño
    </a>
</div>

<script type="text/javascript">

    $("#desempe").click(function () {
       location.href="${createLink(controller: 'reportes', action: 'desempeno')}"
    });


</script>

</body>
</html>