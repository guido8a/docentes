
<%@ page import="docentes.Universidad" %>

<g:if test="${!universidadInstance}">
    <elm:notFound elem="Universidad" genero="o" />
</g:if>
<g:else>

    <g:if test="${universidadInstance?.nombre}">
        <div class="row">
            <div class="col-md-3 text-info">
                Nombre
            </div>
            
            <div class="col-md-6">
                <g:fieldValue bean="${universidadInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${universidadInstance?.nombreContacto}">
        <div class="row">
            <div class="col-md-3 text-info">
                Nombre de Contacto
            </div>
            
            <div class="col-md-6">
                <g:fieldValue bean="${universidadInstance}" field="nombreContacto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${universidadInstance?.apellidoContacto}">
        <div class="row">
            <div class="col-md-3 text-info">
                Apellido de Contacto
            </div>
            
            <div class="col-md-6">
                <g:fieldValue bean="${universidadInstance}" field="apellidoContacto"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${universidadInstance?.fechaInicio}">
        <div class="row">
            <div class="col-md-3 text-info">
                Fecha Inicio
            </div>
            
            <div class="col-md-6">
                <g:formatDate date="${universidadInstance?.fechaInicio}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${universidadInstance?.fechaFin}">
        <div class="row">
            <div class="col-md-3 text-info">
                Fecha Fin
            </div>
            
            <div class="col-md-6">
                <g:formatDate date="${universidadInstance?.fechaFin}" format="dd-MM-yyyy" />
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${universidadInstance?.logo}">
        <div class="row">
            <div class="col-md-3 text-info">
                Logo
            </div>
            
            <div class="col-md-6">
                <g:img dir="/images/univ/" file="${universidadInstance?.logo}" width="100px" height="100"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>