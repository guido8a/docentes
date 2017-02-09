<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 09/02/17
  Time: 14:43
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
%{--<script src="${resource(dir: 'js/plugins/raphael', file: 'raphael.min.js')}"></script>--}%
%{--<script src="${resource(dir: 'js/plugins/gauges', file: 'kuma-gauge.jquery.js')}"></script>--}%
<html>
<head>
    <meta name="layout" content="main">
    <title>Variables Auxiliares</title>
</head>

<body>

<div class="js-gauge demo gauge"></div>
<div class="js-gauge demo2 gauge"></div>
%{--<div class="js-gauge demo gauge"></div>--}%
%{--<div class="js-gauge demo gauge"></div>--}%
%{--<div class="js-gauge demo gauge"></div>--}%
%{--<div class="js-gauge demo gauge"></div>--}%

<script type="text/javascript">


    $(".demo").kumaGauge({
        value: Math.floor(${utilitarios.Auxiliares.get(2).minimo * 100})
    })

    $(".demo2").kumaGauge({
        value: Math.floor(${utilitarios.Auxiliares.get(2).optimo * 100})
    })

</script>


</body>
</html>