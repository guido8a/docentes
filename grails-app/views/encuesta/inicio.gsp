<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="layout" content="main" />
    <title>Quanto Docentes</title>

    <style>
    .fila{
        margin-top: 20px;
        width: 100%;
    }
    .pie{
        background: #dcdcd0;
        width: 750px;
        height: 20px;
        font-family: serif;
        font-style: italic;
        font-size: 10pt;
        text-align: center;
        z-index: 2;
        margin-top: 40px;
        margin: auto;
    }
    </style>
</head>
<body>
    <elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>
%{--<g:if test="${flash.message}">--}%
    %{--<div class="message">${flash.message}</div>--}%
%{--</g:if>--}%

<div style="text-align: center;">
    %{--Para personalizar: UNACH: universidad1.jpg, UPEC universidad.jpg y en messages_es.properties la universidad--}%
        <div class="logo"><img src="${resource(dir:'images',file:'universidad.jpeg')}" height="150px"></div>
        <div class="logo_tx"><h1>${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}</h1>
            <br>Sistema para uso exclusivo de la esta Universidad</div>
        <div class="login bs-component" style="height: 200px; width: 500px; margin: auto">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Ingrese sus datos personales</h3>
                </div>
            <div class="panel-body">
                <g:form action="ingreso" method="post" class="frma">
                    <input type="hidden" hidden name="tipo" id="tipoIf" value="">
                    <fieldset style="width: 460px; height: 80px; margin-top: 4px; border-color: black;" >
                        <div class="fila der " style="margin-top: 10px;">
                            <label>Cédula de Identidad:</label><input class="cedula" type="text" name="cdla" maxlength="15" size="20">
                            <br><span class="error">Verifique el número de su cédula de identidad</span>
                        </div>
                        <div class="fila">
                            <input class="btn btn-primary submit" value="Soy Docente" tipo="P">
                            <input class="btn btn-info submit" value="Soy Estudiante" tipo="E" style="margin-left: 20px">
                        </div>
                    </fieldset>
                    </div>
                </g:form>
            </div>
        </div>

        <div class="pie"> Desarrollado por: TEDEIN SA &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="http://www.tedein.com.ec">www.tedein.com.ec</a></div>

</div>

    %{--<script type="text/javascript" src="${resource(dir:'js/jquery/js',file:'jquery-1.4.2.min.js')}"></script>--}%
    <script type="text/javascript">

        $(document).ready(function() {

            $('.error').hide();
            $('.submit').click(function(event){
                var vl = $('.cedula').val();
                var ln = vl.length;
                var tipo = $(this).attr('tipo');
                $("#tipoIf").val(tipo);
//                alert($("#tipoIf").val());
                if (ln == 10) {
                    if(parseInt(vl.substring(9,10)) != cedula(vl)) {
                        $('.error').show();
                        $('.cedula').css("border", "1px solid #f00");
                        event.preventDefault();
                    } else {
                        $('.error').hide();
                        $(".frma").submit();
                    }
                } else {
                    if (confirm("El número de cédula ingresado no es ECUATORIANO\nDesea continuar??")) {
                        $('.error').hide();
                        $(".frma").submit();
                    } else {
                        event.preventDefault();
                    }
                }
            });
        });

        function cedula(ci){
            var i = 1;
            var s = 0;
            var d = 0;
            while (i<10) {
                n = parseInt(ci.substring(i-1,i));
                if(i%2){
                    if((n*2) > 9) { s += n*2 -9;} else { s += n*2}
                } else {
                    s += n;
                }
                //alert("valor de s:" + s + " >> n:" + n);
                i++;
            }
            d = (90 - s) % 10;
            return d;
        };

    </script>


</body>
</html>
