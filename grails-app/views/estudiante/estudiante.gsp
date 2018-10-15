<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Estudiante</title>
</head>


<body>


<div class="btn-toolbar toolbar">
    <div class="btn-group">
        <g:link controller="estudiante" action="list" class="btn btn-primary" title="Regresar a la lista de estudiantes">
            <i class="fa fa-chevron-left"></i> Lista
        </g:link>
        <a href="#" class="btn btn-success btnGuardar" >
            <i class="fa fa-save"></i> Guardar
        </a>
        %{--<div class="btn-group">--}%
            %{--<g:link controller="estudiante" action="estudiante" class="btn btn-info">--}%
                %{--<i class="fa fa-file-o"></i> Nuevo--}%
            %{--</g:link>--}%
        %{--</div>--}%
    </div>

</div>

<g:form class="form-horizontal" name="frmEstudiante" role="form" action="save" method="POST">

    <div class="row">
        <div class="col-md-1 negrilla control-label">Cédula: </div>
        <div class="col-md-2">
            <g:textField name="cedula_name" id="cedulaEstudiante" value="${estudianteInstance ? estudianteInstance?.cedula : ''}" class="form-control number required" maxlength="31"/>
        </div>
        <div class="col-md-1 negrilla control-label">Nombres: </div>
        <div class="col-md-3">
            <g:textField name="nombre_name" id="nombreEstudiante" value="${estudianteInstance ? estudianteInstance?.nombre : ''}" class="form-control required" maxlength="31"/>
        </div>
        <div class="col-md-1 negrilla control-label">Apellidos: </div>
        <div class="col-md-3">
            <g:textField name="apellido_name" id="apellidoEstudiante" value="${estudianteInstance ? estudianteInstance?.apellido : ''}" class="form-control required" maxlength="31"/>
        </div>

    </div>

</g:form>

<div class="panel panel-info col-md-12 ${!estudianteInstance ? 'hidden' : ''}" style="margin-top: 20px" >
    <div class="panel-heading">
        <h3 class="panel-title" style="height: 35px; padding-left: 10px; padding-right: 110px">
            <div class="col-md-7" style="float: left">
                Materias en las cuales está matriculado el alumno para el período
            </div>

            <div class="col-md-4">
                <g:if test="${session.perfil.codigo == 'ADMG'}">
                    <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                              class="form-control" from="${periodo}"/>
                </g:if>
                <g:else>
                    <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                              class="form-control" style="width: 90px"
                              from="${docentes.Periodo.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)).sort{it.nombre}}"/>
                </g:else>
            </div>

            <div class="col-md-3" style="float: right" id="divCopiar">

            </div>
        </h3>
    </div>
    <div class="panel-body">
        <div class="list-group" style="text-align: center">

            <div class="row"  id="divMateria">
                <div class="col-md-1 negrilla control-label">Materias: </div>
                <div class="col-md-9" id="divMaterias">

                </div>
            </div>
            <table class="table table-condensed table-bordered table-striped" style="margin-top: 10px">
                <thead>
                <tr>
                    <th style="width: 7%">Código</th>
                    <th style="width: 28%">Materia</th>
                    <th style="width: 11%">Curso</th>
                    <th style="width: 8%">Paralelo</th>
                    <th style="width: 20%">Profesor</th>
                    <th style="width: 8%">Escuela</th>
                    <th style="width: 5%">Acciones</th>

                </tr>
                </thead>
            </table>

            <div id="divTabla" class="${!estudianteInstance ? 'hidden' : ''}">

            </div>

        </div>
    </div>
</div>


<script type="text/javascript">


    $("#periodoId").change(function () {
        var per = $(this).val();
        cargarMaterias(per);
        cargarMatriculados(per)
    });

    if('${estudianteInstance}'){
        cargarMaterias($("#periodoId").val());
        cargarMatriculados($("#periodoId").val());
    }

    function cargarMaterias (periodo){
        $.ajax ({
            type: 'POST',
            url: '${createLink(controller: 'estudiante', action: 'materias_ajax')}',
            data:{
                periodo: periodo,
                id: '${estudianteInstance?.id}'
            },
            success: function (msg){
                $("#divMaterias").html(msg)
            }
        });
    }

    function  cargarMatriculados(periodo){
        $.ajax ({
            type: 'POST',
            url: '${createLink(controller: 'materia', action: 'tablaMateriasAsignadas_ajax')}',
            data:{
                periodo: periodo,
                id: '${estudianteInstance?.id}'
            },
            success: function (msg){
                $("#divTabla").html(msg)
            }
        });
    }

    $(".btnGuardar").click(function () {
        var nombre = $("#nombreEstudiante").val();
        var apellido = $("#apellidoEstudiante").val();
        var cedula = $("#cedulaEstudiante").val();
        var idEstudiante = '${estudianteInstance?.id}';
        var univ = ${universidad?.id};

        var $form = $("#frmEstudiante");
        if ($form.valid()) {
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'estudiante', action: 'saveEstudiante_ajax')}',
                data:{
                    nombre: nombre,
                    apellido: apellido,
                    cedula: cedula,
                    id: idEstudiante,
                    universidad: univ
                },
                success: function (msg){
                    var parts = msg.split("_");
                    if(parts[0] == 'ok'){
                        log("Información guardada correctamente","success");
                        setTimeout(function () {
                            location.href='${createLink(controller: 'estudiante', action: 'estudiante')}?id=' + parts[1] + '&universidad=' + parts[2]
                        }, 500);
                    }else{
                        log("Error al guardar la información","error")
                    }

                }
            });
        }
    });


    var validator = $("#frmEstudiante").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        }
    });

</script>


</body>
</html>