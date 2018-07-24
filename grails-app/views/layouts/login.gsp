<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">

        <!-- los favicon de todos los tamaños -->
        <elm:favicon/>

        <title><g:layoutTitle title="Quanto"/></title>

        <!-- Bootstrap core CSS -->
        <elm:bootstrapCss/>

        <!-- JQuery -->
        <script src="${resource(dir: 'js/jquery/js', file: 'jquery-1.9.1.js')}"></script>
        <script src="${resource(dir: 'js/jquery/js', file: 'jquery-ui-1.10.3.custom.min.js')}"></script>
        <link href="${resource(dir: 'js/jquery/css/ui-lightness', file: 'jquery-ui-1.10.3.custom.min.css')}" rel="stylesheet">

        <!-- funciones de JS -->
        <!-- funciones de strings y formats sacados de internet (pad, starts y ends with, capitalize, format_number, str_replace) -->
        <script src="${resource(dir: 'js', file: 'functions.js')}"></script>
        <script src="${resource(dir: 'js', file: 'funciones.js')}"></script>

        <!-- la validacion del lado del cliente -->
        <script src="${resource(dir: 'js/plugins/jquery-validation-1.11.1/js', file: 'jquery.validate.min.js')}"></script>
        <script src="${resource(dir: 'js/plugins/jquery-validation-1.11.1/localization', file: 'messages_es.js')}"></script>
        <script src="${resource(dir: 'js', file: 'jquery.validate.custom.js')}"></script>


        <script type="text/javascript">
            var spinner24Url = "${resource(dir:'images/spinners', file:'spinner_login.GIF')}";
            var spinner64Url = "${resource(dir:'images/spinners', file:'spinner_64.GIF')}";

            var spinnerSquare64Url = "${resource(dir: 'images/spinners', file: 'spinner.gif')}";

            var spinner = $("<img src='" + spinner24Url + "' alt='Cargando...'/>");
            var spinner64 = $("<img src='" + spinner64Url + "' alt='Cargando...'/>");
            var spinnerSquare64 = $("<img src='" + spinnerSquare64Url + "' alt='Cargando...'/>");
        </script>

        <style type="text/css">
        input {
            margin-top : 15px;
        }

        .divBtn {
            margin-top : 30px;
            text-align : center;
        }
        </style>

        <g:layoutHead/>

    </head>

    <body>

        <div class="container" style="min-width: 1000px !important;">
            <g:layoutBody/>
        </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <elm:bootstrapJs/>

    <!-- funciones de ui (tooltips, maxlength, bootbox, contextmenu, validacion en keydown para los numeros) -->
        %{--<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>--}%
        <script type="text/javascript">
            var ot = document.title;

            function resetTimer() {
                var ahora = new Date();
                var fin = ahora.clone().add(20).minute();
                $("#countdown").countdown('option', {
                    until : fin
                });
                $(".countdown_amount").removeClass("highlight");
                document.title = ot;
            }

//            function validarSesion() {
//                $.ajax({
                    %{--url     : '${createLink(controller: "login", action: "validarSesion")}',--}%
//                    success : function (msg) {
//                        if (msg == "NO") {
                            %{--location.href = "${g.createLink(controller: 'login', action: 'login')}";--}%
//                        } else {
//                            resetTimer();
//                        }
//                    }
//                });
//            }

            function highlight(periods) {
                if ((periods[5] == 5 && periods[6] == 0) || (periods[5] < 5)) {
                    document.title = "Fin de sesión en " + (periods[5].toString().lpad('0', 2)) + ":" + (periods[6].toString().lpad('0', 2)) + " - " + ot;
                    $(".countdown_amount").addClass("highlight");
                }
            }

//            $(function () {
//            function validarSesion() {
//                var ahora = new Date();
//                var fin = ahora.clone().add(20).minute();
//
//                $('#countdown').countdown({
//                    until    : fin,
//                    format   : 'MS',
//                    compact  : true,
//                    onExpiry : validarSesion,
//                    onTick   : highlight
//                });
//
//                $(".btn-ajax").click(function () {
//                    resetTimer();
//                });
//            });

        </script>

    </body>
</html>
