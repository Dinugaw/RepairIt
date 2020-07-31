function removeElementsByClass("vmag-container"){
    var elements = document.getElementsByClassName("vmag-container");
    while(elements.length > 0){
        elements[0].parentNode.removeChild(elements[0]);
    }
}