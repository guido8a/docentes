
<%@ page import="docentes.TipoRespuesta" %>

<g:if test="${!tipoRespuestaInstance}">
    <elm:notFound elem="TipoRespuesta" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoRespuestaInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Código
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoRespuestaInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${tipoRespuestaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>
            
            <div class="col-md-5">
                <g:fieldValue bean="${tipoRespuestaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>