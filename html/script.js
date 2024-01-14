$(document).ready(function () {
    $("body").on("keyup", function (key) {
        if (key.which === 113 || key.which == 27 || key.which == 90) {
           $.post(`https://${GetParentResourceName()}/Close`);
        }
    });
});
const callsign=document.getElementById('callsign');
const pagecl=document.getElementById('callsignpage')

callsign.addEventListener('click',function(){
    if (pagecl.style.display=='block'){
        pagecl.style.display='none';
    }else{
        pagecl.style.display='block';
    }
})
function submitForm() {
  var callsignValue = document.getElementById("callsign1").value;  
  $.post(`https://${GetParentResourceName()}/setcallsign`, JSON.stringify(callsignValue));
}
window.addEventListener("message", function (event) {
    let action = event.data.action;
    let data = event.data.data;
    let container = document.getElementById('c');

    if (action == 'open' || action == 'drag') {
        $(".container").fadeIn(500);
        container.style.display = 'flex';
        dragElement(container);
    } else if (action == 'close') {
        $(".container").fadeOut(500);
    } else if (action == 'refresh') {
        $(".op-content").html(data);
    }
});
function dragElement(elmnt) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  if (document.getElementById(elmnt.id + "header")) {
    // if present, the header is where you move the DIV from:
    document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
  } else {
    // otherwise, move the DIV from anywhere inside the DIV:
    elmnt.onmousedown = dragMouseDown;
  }

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
  }

  function closeDragElement() {
    // stop moving when mouse button is released:
    document.onmouseup = null;
    document.onmousemove = null;
  }
}