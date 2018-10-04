<%@ page contentType="text/html;charset=UTF-8" %>

<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="layout" content="main_q" />
    <title>Quanto Docentes</title>

    <style>
        .pie{
            background: #d0d0d0;
            width: 100%;
            height: 20px;
            font-family: serif;
            font-style: italic;
            font-size: 10pt;
            text-align: center;
            z-index: 2;
            margin-top: -15px;
        }
        th {
            text-align: center;
            background-color: #3d4854;
            color: #ffab19;
        }
        .alinear {
            text-align: center !important;
        }

        #buscar {
            width: 400px;
            border-color: #0c6cc2;
        }

        #limpiaBuscar {
            position: absolute;
            right: 5px;
            top: 0;
            bottom: 0;
            height: 14px;
            margin: auto;
            font-size: 14px;
            cursor: pointer;
            color: #ccc;
        }
        .logotipo{
            max-width: 20%;
        }
    </style>
</head>
<body>
<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div style="text-align: center;">
    %{--Para personalizar: UNACH: universidad1.jpg, UPEC universidad.jpg y en messages_es.properties la universidad--}%

    <div style="text-align: center;">
        %{--Para personalizar: UNACH: universidad1.jpg, UPEC universidad.jpg y en messages_es.properties la universidad--}%
        <div class="contenedor">
            <div><img src="${logo}" class="logotipo"></div>
            %{--<h3 class="logo_tx"><h1 class="entry-title post-title h2 h1-sm" itemprop="name">${message(code: 'universidad', default: 'Tedein S.A. - Pruebas')}</h1>--}%
            <h3 class="logo_tx"><h1 class="entry-title post-title h2 h1-sm" itemprop="name">${universidad}</h1>
                %{--<h4>Sistema para uso exclusivo de la esta Universidad</h4>--}%
        </div>
    </div>


%{--
    <div class="contenedor">
        <h1>${titulo}</h1>
    </div>
--}%
        %{--<br>Sistema para uso exclusivo de la esta Universidad</div>--}%
    <p class="bs-component">
        <span class="btn btn-primary btn-md btn-block disabled" style="cursor: default; color: #ffffc0 ">
            <strong>Usted se ha identificado como ${session.informante}</strong></span>
    </p>

    <hr>
    %{--<div style="margin-top: 10px"></div>--}%

    <div style="margin-top: 0px; min-height: 50px" class="vertical-container">
        <p class="css-vertical-text">Buscar</p>

        <div class="linea"></div>

        <div>

            <div class="col-md-12" style="margin-top: -10px;">
                <a href="${g.createLink(action: 'inicio')}" class="btn btn-danger" title="Retornar a la pantalla inicial de Evaluaciones"
                   style="margin-left: -80px">
                    <i class="fa fa-arrow-left"></i>
                    Cancelar</a>
                <span style="margin-left: 60px;">Buscar el profesor a evaluar:</span>

                <div class="btn-group">
                    <input id="buscar" type="search" class="form-control"
                           placeholder="Escriba parte del nombre o del apellido del docente">
                    <span id="limpiaBuscar" class="glyphicon glyphicon-remove-circle"
                          title="Limpiar texto de búsqueda"></span>
                </div>
                <a href="#" name="busqueda" class="btn btn-info btn-ajax" id="btnBusqueda"><i
                        class="fa fa-check-square-o"></i> Buscar</a>
            </div>
        </div>
    </div>

    <div style="margin-top: 30px; min-height: 350px; overflow-y: auto; width: auto" class="vertical-container">
    %{--<div style="margin-top: 30px; min-height: 350px; overflow-y: auto" class="vertical-container">--}%
        <p class="css-vertical-text">Profesores

        <div class="linea"></div>
        %{--<table class="table table-bordered table-hover table-condensed" style="width: 1070px">--}%
        <table class="table table-bordered table-hover table-condensed" style="width: 100%">
            <thead>
            <tr>
                <th class="alinear" style="width: 30%">Profesor</th>  %{--360--}%
                <th class="alinear" style="width: 40%">Materia</th>   %{--400--}%
                <th class="alinear" style="width: 16%">Curso</th>     %{--160--}%
                <th class="alinear" style="width: 7%">Paralelo</th>   %{--70--}%
                <th class="alinear" style="width: 7%">Evaluar</th>    %{--70--}%
            </tr>
            </thead>
        </table>

        <div id="profesores">
        </div>
    </div>

    <div><strong>Nota</strong>: Si existen muchos docentes  que coinciden con el criterio de búsqueda, se retorna como máximo 20
    </div>

    <div class="modal fade " id="dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    %{--<h4 class="modal-title">Problema y Solución</h4>--}%
                    Profesores ...
                </div>

                <div class="modal-body" id="dialog-body" style="padding: 15px">

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">Cerrar</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>
    <hr style="border-color: #0A246A; size: 2px"/>
    <div class="pie"> Desarrollado por: TEDEIN SA &nbsp;&nbsp;&nbsp;&nbsp;<a target="_blank" href="http://www.tedein.com.ec">www.tedein.com.ec</a></div>

</div>

<script type="text/javascript" src="${resource(dir:'js/jquery/js',file:'jquery-1.4.2.min.js')}"></script>
<script type="text/javascript">
    $("#btnBusqueda").click(function () {
        $("#bandeja").html("").append($("<div style='width:100%; text-align: center;'/>").append(spinnerSquare64));
        var buscar = $("#buscar").val();

        var datos = "buscar=" + buscar;

        $.ajax({
            type: "POST",
            url: "${g.createLink(action: 'tablaProfesores')}",
            data: datos,
            success: function (msg) {
                $("#profesores").html(msg);
            },
            error: function (msg) {
                $("#profesores").html("Ha ocurrido un error");
            }
        });

    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            $("#btnBusqueda").click();
        }
    });

    $("#limpiaBuscar").click(function(){
        $("#buscar").val('');
    })


</script>


</body>
</html>
