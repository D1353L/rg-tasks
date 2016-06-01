$(document).ready(function () {
    $(document).on('click', '#save_username', function () {
        var name = $('#text_field').val();
        jQuery.ajax({
            type: "POST",
            data: {username: name},
            url: "/set_username",
            success: function (response) {
                $('#message').text(response);
                $('#save_username').attr("id", "try");
                $('#text_field').val("").attr("pattern", "^[1-6]{4}$");
                $('#hint').removeClass("hidden");
            },
            error: function (err)
            { console.log(err.responseText)}
        });
    });

    $(document).on('click', '#try', function () {
        var guess = $('#text_field').val();
        jQuery.ajax({
            type: "POST",
            data: {guess: guess},
            url: "/verify_code",
            success: function (response) {
                resp = JSON.parse(response);
                if(resp.result == null) resp.result = "";
                document.getElementById('message').innerHTML = resp.result+"<br>"+resp.message;
                $('#text_field').val("");
                if(resp.endgame)
                {
                    $('#text_field').addClass("hidden");
                    $('#hint').addClass("hidden");
                    $('#try').text("New Game").attr("id", "new_game");
                    jQuery.ajax({
                        type: "GET",
                        url: "/get_scores",
                        success: function (response) {
                            resp = JSON.parse(response);
                            $("#scores").append("<table>")
                            jQuery.each(resp, function (i, val) {
                                $("#scores").append("<tr>");
                                $("#scores").append("<td> "+(i+1)+" </td>");
                                jQuery.each(val, function () {
                                    $("#scores").append("<td> "+this+" </td>");
                                });
                                $("#scores").append("</tr>");
                            });
                            $("#scores").append("</table>")
                        }
                    });
                }
            }
        });
    });

    $(document).on('click', '#hint', function () {
        jQuery.ajax({
            type: "GET",
            url: "/hint",
            success: function (response) {
                $('#hint').text(" - "+response);
            }
        });
    });

    $(document).on('click', '#new_game', function () {
        location.reload();
    });
});