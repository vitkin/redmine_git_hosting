var zero_clipboard_source_input_control_id = "git_url_text";
var clipboard = null;

// jquery stuff (optional)
function debugstr(text)
{
  $("#d_debug").append($("<p>").text(text));
}

function reset_zero_clipboard()
{
  var clip_container = document.getElementById("clipboard_container");

  if (clip_container)
  {
    clip_container.style.display = "";
    clip_container.style.fontFamily = "serif";

    var cur_children = clip_container.childNodes;
    var ci;

    for (ci = 0; ci < cur_children.length; ci++)
    {
      var c = cur_children[ci];

      if (c.id != "clipboard_button")
      {
        clip_container.removeChild(c);
      }
    }

    clipboard = new ZeroClipboard(document.getElementById("clipboard_button"));
    //clipboard = new ZeroClipboard.Client();
    
    //clipboard.setHandCursor(true);
    //clipboard.glue(document.getElementById("clipboard_container"));
    //clipboard.glue('clipboard_button', 'clipboard_container');
    
    //debugstr("truc");

    
    clipboard.on('mouseOver', function(client)
    {
      //debugstr("Value " + document.getElementById(zero_clipboard_source_input_control_id).value);
      clipboard.setText(document.getElementById(zero_clipboard_source_input_control_id).value);
      document.getElementById("clipboard_button").style.background = "#507AAA";
    });
    
    clipboard.on('mouseOut', function(client)
    {
      document.getElementById("clipboard_button").style.background = "#eee";
    });

    clipboard.on('load', function(client)
    {
      //debugstr("Flash movie loaded and ready.");
    });

    clipboard.on('complete', function(client, args)
    {
      //debugstr("Copied text to clipboard: " + args.text);
      document.getElementById("clipboard_button").style.background = "#bbb";
      
      setTimeout(function () 
      {
        document.getElementById("clipboard_button").style.background = "#eee";
      }, 250);
      
    });
    
    
    /*clipboard.addEventListener('mouseOver', function (client) {
      debugstr("Value " + document.getElementById(zero_clipboard_source_input_control_id).value);
			clipboard.setText(document.getElementById(zero_clipboard_source_input_control_id).value);
		});*/
  }
}

function setZeroClipboardInputSource(id)
{
  zero_clipboard_source_input_control_id = id;
}

$(document).ready(function()
{
  reset_zero_clipboard();
});
