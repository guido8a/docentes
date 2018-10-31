<%@ page import="docentes.Periodo" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!periodoInstance}">
    <elm:notFound elem="Periodo" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmPeriodo" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${periodoInstance?.id}" />

        <div class="form-group ${hasErrors(bean: periodoInstance, field: 'universidad', 'error')} ">
            <span class="grupo">
                <label for="universidad" class="col-md-2 control-label text-info">
                    Universidad
                </label>
                <div class="col-md-6">
                    <g:select name="universidad" from="${docentes.Universidad.findAllByNombreNotEqual("Todas").sort{it.nombre}}" optionKey="id" optionValue="nombre" class="form-control"/>
                </div>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: periodoInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" class="form-control" value="${periodoInstance?.nombre}"/>
                </div>

            </span>
        </div>

        <div class="form-group ${hasErrors(bean: periodoInstance, field: 'fechaInicio', 'error')} ">
            <span class="grupo">
                <label for="fechaInicio" class="col-md-2 control-label text-info">
                    Fecha Inicio
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaInicio"  class="datepicker form-control required" value="${periodoInstance?.fechaInicio}"  />
                    %{--<g:datePicker name="fechaInicio" id="inicioDate" class="form-control" precision="month" />--}%
                </div>

            </span>
        </div>


        <div class="form-group ${hasErrors(bean: periodoInstance, field: 'fechaFin', 'error')} ">
            <span class="grupo">
                <label for="fechaFin" class="col-md-2 control-label text-info">
                    Fecha Fin
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaFin"  class="datepicker form-control required" value="${periodoInstance?.fechaFin}"  />
                </div>
                
            </span>
        </div>
        

        

        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmPeriodo").validate({
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