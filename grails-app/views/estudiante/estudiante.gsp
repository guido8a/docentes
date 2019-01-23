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
        <a href="#" class="btn btn-success btnGuardarEst" >
            <i class="fa fa-save"></i> Guardar
        </a>
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

            <div class="col-md-12">
                <g:if test="${session.perfil.codigo == 'ADMG'}">
                    <div class="col-sm-3 row" style="text-align: right">
                        Universidad
                    </div>

                    <div class="col-sm-6">
                        <g:select name="universidad_name" id="universidadE" optionKey="id" optionValue="nombre"
                                  class="form-control"
                                  from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
                    </div>
                    <div class="col-md-1">Período:</div>
                </g:if>
                <g:else>
                    <div class="col-sm-3 row" style="text-align: right">
                        Universidad
                    </div>

                    <div class="col-sm-6">
                        <g:select name="universidad_name" id="universidadE" optionKey="id" optionValue="nombre"
                                  class="form-control" from="${seguridad.Persona.get(session.usuario.id)?.universidad}"/>
                    </div>

                    <div class="col-md-1">Periodo:</div>

                </g:else>

                <div class="col-md-2" id="divPeriodos">

                </div>
            </div>
        </h3>

        <div class="row text-info" style="font-size: 11pt; margin-bottom: 20px">
            <div class="col-md-1">Facultad</div>
            <div class="col-md-5" id="divFacultad">

            </div>

            <div class="col-md-1">Escuela</div>
            <div class="col-md-5" id="divEscuela1">

            </div>
        </div>
    </div>
    <div class="panel-body">
        <div class="list-group" style="text-align: center">


            <div class="row ${!estudianteInstance ? 'hidden' : ''}" id="divMateria">

                <div class="col-md-1 negrilla control-label">Materia: </div>
                <div class="col-md-5" id="divMaterias">
                    <g:hiddenField name="materiaId_name" id="materiaId" value=""/>
                    <g:textField name="materias_name" id="materiasEstudiante" class="form-control" readonly=""/>
                </div>
                <div class="col-md-1">
                    <a href="#" class="btn btn-info" id="btnBuscarMateria"><i class="fa fa-search"></i> Buscar</a>
                </div>

                <div class="col-md-1 negrilla control-label">Nivel: </div>
                <div class="col-md-1">
                    <g:select name="curso_name" id="cursoE" optionKey="id" optionValue="nombre"
                              class="form-control" from="${docentes.Curso.list([sort: 'nombre', order: 'asc'])}" style="width: 90px"/>
                </div>

                <div class="col-md-2">
                    <a href="#" id="btnMatricular" class="btn btn-success" title="Matricular el alumno en una materia">
                        <i class="fa fa-plus"></i> Agregar
                    </a>
                </div>
            </div>

            <div class="col-md-4"></div>
            <div class="col-md-5" style="text-align: center; margin-top: 10px; color: #3f71ba">
                <label style="font-size: 16px">Materias en las cuales está matriculado el alumno</label>
            </div>
            <table class="table table-condensed table-bordered table-striped" style="margin-top: 10px">
                <thead>
                <tr>
                    <th style="width: 7%">Código</th>
                    <th style="width: 36%">Materia</th>
                    <th style="width: 5%">Curso</th>
                    <th style="width: 5%">Paralelo</th>
                    <th style="width: 29%">Profesor</th>
                    <th style="width: 16%">Escuela</th>
                    <th style="width: 10%"><i class="fa fa-trash-o"></i></th>
                    <th style="width: 2%"></th>
                </tr>
                </thead>
            </table>

            <div id="divTabla" class="${!estudianteInstance ? 'hidden' : ''}">

            </div>

        </div>
    </div>
</div>


<script type="text/javascript">


    $("#btnMatricular").click(function () {

        var idDicta = $("#materiaId").val();
        var curso = $("#cursoE option:selected").val();

        if(idDicta){
            if(curso){
                $.ajax({
                    type    : "POST",
                    url     : '${createLink(controller: 'estudiante', action:'saveAsignarMateria_ajax')}',
                    data    : {
                        dicta : idDicta,
                        estudiante: '${estudianteInstance?.id}',
                        curso: curso
                    },
                    success : function (msg) {
                        if (msg == "ok") {
                            log("Materia agregada correctamente","success");
                            setTimeout(function () {
                                $("#materiaId").val('');
                                $("#materiasEstudiante").val('');
                                cargarMatriculados($("#periodoE option:selected").val(),$("#escuelaE option:selected").val());
                            }, 1000)
                        }else{
                            log("Error al agregar la materia","error");
                        }
                    }
                });
            }else{
                log("Seleccione un curso","error")
            }
        }else{
            log("Seleccione una materia","error")
        }
    });


    $("#btnBuscarMateria, #materiasEstudiante").click(function () {
        var periodo = $("#periodoE option:selected").val();
        var escuela = $("#escuelaE option:selected").val();
        $.ajax({
            type:'POST',
            url:'${createLink(controller: 'estudiante', action: 'materias_ajax')}',
            data:{
                estudiante: '${estudianteInstance?.id}',
                escuela: escuela,
                periodo: periodo
            },
            success: function (msg){
                var b = bootbox.dialog({
                    id: "dlgMaterias",
                    title: 'Materias',
                    class: 'long',
                    message: msg,
                    buttons: {
                        cancelar: {
                            label: "Cancelar",
                            className: "btn-primary",
                            callback: function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });

    cargarPeriodo($("#universidadE").val());
    cargarFacultad($("#universidadE").val());

    $("#universidadE").change(function () {
        var id = $("#universidadE option:selected").val();
        cargarPeriodo(id);
        cargarFacultad(id);
        cargarMatriculados($("#periodoE option:selected").val(),$("#escuelaE option:selected").val());
    });

    function cargarPeriodo(id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'estudiante', action: 'periodo_ajax')}',
            async:false,
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divPeriodos").html(msg)
            }
        });
    }

    function cargarFacultad (id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'estudiante', action: 'facultad_ajax')}',
            async:false,
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divFacultad").html(msg)
            }
        });
    }


    if('${estudianteInstance}'){
        cargarMatriculados($("#periodoE option:selected").val(),$("#escuelaE option:selected").val());
    }

    function  cargarMatriculados(perA, escA){
        $.ajax ({
            type: 'POST',
            url: '${createLink(controller: 'materia', action: 'tablaMateriasAsignadas_ajax')}',
            async:false,
            data:{
                periodo: perA,
                id: '${estudianteInstance?.id}',
                escuela: escA
            },
            success: function (msg){
                $("#divTabla").html(msg)
            }
        });
    }

    $(".btnGuardarEst").click(function () {
        var nombre = $("#nombreEstudiante").val();
        var apellido = $("#apellidoEstudiante").val();
        var cedula = $("#cedulaEstudiante").val();
        var idEstudiante = '${estudianteInstance?.id}';

        var $form = $("#frmEstudiante");
        if ($form.valid()) {
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'estudiante', action: 'saveEstudiante_ajax')}',
                data:{
                    nombre: nombre,
                    apellido: apellido,
                    cedula: cedula,
                    id: idEstudiante
                },
                success: function (msg){
                    var parts = msg.split("_");
                    if(parts[0] == 'ok'){
                        log(parts[1],"success");
                        setTimeout(function () {
                            location.href='${createLink(controller: 'estudiante', action: 'estudiante')}?id=' + parts[2]
                        }, 500);
                    }else{
                        log(parts[1],"error")
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