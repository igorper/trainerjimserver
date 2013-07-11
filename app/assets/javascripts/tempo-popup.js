  $(document).ready(function() {
    $("#button-div").click(function() {
      // show popup
      popover(0, 0, 100)

    });
    RepetitionUp();
  });

  function popover(x, y, fadeTime, onClick) {
    console.log("popover");
    var element = $(
            '<div class="popup-tempo" style="background:white; width:600px; height:400px;">\n\
              <div \n\
                <input type="submit" id="cancel" value="Cancel"/>\n\
                <input type="submit" id="save" value="Save"/>\n\
            </div>'
  ).css({
      position: 'absolute',
      display: 'none',
      top: y + 5,
      left: x + 5
    }).appendTo("body");
    element.fadeIn(fadeTime);
    element.find("#close").click(function() {
      element.fadeOut(fadeTime, function() {
        element.remove();
      });

    });

//<%#*element.find("#post").click(function() {%>
//<%#*komentar = element.find("textarea").val();%>
//<%#*onClick(komentar);%>
//<%#*element.remove();%>
//<%#*});%>
  }

  counter = 0;

  function RepetitionUp() {
    if (counter < 3) {
      $("#tempo-animator").animate({height: "300px"}, 1000, RepetitionMiddle);
    }
  }

  function RepetitionMiddle() {
    $("#tempo-animator").animate({height: "300px"}, 500, RepetitionDown);
  }

  function RepetitionDown() {
    $("#tempo-animator").animate({height: "0px"}, 2000, RepetitionAfter);
  }

  function RepetitionAfter() {
    $("#tempo-animator").animate({height: "0px"}, 0, RepetitionUp);

    counter++;
  }
