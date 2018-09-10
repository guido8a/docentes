<%@ page import="docentes.Universidad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!universidadInstance}">
    <elm:notFound elem="Universidad" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmUniversidad" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${universidadInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: universidadInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" required="" class="form-control required" value="${universidadInstance?.nombre}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: universidadInstance, field: 'nombreContacto', 'error')} ">
            <span class="grupo">
                <label for="nombreContacto" class="col-md-2 control-label text-info">
                    Nombre Contacto
                </label>
                <div class="col-md-6">
                    <g:textField name="nombreContacto" class="form-control" value="${universidadInstance?.nombreContacto}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: universidadInstance, field: 'apellidoContacto', 'error')} ">
            <span class="grupo">
                <label for="apellidoContacto" class="col-md-2 control-label text-info">
                    Apellido Contacto
                </label>
                <div class="col-md-6">
                    <g:textField name="apellidoContacto" class="form-control" value="${universidadInstance?.apellidoContacto}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: universidadInstance, field: 'fechaInicio', 'error')} ">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label text-info">
                    Fecha Inicio
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control" value="${universidadInstance?.fechaInicio}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: universidadInstance, field: 'fechaFin', 'error')} ">
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label text-info">
                    Fecha Fin
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaFin"  class="datepicker form-control" value="${universidadInstance?.fechaFin}" default="none" noSelection="['': '']" />
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: universidadInstance, field: 'logo', 'error')} ">
            <span class="grupo">
                <label for="logo" class="col-md-2 control-label text-info">
                    Logo
                </label>
                <div class="col-md-6">
                    <g:textField name="logo" class="allCaps form-control" value="${universidadInstance?.logo}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmUniversidad").validate({
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