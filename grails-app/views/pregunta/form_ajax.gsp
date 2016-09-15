<%@ page import="docentes.Pregunta" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!preguntaInstance}">
    <elm:notFound elem="Pregunta" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmPregunta" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${preguntaInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: preguntaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Codigo
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="8" required="" class="allCaps form-control required" value="${preguntaInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: preguntaInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textArea name="descripcion" cols="40" rows="5" maxlength="255" required="" class="allCaps form-control required" value="${preguntaInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: preguntaInstance, field: 'estado', 'error')} ">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label text-info">
                    Estado
                </label>
                <div class="col-md-6">
                    <g:textField name="estado" class="allCaps form-control" value="${preguntaInstance?.estado}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: preguntaInstance, field: 'estrategia', 'error')} ">
            <span class="grupo">
                <label for="estrategia" class="col-md-2 control-label text-info">
                    Estrategia
                </label>
                <div class="col-md-6">
                    <g:textField name="estrategia" class="allCaps form-control" value="${preguntaInstance?.estrategia}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: preguntaInstance, field: 'numeroRespuestas', 'error')} ">
            <span class="grupo">
                <label for="numeroRespuestas" class="col-md-2 control-label text-info">
                    Numero Respuestas
                </label>
                <div class="col-md-6">
                    <g:field name="numeroRespuestas" type="number" value="${preguntaInstance.numeroRespuestas}" class="digits form-control required" required=""/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: preguntaInstance, field: 'tipoRespuesta', 'error')} ">
            <span class="grupo">
                <label for="tipoRespuesta" class="col-md-2 control-label text-info">
                    Tipo Respuesta
                </label>
                <div class="col-md-6">
                    <g:select id="tipoRespuesta" name="tipoRespuesta.id" from="${docentes.TipoRespuesta.list()}" optionKey="id" required="" value="${preguntaInstance?.tipoRespuesta?.id}" class="many-to-one form-control"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: preguntaInstance, field: 'variables', 'error')} ">
            <span class="grupo">
                <label for="variables" class="col-md-2 control-label text-info">
                    Variables
                </label>
                <div class="col-md-6">
                    <g:select id="variables" name="variables.id" from="${docentes.Variables.list()}" optionKey="id" required="" value="${preguntaInstance?.variables?.id}" class="many-to-one form-control"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmPregunta").validate({
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