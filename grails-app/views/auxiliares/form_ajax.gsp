<%@ page import="utilitarios.Auxiliares" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!auxiliaresInstance}">
    <elm:notFound elem="Auxiliares" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmAuxiliares" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${auxiliaresInstance?.id}" />

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'minimo', 'error')} ">
                <span class="grupo">
                    <label for="minimo" class="col-md-9 control-label text-info">
                        Índice de calidad Mínimo (evaluación docentes)
                    </label>
                    <div class="col-md-3">
                        %{--<g:field name="minimo" type="number" value="${fieldValue(bean: auxiliaresInstance, field: 'minimo')}" class="number form-control  required" required=""/>--}%
                        <g:textField name="minimo" class="form-control number required" value="${auxiliaresInstance?.minimo}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'optimo', 'error')} ">
                <span class="grupo">
                    <label for="optimo" class="col-md-9 control-label text-info">
                        Índice de calidad Óptimo (evaluación docentes)
                    </label>
                    <div class="col-md-3">
                        %{--<g:field name="optimo" type="number" value="${fieldValue(bean: auxiliaresInstance, field: 'optimo')}" class="number form-control  required" required=""/>--}%
                        <g:textField name="optimo" class="form-control number required" value="${auxiliaresInstance?.optimo}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6  ${hasErrors(bean: auxiliaresInstance, field: 'ajusteModerado', 'error')} ">
                <span class="grupo">
                    <label for="ajusteModerado" class="col-md-9 control-label text-info">
                        Ajuste para potenciadores de nivel Moderado (0-100 val=75)
                    </label>
                    <div class="col-md-3">
                        %{--<g:field name="ajusteModerado" type="number" value="${auxiliaresInstance.ajusteModerado}" class="digits form-control required" required=""/>--}%
                        <g:textField name="ajusteModerado" class="form-control number required" value="${auxiliaresInstance?.ajusteModerado}"/>
                    </div>

                </span>
            </div>
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'ajusteExagerado ', 'error')} ">
                <span class="grupo">
                    <label for="ajusteExagerado" class="col-md-9 control-label text-info">
                        Ajuste para potenciadores de nivel Exagerado (0-75 val=50)
                    </label>
                    <div class="col-md-3">
                        %{--<g:field name="ajusteExagerado" type="number" value="${auxiliaresInstance.ajusteExagerado}" class="digits form-control required" required=""/>--}%
                        <g:textField name="ajusteExagerado" class="form-control number required" value="${auxiliaresInstance?.ajusteExagerado}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'cuelloBotella', 'error')} ">
                <span class="grupo">
                    <label for="cuelloBotella" class="col-md-9 control-label text-info">
                        % de opinión para Cuellos de Botella (10-50 val=10)
                    </label>
                    <div class="col-md-3">
                        %{--<g:field name="cuelloBotella" type="number" value="${auxiliaresInstance.cuelloBotella}" class="digits form-control required" required=""/>--}%
                        <g:textField name="cuelloBotella" class="form-control number required" value="${auxiliaresInstance?.cuelloBotella}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'factorExterno', 'error')} ">
                <span class="grupo">
                    <label for="factorExterno" class="col-md-9 control-label text-info">
                        % de opinión para Factor de éxito (10-50 val=10)
                    </label>
                    <div class="col-md-3">
                        %{--<g:field name="factorExterno" type="number" value="${auxiliaresInstance.factorExterno}" class="digits form-control required" required=""/>--}%
                        <g:textField name="factorExterno" class="form-control number required" value="${auxiliaresInstance?.factorExito}"/>
                    </div>

                </span>
            </div>
        </div>


        <div class="row col-md-12">
            <div class="form-group col-md-3 ${hasErrors(bean: auxiliaresInstance, field: 'maximoDirectivos', 'error')} ">
                <span class="grupo">
                    <label for="maximoDirectivos" class="col-md-8 control-label text-info">
                        Ponderación para evaluación de Directivos
                    </label>
                    <div class="col-md-4">
                        <g:textField name="maximoDirectivos" class="form-control number required" value="${auxiliaresInstance?.maximoDirectivos}"/>
                    </div>
                </span>
            </div>

            <div class="form-group col-md-3 ${hasErrors(bean: auxiliaresInstance, field: 'maximoPares', 'error')} ">
                <span class="grupo">
                    <label for="maximoPares" class="col-md-8 control-label text-info">
                        Ponderación para evaluación de Pares
                    </label>
                    <div class="col-md-4">
                        <g:textField name="maximoPares" class="form-control number required" value="${auxiliaresInstance?.maximoPares}"/>
                    </div>
                </span>
            </div>
            <div class="form-group col-md-3 ${hasErrors(bean: auxiliaresInstance, field: 'maximoAutoevaluacion', 'error')} ">
                <span class="grupo">
                    <label for="maximoAutoevaluacion" class="col-md-8 control-label text-info">
                        Ponderación para Autoevaluaciones
                    </label>
                    <div class="col-md-4">
                        <g:textField name="maximoAutoevaluacion" class="form-control number required" value="${auxiliaresInstance?.maximoAutoevaluacion}"/>
                    </div>
                </span>
            </div>
            <div class="form-group col-md-3 ${hasErrors(bean: auxiliaresInstance, field: 'maximoEstudiantes', 'error')} ">
                <span class="grupo">
                    <label for="maximoEstudiantes" class="col-md-8 control-label text-info">
                        Ponderación para evaluación de Estudiantes
                    </label>
                    <div class="col-md-4">
                        <g:textField name="maximoEstudiantes" class="form-control number required" value="${auxiliaresInstance?.maximoEstudiantes}"/>
                    </div>
                </span>
            </div>
        </div>


        <div class="form-group col-md-4 ${hasErrors(bean: auxiliaresInstance, field: 'numeroRondas', 'error')} ">
            <span class="grupo">
                <label for="numeroRondas" class="col-md-8 control-label text-info">
                    Número máximo de encuestas a aplicar a un Profesor
                </label>
                <div class="col-md-4">
                    <g:textField name="numeroRondas" class="form-control number required" value="${auxiliaresInstance?.numeroRondas}"/>
                </div>

            </span>
        </div>


        <div class="form-group col-md-4 ${hasErrors(bean: auxiliaresInstance, field: 'maximoProfesores', 'error')} ">
            <span class="grupo">
                <label for="maximoProfesores" class="col-md-8 control-label text-info">
                    Número máximo profesores que puede avaluar un estudiante
                </label>
                <div class="col-md-4">
                    <g:textField name="maximoProfesores" class="form-control number required" value="${auxiliaresInstance?.maximoProfesores}"/>
                </div>

            </span>
        </div>

        <div class="form-group col-md-4 ${hasErrors(bean: auxiliaresInstance, field: 'fechaCierre', 'error')} ">
            <span class="grupo">
                <label for="fechaCierre" class="col-md-6 control-label text-info">
                    Fecha de cierre de encuestas
                </label>
                <div class="col-md-6">
                    <elm:datepicker name="fechaCierre"  class="datepicker form-control required" value="${auxiliaresInstance?.fechaCierre}"  />
                </div>

            </span>
        </div>

    </g:form>

    <script type="text/javascript">
        var validator = $("#frmAuxiliares").validate({
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