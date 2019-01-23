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

<g:if test="${profesorInstance?.estado != 'R'}">
    <a href="#" class="btn btn-success btnGuardar">
        <i class="fa fa-save"></i> Guardar
    </a>
</g:if>

<g:if test="${profesorInstance}">
    <g:if test="${profesorInstance?.estado == 'N'}">
        <a href="#" class="btn btn-info btnRegistrar" >
            <i class="fa fa-check"></i> Registrar
        </a>
    </g:if>
    <g:else>
        <a href="#" class="btn btn-warning btnDesRegistrar" >
            <i class="fa fa-check"></i> Desregistrar
        </a>
    </g:else>
</g:if>
</div>

</div>

<g:form class="form-horizontal" name="frmProfesor" role="form" action="save" method="POST">
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
        <div class="col-md-2" style="margin-left: 80px">
            <div class="col-md-12">
                <label>Cédula</label>
                <g:textField name="cedula_name" id="cedulaProfesor" value="${profesorInstance ? profesorInstance?.cedula : ''}" class="form-control number required" maxlength="15"/>
            </div>
        </div>
        <div class="col-md-2">
            <div class="col-md-12">
                <label>Título</label>
                <g:textField name="titulo_name" id="tituloProfesor" value="${profesorInstance ? profesorInstance?.titulo : ''}" class="form-control" maxlength="125" title="${profesorInstance?.titulo}"/>
            </div>
        </div>
        <div class="col-md-3">
            <div class="col-md-12">
                <label>Email</label>
                <g:textField name="mail_name" id="mailProfesor" value="${profesorInstance ? profesorInstance?.mail : ''}" class="email mail form-control" maxlength="62"/>
            </div>
        </div>
        <div class="col-md-2">
            <div class="col-md-12">
                <label>Sexo</label>
                <g:if test="${profesorInstance}">
                    <g:select from="${[ 'M': 'Masculino', 'F': 'Femenino']}" name="sexo_name" id="sexoProfesor" class="form-control" value="${profesorInstance?.sexo == 'M' ? 'M' : 'F'}"  optionKey="key" optionValue="value"/>
                </g:if>
                <g:else>
                    <g:select from="${[ 'M': 'Masculino', 'F': 'Femenino']}" name="sexo_name" id="sexoProfesor" class="form-control" value="${''}"  optionKey="key" optionValue="value"/>
                </g:else>
            </div>
        </div>
        <div class="col-md-2">
            <div class="col-md-12">
                <label>Evalua</label>
                <g:if test="${profesorInstance}">
                    <g:select from="${[ 'S':'Como directivo', 'P':'Como par', 'N':'Ninguno']}" name="evalua_name" id="evaluaProfesor"  optionValue="value" optionKey="key" class="form-control" value="${profesorInstance?.evaluar == 'S' ? 'S' : profesorInstance?.evaluar == 'P' ? 'P' : 'N'}" />
                </g:if>
                <g:else>
                    <g:select from="${[ 'S':'Como directivo', 'P':'Como par', 'N':'Ninguno']}" name="evalua_name" id="evaluaProfesor"  optionValue="value" optionKey="key" class="form-control" value="" />
                </g:else>
            </div>
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

