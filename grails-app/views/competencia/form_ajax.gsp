<%@ page import="docentes.Competencia" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!competenciaInstance}">
    <elm:notFound elem="Competencia" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmCompetencia" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${competenciaInstance?.id}" />

        <div class="form-group ${hasErrors(bean: competenciaInstance, field: 'carrera', 'error')} ">
            <span class="grupo">
                <label for="carrera" class="col-md-2 control-label text-info">
                    Carrera
                </label>
                <div class="col-md-8">
                    <g:select id="carrera" name="carrera.id" from="${docentes.Carrera.list()}" optionKey="id" optionValue="descripcion" required="" value="${competenciaInstance?.carrera?.id}" class="many-to-one form-control"/>
                </div>

            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: competenciaInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <div class="col-md-10">
                    <g:textArea name="descripcion" maxlength="254" style="width: 365px; height: 135px; resize: none" required="" class="form-control required" value="${competenciaInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        

        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmCompetencia").validate({
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