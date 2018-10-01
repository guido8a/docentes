
<%@ page import="docentes.Indicador" %>

<g:if test="${!indicadorInstance}">
    <elm:notFound elem="Indicador" genero="o" />
</g:if>
<g:else>

    <g:if test="${indicadorInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Código
            </div>
            
            <div class="col-md-6">
                <g:fieldValue bean="${indicadorInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${indicadorInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>
            
            <div class="col-md-10">
                <g:fieldValue bean="${indicadorInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${indicadorInstance?.estandar}">
        <div class="row">
            <div class="col-md-2 text-info">
                Estandar
            </div>
            
            <div class="col-md-6">
                ${indicadorInstance?.estandar?.codigo?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${indicadorInstance?.variables}">
        <div class="row">
            <div class="col-md-2 text-info">
                Variables
            </div>
            
            <div class="col-md-6">
                ${indicadorInstance?.variables?.descripcion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>