
<%@ page import="docentes.Respuesta" %>

<g:if test="${!respuestaInstance}">
    <elm:notFound elem="Respuesta" genero="o" />
</g:if>
<g:else>

    <g:if test="${respuestaInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${respuestaInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${respuestaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${respuestaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${respuestaInstance?.valor}">
        <div class="row">
            <div class="col-md-2 text-info">
                Valor
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${respuestaInstance}" field="valor"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>