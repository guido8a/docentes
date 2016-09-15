
<%@ page import="docentes.TipoEncuesta" %>

<g:if test="${!tipoEncuestaInstance}">
    <elm:notFound elem="TipoEncuesta" genero="o" />
</g:if>
<g:else>

    <g:if test="${tipoEncuestaInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoEncuestaInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${tipoEncuestaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoEncuestaInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${tipoEncuestaInstance?.estado}">
        <div class="row">
            <div class="col-md-2 text-info">
                Estado
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${tipoEncuestaInstance}" field="estado"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>