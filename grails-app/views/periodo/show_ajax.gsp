
<%@ page import="docentes.Periodo" %>

<g:if test="${!periodoInstance}">
    <elm:notFound elem="Periodo" genero="o" />
</g:if>
<g:else>

    <g:if test="${periodoInstance?.universidad}">
        <div class="row">
            <div class="col-md-2 text-info">
                Universidad
            </div>
            <div class="col-md-3">
                ${periodoInstance?.universidad?.nombre}
            </div>
        </div>
    </g:if>

    <g:if test="${periodoInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>

            <div class="col-md-3">
                <g:fieldValue bean="${periodoInstance}" field="nombre"/>
            </div>

        </div>
    </g:if>

    <g:if test="${periodoInstance?.fechaFin}">
        <div class="row">
            <div class="col-md-2 text-info">
                Fecha Fin
            </div>

            <div class="col-md-3">
                <g:formatDate date="${periodoInstance?.fechaFin}" format="dd-MM-yyyy" />
            </div>

        </div>
    </g:if>

    <g:if test="${periodoInstance?.fechaInicio}">
        <div class="row">
            <div class="col-md-2 text-info">
                Fecha Inicio
            </div>

            <div class="col-md-3">
                <g:formatDate date="${periodoInstance?.fechaInicio}" format="dd-MM-yyyy" />
            </div>

        </div>
    </g:if>



</g:else>