
<%@ page import="docentes.Prte" %>

<g:if test="${!prteInstance}">
    <elm:notFound elem="Prte" genero="o" />
</g:if>
<g:else>

    <g:if test="${prteInstance?.numero}">
        <div class="row">
            <div class="col-md-2 text-info">
                Numero
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${prteInstance}" field="numero"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prteInstance?.pregunta}">
        <div class="row">
            <div class="col-md-2 text-info">
                Pregunta
            </div>
            
            <div class="col-md-3">
                ${prteInstance?.pregunta?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${prteInstance?.tipoEncuesta}">
        <div class="row">
            <div class="col-md-2 text-info">
                Tipo Encuesta
            </div>
            
            <div class="col-md-3">
                ${prteInstance?.tipoEncuesta?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>