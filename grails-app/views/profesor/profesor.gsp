<%@ page import="docentes.Periodo" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Profesor</title>
</head>


<div class="btn-toolbar toolbar">
    <div class="btn-group">
<g:link controller="profesor" action="list" class="btn btn-primary" title="Regresar a la lista de profesores">
    <i class="fa fa-chevron-left"></i> Lista
</g:link>
<a href="#" class="btn btn-success btnGuardar" >
    <i class="fa fa-save"></i> Guardar
</a>
<div class="btn-group">
    <g:link controller="profesor" action="profesor" class="btn btn-info">
        <i class="fa fa-file-o"></i> Nuevo
    </g:link>
</div>
</div>

</div>

<g:form class="form-horizontal" name="frmProfesor" role="form" action="save" method="POST">

    <div class="row">
        <div class="col-md-1 negrilla control-label">Facultad: </div>
        <div class="col-md-5">


            <g:if test="${session.perfil.codigo == 'ADMG'}">
                <g:select name="facultad" id="facultadId" optionKey="id" optionValue="nombre"
                          class="form-control" from="${docentes.Facultad.findAllByUniversidad(universidad).sort{it.nombre}}" value="${profesorInstance?.escuela?.facultad?.id}"/>
            </g:if>
            <g:else>
                <g:select from="${docentes.Facultad.findAllByUniversidad(docentes.Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id),[sort: 'nombre', order: 'asc'])}" optionValue="nombre"
                          optionKey="id" name="facultad" id="facultadId" class="form-control"/>
            </g:else>



        </div>
        <div class="col-md-1 negrilla control-label">Escuela: </div>
        <div class="col-md-5" id="divEscuela">

        </div>
    </div>


    <div class="row">
        <div class="col-md-1 negrilla control-label">Nombres: </div>
        <div class="col-md-5">
            <g:textField name="nombre_name" id="nombreProfesor" value="${profesorInstance ? profesorInstance?.nombre : ''}" class="form-control required" maxlength="31"/>
        </div>
        <div class="col-md-1 negrilla control-label">Apellidos: </div>
        <div class="col-md-5">
            <g:textField name="apellido_name" id="apellidoProfesor" value="${profesorInstance ? profesorInstance?.apellido : ''}" class="form-control required" maxlength="31"/>
        </div>
    </div>

    <div class="row">
        <div class="col-md-1 negrilla control-label">Cédula: </div>
        <div class="col-md-2">
            <g:textField name="cedula_name" id="cedulaProfesor" value="${profesorInstance ? profesorInstance?.cedula : ''}" class="form-control number required" maxlength="15"/>
        </div>
        <div class="col-md-1 negrilla control-label">Título: </div>
        <div class="col-md-2">
            <g:textField name="titulo_name" id="tituloProfesor" value="${profesorInstance ? profesorInstance?.titulo : ''}" class="allCaps form-control" maxlength="8"/>
        </div>
        <div class="col-md-1 negrilla control-label">Sexo: </div>
        <div class="col-md-2">
            <g:if test="${profesorInstance}">
                <g:select from="${[ 'M': 'Masculino', 'F': 'Femenino']}" name="sexo_name" id="sexoProfesor" class="form-control" value="${profesorInstance?.sexo == 'M' ? 'M' : 'F'}"  optionKey="key" optionValue="value"/>
            </g:if>
            <g:else>
                <g:select from="${[ 'M': 'Masculino', 'F': 'Femenino']}" name="sexo_name" id="sexoProfesor" class="form-control" value="${''}"  optionKey="key" optionValue="value"/>
            </g:else>
        </div>
        <div class="col-md-1 negrilla control-label">Evalua: </div>
        <div class="col-md-2">
            <g:if test="${profesorInstance}">
                <g:select from="${[ 'S':'Como directivo', 'P':'Como par', 'N':'Ninguno']}" name="evalua_name" id="evaluaProfesor"  optionValue="value" optionKey="key" class="form-control" value="${profesorInstance?.evaluar == 'S' ? 'S' : profesorInstance?.evaluar == 'P' ? 'P' : 'N'}" />
            </g:if>
            <g:else>
                <g:select from="${[ 'S':'Como directivo', 'P':'Como par', 'N':'Ninguno']}" name="evalua_name" id="evaluaProfesor"  optionValue="value" optionKey="key" class="form-control" value="" />
            </g:else>
        </div>
    </div>

    <div class="row">

    </div>

    <div class="row">
        <div class="col-md-1 negrilla control-label">Observaciones: </div>
        <div class="col-md-11">
            <g:textField name="name_observaciones" id="profesorObser" value="${profesorInstance ? profesorInstance?.observacion : ''}" class="form-control" style="resize: none" maxlength="127"/>

        </div>
    </div>


</g:form>

