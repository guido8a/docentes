<html>
  <head>
    <title><g:layoutTitle default="Grails" /></title>
    <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
    <link rel="stylesheet" href="${resource(dir:'css',file:'aplicacion.css')}" />
    <link rel="stylesheet" href="${resource(dir:'css',file:'botones.css')}" />
    %{--<link rel='stylesheet' href='${createLinkTo(dir:'js/jquery/css/tema2', file:'jquery-ui-1.10.3.custom.min.css')}' />--}%
    %{--<link rel='stylesheet' href='${createLinkTo(dir:'js/jquery/css/tema', file:'jquery-ui-1.8.1.custom.css')}' />--}%
  <g:includeJQuery archivo="preguntas" />
  <g:layoutHead />
  <g:javascript library="application" />
</head>
<body>
  <div id="spinner" class="spinner" style="display:none; ">
    <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner" />
  </div>

<g:layoutBody />
<div id="menu2" style="display:none;width:200px;background-color:white;border:1px solid black;padding:5px;text-align:center">
  TEDEIN S.A. <br>
  tedeinsa@hotmail.es <br>
  telf: 096316065 <br>
  Web:<a target="_blank" href="http://www.tedein.com.ec">www.tedein.com.ec</a><br>
  Quito - Ecuador <br>
</div>
</body>
</html>