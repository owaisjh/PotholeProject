let map;

var data;
const xhr = new XMLHttpRequest()
//open a get request with the remote server URL
xhr.open("GET", "/potholes_coordinates")
//send the Http request
xhr.send()

function delay(time) {
  return new Promise(resolve => setTimeout(resolve, time));
}

xhr.onload = function() {
  if (xhr.status === 200) {
    //parse JSON data
    data = JSON.parse(xhr.responseText)
    // console.log(data)
    delay()
    initMap()

  } else if (xhr.status === 404) {
    console.log("No records found")
  }
}

//triggered when a network-level error occurs with the request
xhr.onerror = function() {
  console.log("Network error occurred")


}



function initMap() {
console.log(data)



  map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 19.0760, lng: 72.8777 },
    zoom: 12,
  });


  var i=0;



for (i = 0; i < data.length; i++) {


    // console.log(data[i][1]["coordinates"][1])
     new google.maps.Marker({
    position: { lat: data[i][1]["coordinates"][0], lng: data[i][1]["coordinates"][1] },
    map,
  });

}



}