<div class="panel panel-info col-md-12 ${!profesorInstance ? 'hidden' : ''}" style="margin-top: 20px" >
    <div class="panel-heading">
        <h3 class="panel-title" style="height: 35px; padding-left: 110px; padding-right: 110px">
            <div class="col-md-4" style="float: left">
                Materias Asignadas para el período
            </div>

            <div class="col-md-4"> <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                             class="form-control" from="${Periodo.findAllByUniversidad(universidad).sort{it.nombre}}"/> </div>

            <div class="col-md-3" style="float: right" id="divCopiar">

            </div>
        </h3>
    </div>
    <div class="panel-body">
        <div class="list-group" style="text-align: center">

            <div class="row ${!profesorInstance ? 'hidden' : ''}" id="divMateria">
                <div class="col-md-1 negrilla control-label">Materias: </div>
                <div class="col-md-4" id="divMaterias">

                </div>
                <div class="col-md-1 negrilla control-label">Nivel: </div>
                <div class="col-md-2">
                    <g:select name="curso_name" id="cursoId" optionKey="id" optionValue="nombre"
                              class="form-control" from="${docentes.Curso.list([sort: 'nombre', order: 'asc'])}"/>
                </div>
                <div class="col-md-1 negrilla control-label">Paralelo: </div>
                <div class="col-md-1">
                    <g:textField name="paralelo_name" id="paraleloId" class="form-control number" maxlength="2"/>
                </div>
                <a href="#" id="btnAgregar" class="btn btn-success" title="Agregar materia ha ser dictada por el profesor">
                    <i class="fa fa-plus"></i> Agregar
                </a>
            </div>


            <table class="table table-condensed table-bordered table-striped ${!profesorInstance ? 'hidden' : ''}" style="margin-top: 10px">
                <thead>
                <tr>
                    <th style="width: 8%">Código</th>
                    <th style="width: 33%">Materia</th>
                    <th style="width: 14%">Curso</th>
                    <th style="width: 8%">Paralelo</th>
                    <th style="width: 25%">Escuela</th>
                    <th style="width: 5%">Acciones</th>

                </tr>
                </thead>
            </table>

            <div id="divTabla" class="${!profesorInstance ? 'hidden' : ''}">

            </div>

        </div>
    </div>
</div>


<script type="text/javascript">


    if('${profesorInstance}'){
        cargarComboMaterias('${profesorInstance?.id}');
    }

    function cargarComboMaterias (profesor) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'profesor',action: 'materias_ajax')}',
            data:{
                id: profesor
            },
            success: function (msg){
                $("#divMaterias").html(msg)
            }
        });
    }

    cargarTablaMaterias($("#periodoId").val());
    cargarBotonCopiar($("#periodoId").val());


    $("#periodoId").change(function () {
        var periodo = $(this).val();
        cargarTablaMaterias(periodo);
        cargarBotonCopiar(periodo)
    });


    function cargarTablaMaterias (periodo) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'profesor', action: 'tablaMaterias_ajax')}',
            data:{
                periodo: periodo,
                idProfe: '${profesorInstance?.id}'
            },
            success: function (msg) {
                $("#divTabla").html(msg)
            }
        });
    }


    function cargarBotonCopiar (periodo) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'profesor', action: 'copiar_ajax')}',
            data:{
                periodo: periodo,
                idProfe: '${profesorInstance?.id}'
            },
            success: function (msg) {
                $("#divCopiar").html(msg)
            }
        });
    }



    cargarEscuela($("#facultadId").val());

    function cargarEscuela (facultad) {
        $.ajax({
            type:'POST',
            url: '${createLink(controller: 'profesor', action: 'escuelaProfesor_ajax')}',
            data:{
                id: facultad,
                profe: '${profesorInstance?.id}'
            },
            success: function (msg){
                $("#divEscuela").html(msg)
            }
        })
    }



    $("#facultadId").change(function () {
        var facultad = $("#facultadId").val();
        cargarEscuela(facultad)
    });





    $(".btnGuardar").click(function () {
        var escuela = $("#escuelaId").val();
        var nombre = $("#nombreProfesor").val();
        var apellido = $("#apellidoProfesor").val();
        var cedula = $("#cedulaProfesor").val();
        var titulo = $("#tituloProfesor").val();
        var sexo = $("#sexoProfesor").val();
        var nacimiento = $("#nacimientoProfesor").val();
        var inicio = $("#inicioProfesor").val();
        var evalua = $("#evaluaProfesor").val();
        var observa = $("#profesorObser").val();
        var idProfesor = '${profesorInstance?.id}';

        var $form = $("#frmProfesor");
        if ($form.valid()) {
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'profesor', action: 'saveProfesor_ajax')}',
                data:{
                    escuela: escuela,
                    nombre: nombre,
                    apellido: apellido,
                    cedula: cedula,
                    titulo: titulo,
                    sexo: sexo,
                    nacimiento: nacimiento,
                    inicio: inicio,
                    evalua: evalua,
                    id: idProfesor,
                    observacion: observa
                },
                success: function (msg){
                    var parts = msg.split("_");
                    if(parts[0] == 'ok'){
                        log("Información guardada correctamente","success")
                        setTimeout(function () {
                            location.href='${createLink(controller: 'profesor', action: 'profesor')}/' + parts[1]
                        }, 500);
                    }else{
                        log("Error al guardar la información","error")
                    }

                }
            });
        }
    });


    $("#btnAgregar").click(function () {


        var materia = $("#materiasId").val();
        var curso = $("#cursoId").val();
        var paralelo = $("#paraleloId").val();
        var periodo = $("#periodoId").val();


        if(paralelo != ""){
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'profesor', action: 'agregarMateria_ajax')}',
                data:{
                    id: '${profesorInstance?.id}',
                    materia: materia,
                    curso: curso,
                    paralelo: paralelo,
                    periodo: periodo
                },
                success: function (msg){
                    var parts = msg.split("_");
                    if(parts[0] == 'ok'){
                        log(parts[1],"success");
                        cargarTablaMaterias($("#periodoId").val());
                    }else{
                        log(parts[1],"error")
                    }

                }
            });
        }else{
            log("Ingrese el paralelo","error");
        }

    });

    var validator = $("#frmProfesor").validate({
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