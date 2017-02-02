<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="layout" content="main_q" />
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

    .logotipo{
        max-width: 20%;
        /*height: auto;*/
    }

    @media (min-width: @screen-sm-min) {

        .h1-sm,
        .h2-sm,
        .h3-sm {
            margin-top: @line-height-computed;
            margin-bottom: (@line-height-computed / 2);

        small,
        .small {
            font-size: 85%;
        }
    }

    .h4-sm,
    .h5-sm,
    .h6-sm {
        margin-top: (@line-height-computed / 2);
        margin-bottom: (@line-height-computed / 2);

    small,
    .small {
        font-size: 75%;
    }
    }

    .h1-sm { font-size: @font-size-h1; }
    .h2-sm { font-size: @font-size-h2; }
    .h3-sm { font-size: @font-size-h3; }
    .h4-sm { font-size: @font-size-h4; }
    .h5-sm { font-size: @font-size-h5; }
    .h6-sm { font-size: @font-size-h6; }
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
        <div><img src="${resource(dir:'images',file:'universidad.jpeg')}" class="logotipo"></div>
        <h3 class="logo_tx"><h1 class="entry-title post-title h2 h1-sm" itemprop="name">${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}</h1>
            <h4>Sistema para uso exclusivo de la esta Universidad</h4>
        <div class="col-md-6 col-xs-12 center-block" style="float: inherit; margin: auto">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <span class="panel-title">Ingrese sus datos personales</span>
                </div>
            <div class="panel-body">
                <g:form action="ingreso" method="post" class="frma">
                    <input type="hidden" hidden name="tipo" id="tipoIf" value="">
                    <fieldset>
                        <div style="margin-top: 10px;">
                            %{--<label class="col-md-6 col-xs-6">Cédula de Identidad:</label>--}%
                            <div class="col-md-6 col-xs-6 negrilla control-label">Cédula de Identidad:</div>
                            <div class=" col-md-6 col-xs-6">
                                <g:textField name="cdla" class="form-control required cedula" maxlength="15" size="20"/>
                            </div>
                            %{--<input class="col-md-6 col-xs-6 cedula" type="text" name="cdla" maxlength="15" size="20">--}%
                            <br><span class="error ">Verifique el número de su cédula de identidad</span>
                        </div>
                        <div style="margin-top: 6%;" class="col-md-12 col-xs-12 center-block">
                            <input class="btn btn-primary submit col-md-6 col-xs-6" value="Soy Docente" tipo="P">
                            <input class="btn btn-info submit col-md-5 col-xs-5" value="Soy Estudiante" tipo="E" style="margin-left: 20px">
                        </div>
                    </fieldset>
                    </div>
                </g:form>
            </div>
        </div>
            <div class="col-md-12 col-xs-12"> Desarrollado por: TEDEIN SA &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="http://www.tedein.com.ec">www.tedein.com.ec</a></div>

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

                    bootbox.confirm({
                        title: "Alerta Cédula",
                        message: "El número de cédula ingresado no es ECUATORIANO<h5>¿Desea continuar?</h5>",
                        buttons: {
                            cancel: {
                                label: '<i class="fa fa-times"></i> Cancelar'
                            },
                            confirm: {
                                label: '<i class="fa fa-check"></i> Aceptar',
                                className: 'btn-success'
                            }
                        },
                        callback: function (result) {
                            if(result) {
//                                $('.error').hide();
                                $(".frma").submit();
                            }
                        }
                    });

/*
                    if (confirm("El número de cédula ingresado no es ECUATORIANO\nDesea continuar??")) {
                        $('.error').hide();
                        $(".frma").submit();
                    } else {
                        event.preventDefault();
                    }
*/
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
