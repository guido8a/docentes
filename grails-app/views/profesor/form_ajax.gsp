<%@ page import="docentes.Profesor" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!profesorInstance}">
    <elm:notFound elem="Profesor" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmProfesor" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${profesorInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'cedula', 'error')} ">
            <span class="grupo">
                <label for="cedula" class="col-md-2 control-label text-info">
                    Cedula
                </label>
                <div class="col-md-6">
                    <g:textField name="cedula" required="" class="allCaps form-control required" value="${profesorInstance?.cedula}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" maxlength="31" required="" class="allCaps form-control required" value="${profesorInstance?.nombre}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'apellido', 'error')} ">
            <span class="grupo">
                <label for="apellido" class="col-md-2 control-label text-info">
                    Apellido
                </label>
                <div class="col-md-6">
                    <g:textField name="apellido" maxlength="31" required="" class="allCaps form-control required" value="${profesorInstance?.apellido}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'estado', 'error')} ">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label text-info">
                    Estado
                </label>
                <div class="col-md-6">
                    <g:textField name="estado" class="allCaps form-control" value="${profesorInstance?.estado}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'evaluar', 'error')} ">
            <span class="grupo">
                <label for="evaluar" class="col-md-2 control-label text-info">
                    Evaluar
                </label>
                <div class="col-md-6">
                    <g:textField name="evaluar" class="allCaps form-control" value="${profesorInstance?.evaluar}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'fechaFin', 'error')} ">
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label text-info">
                    Fecha Fin
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaFin"  class="datepicker form-control required" value="${profesorInstance?.fechaFin}"  />
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'fechaInicio', 'error')} ">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label text-info">
                    Fecha Inicio
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control required" value="${profesorInstance?.fechaInicio}"  />
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'fechaNacimiento', 'error')} ">
            <span class="grupo">
                <label for="fechaNacimiento" class="col-md-2 control-label text-info">
                    Fecha Nacimiento
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaNacimiento"  class="datepicker form-control required" value="${profesorInstance?.fechaNacimiento}"  />
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'observacion', 'error')} ">
            <span class="grupo">
                <label for="observacion" class="col-md-2 control-label text-info">
                    Observacion
                </label>
                <div class="col-md-6">
                    <g:textField name="observacion" class="allCaps form-control" value="${profesorInstance?.observacion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'sexo', 'error')} ">
            <span class="grupo">
                <label for="sexo" class="col-md-2 control-label text-info">
                    Sexo
                </label>
                <div class="col-md-6">
                    <g:textField name="sexo" class="allCaps form-control" value="${profesorInstance?.sexo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: profesorInstance, field: 'titulo', 'error')} ">
            <span class="grupo">
                <label for="titulo" class="col-md-2 control-label text-info">
                    Titulo
                </label>
                <div class="col-md-6">
                    <g:textField name="titulo" class="allCaps form-control" value="${profesorInstance?.titulo}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
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
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>