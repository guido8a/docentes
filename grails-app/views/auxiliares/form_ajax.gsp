<%@ page import="utilitarios.Auxiliares" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!auxiliaresInstance}">
    <elm:notFound elem="Auxiliares" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmAuxiliares" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${auxiliaresInstance?.id}" />

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'ajusteExagerado ', 'error')} ">
                <span class="grupo">
                    <label for="ajusteExagerado" class="col-md-4 control-label text-info">
                        Ajuste Exagerado
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="ajusteExagerado" type="number" value="${auxiliaresInstance.ajusteExagerado}" class="digits form-control required" required=""/>--}%
                        <g:textField name="ajusteExagerado" class="form-control number required" value="${auxiliaresInstance?.ajusteExagerado}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6  ${hasErrors(bean: auxiliaresInstance, field: 'ajusteModerado', 'error')} ">
                <span class="grupo">
                    <label for="ajusteModerado" class="col-md-4 control-label text-info">
                        Ajuste Moderado
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="ajusteModerado" type="number" value="${auxiliaresInstance.ajusteModerado}" class="digits form-control required" required=""/>--}%
                        <g:textField name="ajusteModerado" class="form-control number required" value="${auxiliaresInstance?.ajusteModerado}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'cuelloBotella', 'error')} ">
                <span class="grupo">
                    <label for="cuelloBotella" class="col-md-4 control-label text-info">
                        Cuello Botella
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="cuelloBotella" type="number" value="${auxiliaresInstance.cuelloBotella}" class="digits form-control required" required=""/>--}%
                        <g:textField name="cuelloBotella" class="form-control number required" value="${auxiliaresInstance?.cuelloBotella}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'curso', 'error')} ">
                <span class="grupo">
                    <label for="curso" class="col-md-4 control-label text-info">
                        Curso
                    </label>
                    <div class="col-md-4">
                        <g:textField name="curso" class="allCaps form-control required" value="${auxiliaresInstance?.curso}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'dias', 'error')} ">
                <span class="grupo">
                    <label for="dias" class="col-md-4 control-label text-info">
                        Dias
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="dias" type="number" value="${auxiliaresInstance.dias}" class="digits form-control required" required=""/>--}%
                        <g:textField name="dias" class="form-control number required" value="${auxiliaresInstance?.dias}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'factorExterno', 'error')} ">
                <span class="grupo">
                    <label for="factorExterno" class="col-md-4 control-label text-info">
                        Factor Externo
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="factorExterno" type="number" value="${auxiliaresInstance.factorExterno}" class="digits form-control required" required=""/>--}%
                        <g:textField name="factorExterno" class="form-control number required" value="${auxiliaresInstance?.factorExterno}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'fechaCierre', 'error')} ">
                <span class="grupo">
                    <label for="fechaCierre" class="col-md-4 control-label text-info">
                        Fecha Cierre
                    </label>
                    <div class="col-md-4">
                        <elm:datepicker name="fechaCierre"  class="datepicker form-control required" value="${auxiliaresInstance?.fechaCierre}"  />
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'maximoAutoevaluacion', 'error')} ">
                <span class="grupo">
                    <label for="maximoAutoevaluacion" class="col-md-4 control-label text-info">
                        Maximo Autoevaluacion
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="maximoAutoevaluacion" type="number" value="${auxiliaresInstance.maximoAutoevaluacion}" class="digits form-control required" required=""/>--}%
                        <g:textField name="maximoAutoevaluacion" class="form-control number required" value="${auxiliaresInstance?.maximoAutoevaluacion}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'maximoDirectivos', 'error')} ">
                <span class="grupo">
                    <label for="maximoDirectivos" class="col-md-4 control-label text-info">
                        Maximo Directivos
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="maximoDirectivos" type="number" value="${auxiliaresInstance.maximoDirectivos}" class="digits form-control required" required=""/>--}%
                        <g:textField name="maximoDirectivos" class="form-control number required" value="${auxiliaresInstance?.maximoDirectivos}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'maximoEstudiantes', 'error')} ">
                <span class="grupo">
                    <label for="maximoEstudiantes" class="col-md-4 control-label text-info">
                        Maximo Estudiantes
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="maximoEstudiantes" type="number" value="${auxiliaresInstance.maximoEstudiantes}" class="digits form-control required" required=""/>--}%
                        <g:textField name="maximoEstudiantes" class="form-control number required" value="${auxiliaresInstance?.maximoEstudiantes}"/>
                    </div>

                </span>
            </div>
        </div>
        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'maximoPares', 'error')} ">
                <span class="grupo">
                    <label for="maximoPares" class="col-md-4 control-label text-info">
                        Maximo Pares
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="maximoPares" type="number" value="${auxiliaresInstance.maximoPares}" class="digits form-control required" required=""/>--}%
                        <g:textField name="maximoPares" class="form-control number required" value="${auxiliaresInstance?.maximoPares}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'maximoProfesores', 'error')} ">
                <span class="grupo">
                    <label for="maximoProfesores" class="col-md-4 control-label text-info">
                        Maximo Profesores
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="maximoProfesores" type="number" value="${auxiliaresInstance.maximoProfesores}" class="digits form-control required" required=""/>--}%
                        <g:textField name="maximoProfesores" class="form-control number required" value="${auxiliaresInstance?.maximoProfesores}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'minimo', 'error')} ">
                <span class="grupo">
                    <label for="minimo" class="col-md-4 control-label text-info">
                        Minimo
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="minimo" type="number" value="${fieldValue(bean: auxiliaresInstance, field: 'minimo')}" class="number form-control  required" required=""/>--}%
                        <g:textField name="minimo" class="form-control number required" value="${auxiliaresInstance?.minimo}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'numeroRondas', 'error')} ">
                <span class="grupo">
                    <label for="numeroRondas" class="col-md-4 control-label text-info">
                        Numero Rondas
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="numeroRondas" type="number" value="${auxiliaresInstance.numeroRondas}" class="digits form-control required" required=""/>--}%
                        <g:textField name="numeroRondas" class="form-control number required" value="${auxiliaresInstance?.numeroRondas}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'optimo', 'error')} ">
                <span class="grupo">
                    <label for="optimo" class="col-md-4 control-label text-info">
                        Optimo
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="optimo" type="number" value="${fieldValue(bean: auxiliaresInstance, field: 'optimo')}" class="number form-control  required" required=""/>--}%
                        <g:textField name="optimo" class="form-control number required" value="${auxiliaresInstance?.optimo}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'paralelo', 'error')} ">
                <span class="grupo">
                    <label for="paralelo" class="col-md-4 control-label text-info">
                        Paralelo
                    </label>
                    <div class="col-md-4">
                        %{--<g:field name="paralelo" type="number" value="${auxiliaresInstance.paralelo}" class="digits form-control required" required=""/>--}%
                        <g:textField name="paralelo" class="form-control number required" value="${auxiliaresInstance?.paralelo}"/>
                    </div>

                </span>
            </div>
        </div>

        <div class="row col-md-12">
            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'password', 'error')} ">
                <span class="grupo">
                    <label for="password" class="col-md-4 control-label text-info">
                        Password
                    </label>
                    <div class="col-md-4">
                        <g:textField name="password" class="form-control required" value="${auxiliaresInstance?.password}"/>
                    </div>

                </span>
            </div>

            <div class="form-group col-md-6 ${hasErrors(bean: auxiliaresInstance, field: 'periodo', 'error')} ">
                <span class="grupo">
                    <label for="periodo" class="col-md-4 control-label text-info">
                        Periodo
                    </label>
                    <div class="col-md-4">
                        <g:select id="periodo" name="periodo.id" from="${docentes.Periodo.list()}" optionKey="id" required="" optionValue="nombre" value="${auxiliaresInstance?.periodo?.id}" class="many-to-one form-control"/>
                    </div>

                </span>
            </div>
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