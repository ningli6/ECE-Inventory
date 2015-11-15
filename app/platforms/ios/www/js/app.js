// We use an "Immediate Function" to initialize the application to avoid leaving anything behind in the global scope
(function () {

    /* ---------------------------------- Local Variables ---------------------------------- */

    /* --------------------------------- Event Registration -------------------------------- */
    $('#search-button').on('click', searchItem);

    document.addEventListener('deviceready', function () {
        if (navigator.notification) { // Override default HTML alert with native dialog
            window.alert = function (message) {
                navigator.notification.alert(
                    message,    // message
                    null,       // callback
                    "ECE Inventory", // title
                    'OK'        // buttonName
                  );
              };
            }
        }, false);

    /* ---------------------------------- Local Functions ---------------------------------- */

    function searchItem() {
        var itemId = $('.search-key').val();
        var url = "http://eceinventory2.azurewebsites.net/api/items/";
        $.ajax({
            url: url + itemId, 
            success: itemHandler,
            dataType: "json",
            error: function(XMLHttpRequest, textStatus, errorThrown){
                alert('status:' + XMLHttpRequest.status + ', status text: ' + XMLHttpRequest.statusText);
            }
        });
        // $.get(url + q, itemHandler, "json");
    }

    function itemHandler (data) {
        var itemId = data.ItemId;
        var itemName = data.Name;
        alert("Item information:\n" + "Item id: " + itemId + "\nItem Name: " + itemName + "\n");
    }

}());