
<%@ page import="docentes.Estandar" %>

<g:if test="${!estandarInstance}">
    <elm:notFound elem="Estandar" genero="o" />
</g:if>
<g:else>

    <g:if test="${estandarInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Código
            </div>
            
            <div class="col-md-5">
                <g:fieldValue bean="${estandarInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${estandarInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>
            
            <div class="col-md-10">
                <g:fieldValue bean="${estandarInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>