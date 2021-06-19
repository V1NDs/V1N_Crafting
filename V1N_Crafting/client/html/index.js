/*
────────────────────────────────────────────────────────────────────────────────
─██████──██████─████████───██████──────────██████─████████████───██████████████─
─██░░██──██░░██─██░░░░██───██░░██████████──██░░██─██░░░░░░░░████─██░░░░░░░░░░██─
─██░░██──██░░██─████░░██───██░░░░░░░░░░██──██░░██─██░░████░░░░██─██░░██████████─
─██░░██──██░░██───██░░██───██░░██████░░██──██░░██─██░░██──██░░██─██░░██─────────
─██░░██──██░░██───██░░██───██░░██──██░░██──██░░██─██░░██──██░░██─██░░██████████─
─██░░██──██░░██───██░░██───██░░██──██░░██──██░░██─██░░██──██░░██─██░░░░░░░░░░██─
─██░░██──██░░██───██░░██───██░░██──██░░██──██░░██─██░░██──██░░██─██████████░░██─
─██░░░░██░░░░██───██░░██───██░░██──██░░██████░░██─██░░██──██░░██─────────██░░██─
─████░░░░░░████─████░░████─██░░██──██░░░░░░░░░░██─██░░████░░░░██─██████████░░██─
───████░░████───██░░░░░░██─██░░██──██████████░░██─██░░░░░░░░████─██░░░░░░░░░░██─
─────██████─────██████████─██████──────────██████─████████████───██████████████─
────────────────────────────────────────────────────────────────────────────────
Discord: V1NDs#0977
Youtube: https://www.youtube.com/channel/UCxoJ3jF7onq1TRkOnAZAF8w
Github: https://github.com/V1NDs
Discord server: https://discord.gg/ECUxET82SD
*/