<div class="panel panel-info col-md-12 ${!profesorInstance ? 'hidden' : ''}" style="margin-top: 10px" >
    <div class="panel-heading">
        <h3 class="panel-title" style="height: 100px; padding-left: 10px; padding-right: 10px">
            <div class="col-md-3" style="float: left">
                Materias Asignadas para:
            </div>

            <g:if test="${session.perfil.codigo == 'ADMG'}">
                <div class="col-md-2"><b>Universidad</b></div>
                <div class="col-md-4">
                    <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                              class="form-control" from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}"/>
                </div>
            </g:if>
            <g:else>
                <div class="col-md-2"><b>Universidad</b></div>
                <div class="col-md-4">
                    <g:select name="universidad_name" id="universidadId" optionKey="id" optionValue="nombre"
                              class="uni form-control" from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}" value="${seguridad.Persona.get(session.usuario.id)?.universidad?.id}"/>
                </div>
            </g:else>

            <div class="col-md-1"><b>Período</b></div>
            <div class="col-md-2" id="divPeriodo" style="margin-bottom: 10px">

            </div>

            <div class="row">
                <div class="col-md-1 negrilla control-label">Facultad</div>

                <div class="col-md-4" id="divFacultad">
                </div>

                <div class="col-md-1 negrilla control-label">Escuela</div>
                <div class="col-md-5" id="divEscuela">

                </div>
            </div>

            %{--<div class="col-md-3" style="float: right" id="divCopiar">--}%

            %{--</div>--}%
        </h3>
    </div>
    <div class="panel-body">
        <div class="list-group" style="text-align: center">

            <div class="row ${!profesorInstance ? 'hidden' : ''}" id="divMateria">

                <div class="col-md-1 negrilla control-label">Materia: </div>
                <div class="col-md-4" id="divMaterias">
                    <g:hiddenField name="materiaId_name" id="materiaId" value=""/>
                    <g:textField name="materias_name" id="materiasProfesor" class="form-control" readonly=""/>
                </div>
                <div class="col-md-1">
                    <a href="#" class="btn btn-info" id="btnBuscarMateria"><i class="fa fa-search"></i> Buscar</a>

                </div>

                <div class="col-md-1 negrilla control-label">Nivel: </div>
                <div class="col-md-1">
                    <g:select name="curso_name" id="cursoId" optionKey="id" optionValue="nombre"
                              class="form-control" from="${docentes.Curso.list([sort: 'nombre', order: 'asc'])}" style="width: 90px"/>
                </div>

                <div class="col-md-1 negrilla control-label">Paralelo: </div>
                <div class="col-md-1">
                    <g:textField name="paralelo_name" id="paraleloId" class="form-control number" maxlength="2"/>
                </div>
                <div class="col-md-1">
                    <a href="#" id="btnAgregar" class="btn btn-success" title="Agregar materia ha ser dictada por el profesor">
                        <i class="fa fa-plus"></i> Agregar
                    </a>
                </div>
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

    <g:if test="${session.perfil.codigo != 'ADMG'}">
    $(".uni").attr("disabled", true);
    </g:if>


    $("#btnBuscarMateria").click(function () {
        var escuela = $("#escuelaId option:selected").val();

        if(escuela){
            $.ajax({
                type:'POST',
                url:'${createLink(controller: 'profesor', action: 'materias_ajax')}',
                data:{
                    escuela: escuela
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
        }else{
            log("Seleccione una escuela","error")
        }
    });

    function cargarFacultad (id) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'reportesGraf', action: 'facultadSel_ajax')}',
            data:{
                universidad: id
            },
            success: function (msg){
                $("#divFacultad").html(msg)
            }
        });
    }

    <g:if test="${profesorInstance}">
    cargarPeriodo($("#universidadId option:selected").val());
    cargarFacultad($("#universidadId option:selected").val());
    </g:if>


    $("#universidadId").change(function () {
        var universidad = $("#universidadId option:selected").val();
        cargarPeriodo(universidad);
        cargarFacultad(universidad);
        cargarTablaMaterias($("#periodo option:selected").val(), universidad);
    });

    function cargarPeriodo (universidad) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'profesor', action: 'periodo_ajax')}',
            async: false,
            data:{
                universidad: universidad
            },
            success: function (msg){
                $("#divPeriodo").html(msg)
            }
        });
    }

    $(".btnRegistrar").click(function () {
        cambiarEstado(1);
    });

    $(".btnDesRegistrar").click(function () {
        cambiarEstado(2);
    });

    function cambiarEstado (tipo) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'profesor', action: 'registrar_ajax')}',
            data:{
                id: '${profesorInstance?.id}',
                tipo: tipo
            },
            success: function (msg){
                var parts = msg.split("_");
                if(parts[0] == 'ok'){
                    log(parts[2], "success");
                    setTimeout(function () {
                        location.href='${createLink(controller: 'profesor', action: 'profesor')}?id=' + parts[1]
                    }, 700);
                }else{
                    log("Error al cambiar de estado","error")
                }
            }
        })
    }

    cargarTablaMaterias($("#periodo option:selected").val(), $("#universidadId option:selected").val());
    //    cargarBotonCopiar($("#periodoId").val());


    $("#periodo").change(function () {
        cargarTablaMaterias($("#periodo option:selected").val(), $("#universidadId option:selected").val());
        //        cargarBotonCopiar(periodo)
    });


    function cargarTablaMaterias (periodo, universidad) {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'profesor', action: 'tablaMaterias_ajax')}',
            data:{
                periodo: periodo,
                idProfe: '${profesorInstance?.id}',
                universidad: universidad
            },
            success: function (msg) {
                $("#divTabla").html(msg)
            }
        });
    }


    %{--function cargarBotonCopiar (periodo) {--}%
    %{--$.ajax({--}%
    %{--type: 'POST',--}%
    %{--url: '${createLink(controller: 'profesor', action: 'copiar_ajax')}',--}%
    %{--data:{--}%
    %{--periodo: periodo,--}%
    %{--idProfe: '${profesorInstance?.id}'--}%
    %{--},--}%
    %{--success: function (msg) {--}%
    %{--$("#divCopiar").html(msg)--}%
    %{--}--}%
    %{--});--}%
    %{--}--}%



    %{--cargarEscuela($("#facultadId").val());--}%

    %{--function cargarEscuela (facultad) {--}%
    %{--$.ajax({--}%
    %{--type:'POST',--}%
    %{--url: '${createLink(controller: 'profesor', action: 'escuelaProfesor_ajax')}',--}%
    %{--data:{--}%
    %{--id: facultad,--}%
    %{--profe: '${profesorInstance?.id}'--}%
    %{--},--}%
    %{--success: function (msg){--}%
    %{--$("#divEscuela").html(msg)--}%
    %{--}--}%
    %{--})--}%
    %{--}--}%



    //    $("#facultadId").change(function () {
    //        var facultad = $("#facultadId").val();
    //        cargarEscuela(facultad)
    //    });



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
        var mail = $("#mailProfesor").val();

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
                    observacion: observa,
                    mail: mail
                },
                success: function (msg){
                    var parts = msg.split("_");
                    if(parts[0] == 'ok'){
                        log(parts[1],"success");
                        setTimeout(function () {
                            location.href='${createLink(controller: 'profesor', action: 'profesor')}?id=' + parts[2]
                        }, 500);
                    }else{
                        log(parts[1],"error")
                    }

                }
            });
        }
    });


    $("#btnAgregar").click(function () {

        var materia = $("#materiaId").val();
        var curso = $("#cursoId option:selected").val();
        var paralelo = $("#paraleloId").val();
        var periodo = $("#periodo option:selected").val();
        var escuela = $("#escuelaId option:selected").val();

        if(escuela){
            if(materia){
                if(curso){
                    if(paralelo){
                        $.ajax({
                            type: 'POST',
                            url: '${createLink(controller: 'profesor', action: 'agregarMateria_ajax')}',
                            data:{
                                profesor: '${profesorInstance?.id}',
                                materia: materia,
                                curso: curso,
                                paralelo: paralelo,
                                periodo: periodo,
                                escuela: escuela
                            },
                            success: function (msg){
                                var parts = msg.split("_");
                                if(parts[0] == 'ok'){
                                    log(parts[1],"success");
//                                   cargarTablaMaterias(periodo, $("#universidadId option:selected").val());
                                    setTimeout(function () {
                                        location.reload(true)
                                    }, 800);
                                }else{
                                    log(parts[1],"error")
                                }
                            }
                        });
                    }else{
                        log("Ingrese el paralelo","error");
                    }
                }else{
                    log("Seleccione un nivel","error")
                }
            }else{
                log("Seleccione una materia","error")
            }

        }else{
            log("Seleccione una escuela","error")
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