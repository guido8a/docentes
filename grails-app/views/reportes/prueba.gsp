<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/10/16
  Time: 15:32
--%>



<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<head>



    <meta name="layout" content="main">
    <title></title>
</head>

<body>


<a href="#" class="btn btn-warning btnChart" title="">
    <i class="fa fa-check-circle-o"></i> Click
</a>

<a href="${createLink(controller: 'reportes' , action: 'reportedePrueba')}" class="btn btn-warning" title="">
    <i class="fa fa-check-circle-o"></i> Click 2
</a>

<a href="${createLink(controller: 'reportes' , action: 'grafica')}" class="btn btn-warning" title="">
    <i class="fa fa-check-circle-o"></i> Doble gráfica
</a>


<img src="${imagen}" width="80%" height="80%"/>




<div id="divChart">

</div>


<script type="text/javascript">

    $(".btnChart").click(function () {

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportes', action: 'getChart')}',
            data:{

            },
            success: function (msg) {
//                console.log("msg " + msg)
//                $("#divChart").html(msg)
                $("#divChart").append(msg)
            }
        })
    });

</script>

</body>
</html>