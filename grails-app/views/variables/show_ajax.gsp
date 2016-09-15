
<%@ page import="docentes.Variables" %>

<g:if test="${!variablesInstance}">
    <elm:notFound elem="Variables" genero="o" />
</g:if>
<g:else>

    <g:if test="${variablesInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Código
            </div>
            
            <div class="col-md-4">
                <g:fieldValue bean="${variablesInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${variablesInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>
            
            <div class="col-md-8">
                <g:fieldValue bean="${variablesInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>