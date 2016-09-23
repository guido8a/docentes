<%@ page import="docentes.Prte" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!prteInstance}">
    <elm:notFound elem="Prte" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmPrte" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${prteInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: prteInstance, field: 'numero', 'error')} ">
            <span class="grupo">
                <label for="numero" class="col-md-2 control-label text-info">
                    Numero
                </label>
                <div class="col-md-6">
                    <g:field name="numero" type="number" value="${prteInstance.numero}" class="digits form-control required" required=""/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: prteInstance, field: 'pregunta', 'error')} ">
            <span class="grupo">
                <label for="pregunta" class="col-md-2 control-label text-info">
                    Pregunta
                </label>
                <div class="col-md-6">
                    <g:select id="pregunta" name="pregunta.id" from="${docentes.Pregunta.list()}" optionKey="id" required="" value="${prteInstance?.pregunta?.id}" class="many-to-one form-control"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: prteInstance, field: 'tipoEncuesta', 'error')} ">
            <span class="grupo">
                <label for="tipoEncuesta" class="col-md-2 control-label text-info">
                    Tipo Encuesta
                </label>
                <div class="col-md-6">
                    <g:select id="tipoEncuesta" name="tipoEncuesta.id" from="${docentes.TipoEncuesta.list()}" optionKey="id" required="" value="${prteInstance?.tipoEncuesta?.id}" class="many-to-one form-control"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmPrte").validate({
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