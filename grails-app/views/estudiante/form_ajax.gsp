<%@ page import="docentes.Estudiante" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!estudianteInstance}">
    <elm:notFound elem="Estudiante" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmEstudiante" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${estudianteInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: estudianteInstance, field: 'cedula', 'error')} ">
            <span class="grupo">
                <label for="cedula" class="col-md-2 control-label text-info">
                    Cédula
                </label>
                <div class="col-md-6">
                    <g:textField name="cedula" required="" class="allCaps form-control required" value="${estudianteInstance?.cedula}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: estudianteInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-10">
                    <g:textField name="nombre" maxlength="31" required="" class="allCaps form-control required" value="${estudianteInstance?.nombre}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: estudianteInstance, field: 'apellido', 'error')} ">
            <span class="grupo">
                <label for="apellido" class="col-md-2 control-label text-info">
                    Apellido
                </label>
                <div class="col-md-10">
                    <g:textField name="apellido" maxlength="31" required="" class="allCaps form-control required" value="${estudianteInstance?.apellido}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
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
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>