$(document).ready(() => {

    //Global variables//
    var resource = undefined;
    var craftables = undefined;
    ///////////////////////////////////////

    //Display function//
    display = (bool) => { 
        if (bool) {
            $(".container").show()
        } else { 
            $(".container").hide()
            
            //Remove last item
            $(".craftables-list > .item, .craftables-list > h3, .craftables-search > input, .item-info > .title, .item-info > .description, .item-info > .craftingInformations, .item-options > table, .item-options > .craft, .item-options > .amountChooser, .item-options > h3").remove()
            resource = undefined
            craftables = undefined
        } 
    };

    display(false);
    ///////////////////////////////////////

    //Get craftable information function//
    getItemInformation = (item) => {
        for (var i = 0; i < craftables.length; i++) {
            if (craftables[i].item === item) { 
                return craftables[i]
            }
        }
    };
    ///////////////////////////////////////

    //Create craftables function//
    createCraftables = (items) => {
        var bench = items[0].bench

        //Bench title
        if (bench) {
            $(".craftables-list").append(`<h3>${bench}</h3>`)
        }

        //Bench items
        for (var i = 0; i < items.length; i++) {
            var item = items[i]

            //Validate item
            if (!item.notValid) {
                $(".craftables-list").append(`<div class="item" item="${item.item}"> <h3>${item.itemName}</h3></div>`)
            }
        }

        //Bench search
        $(".craftables-search").append(`<input type="text" id="search" onkeyup="updateList()" placeholder="Søg efter item">`)

        //Bench search function
        updateList = () => {
            var input, filter, i, txtValue
            input = document.getElementById("search")
            filter = input.value.toUpperCase()
            div = document.getElementsByClassName("item")

            for (i = 0; i < div.length; i++) {
                h3 = div[i].getElementsByTagName("h3")[0];
                txtValue = h3.textContent || h3.innerText;
                if (txtValue.toUpperCase().includes(filter)) {
                    div[i].style.display = ""
                } else {
                    div[i].style.display = "none"
                }
            }
        }

        //Listen for item click
        $(".item").click(function() {

            //Get item table
            var item = $(this).attr("item")
            var itemInfo = getItemInformation(item)
            
            //Remove last table
            $(".item-info > .title, .item-info > .description, .item-info > .craftingInformations, .item-options > table, .item-options > .craft, .item-options > .amountChooser, .item-options > h3").remove()

            //Create item information
            if (!itemInfo.description) { itemInfo.description = "Ingen beskrivelse" }

            $(".item-info").append(`<div class="craftingInformations"><p>Antal: ${itemInfo.amount} | Tid: ${new Date(itemInfo.craftingTime * 1000).toISOString().substr(11, 8)}</p></div> <h3 class="title">${itemInfo.itemName}</h3> <p class="description">${itemInfo.description}</p>`)
        
            //Create item options
            $(".item-options").append("<h3>Kræver</h3>")

            $(".item-options").append("<table> <thead></thead> <tbody></tbody> </table>")

            $(".item-options > table > thead").append("<tr> <th>Item</th> <th>Antal</th> </tr>")

            $(".item-options").append(`<div class="amountChooser"> <p id="amount-value"></p> <input type="range" min="1" max="100" value="1" class="slider" id="amount"> </div>`)

            $(".item-options").append(`<div class="craft" id="${item}"><p>Craft ${itemInfo.amount} ${itemInfo.itemName}</p></div>`)

            for (var t = 0; t < itemInfo.vRPrecipe.length; t++) {
                $(".item-options > table > tbody").append(`<tr> <td>${itemInfo.vRPrecipe[t].item}</td> <td>${itemInfo.vRPrecipe[t].amount}</td> </tr>`)
            }

            var slider = document.getElementById("amount")
            var output = document.getElementById("amount-value")
            output.innerHTML = slider.value
        
            var newAmount = slider.value

            slider.oninput = function() {
                newAmount = this.value
                output.innerHTML = newAmount

                $(".item-info > .title, .item-info > .description, .item-info > .craftingInformations, .item-options > table > tbody > tr, .item-options > .craft").remove()

                $(".item-info").append(`<div class="craftingInformations"><p>Antal: ${itemInfo.amount * newAmount} | Tid: ${new Date(itemInfo.craftingTime * newAmount * 1000).toISOString().substr(11, 8)}</p></div> <h3 class="title">${itemInfo.itemName}</h3> <p class="description">${itemInfo.description}</p>`)
    
                $(".item-options").append(`<div class="craft" id="${item}"><p>Craft ${itemInfo.amount * newAmount} ${itemInfo.itemName}</p></div>`)
    
                for (var t = 0; t < itemInfo.vRPrecipe.length; t++) {
                    $(".item-options > table > tbody").append(`<tr> <td>${itemInfo.vRPrecipe[t].item}</td> <td>${itemInfo.vRPrecipe[t].amount * newAmount}</td> </tr>`)
                }

                //Listen for craft to be clicked
                $(".item-options > .craft").click(function() {
                    $.post(`https://${resource}/craft`, JSON.stringify({
                        "item": item,
                        "amount": Math.floor(newAmount),
                        "bench": bench
                    }))
                })
            }

            //Listen for craft to be clicked
            $(".item-options > .craft").click(function() {
                $.post(`https://${resource}/craft`, JSON.stringify({
                    "item": item,
                    "amount": Math.floor(newAmount),
                    "bench": bench
                }))
            })
        })
    };
    ///////////////////////////////////////

    //Listen for events//
    window.addEventListener("message", function(event) {
        var data = event.data

        if (data.status) {
            display(true)
            resource = data.resource
            craftables = data.items

            createCraftables(craftables)
        } else {
            display(false)
        }
    });
    ///////////////////////////////////////

    //Listen for esc key to close
    $(document).keyup(function(event) {
        if (event.key === "Escape") {
            $.post(`https://${resource}/close`, JSON.stringify({}));
        }
    });
    ///////////////////////////////////////
});
