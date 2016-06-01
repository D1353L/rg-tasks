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
                        url: "/load_scores",
                        success: function (response) {
                            resp = JSON.parse(response);
                            var table = $('<table></table>').addClass("table table-bordered");
                            table.append("<th>#</th><th>Name</th><th>Code</th><th>Attempts</th><th>Win/lose</th>");
                            jQuery.each(resp, function (i, val) {
                                var row = $('<tr></tr>');
                                var cell = $('<td></td>').text(i+1);
                                row.append(cell);
                                jQuery.each(val, function () {
                                    cell = $('<td></td>').text(this);
                                    row.append(cell);
                                });
                                table.append(row);
                            });
                            $("#scores").append(table);
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
                $.isNumeric(response) ? $('#hint').text(" "+response) : $('#message').text(response);
            }
        });
    });

    $(document).on('click', '#new_game', function () {
        location.reload();
    });
});