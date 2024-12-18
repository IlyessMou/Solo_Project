<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Job</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <style>
        #map {
            height: 400px;
            width: 70%;
            margin: auto;     
            border: 3px dashed skyblue;
            border-radius: inherit;  
        }
    </style>
</head>
<body>
	<div style="border: 5px solid lightblue;background-image:url('https://media.istockphoto.com/id/1397400329/vector/millimeter-graph-paper-grid-geometric-pattern.jpg?s=612x612&w=0&k=20&c=IivJpxAiY-k6jBffYzAnt7m2B4PNuqKj-W4Z3hA-bJ8=');border-radius: 5%; padding: 60px;">
    <h1>Add Job</h1>
    <div style="display: flex;">
    <div style="display: flex
    justify-content: center;
    padding: 45px;
    background-color: azure;
    width: 300px;
    justify-self: center;
    margin-bottom: 30px;
    border: 3px solid lightblue;
    border-radius: inherit;
    box-shadow: 14px 14px 2px 2px skyblue;
    margin-right: 60px;">
    <form:form action="/jobs" method="post" modelAttribute="job"  style="text-align: center;">
    <div>
        <label for="title">Title :</label>
        <hr>
        <br>
        <form:input path="title" id="title"  />
        <br>
        <form:errors path="title" cssClass="error" />
    </div>
    <br />

    <div>
        <label for="description">Description :</label>
        <hr>
        <br>
        <form:textarea path="description" id="description" />
        <br>
        <form:errors path="description" cssClass="error" />
    </div>
    <br />

    <div>
        <label for="reward">Reward :</label>
        <hr>
        <br>
        <form:input path="reward" id="reward" type="number" step="any"/>
        <br>
        <form:errors path="reward" cssClass="error" />
    </div>
    <br />

    <div>
        <label for="location">Location:</label>
        <hr>
        <br>
        <form:input path="location" id="location" readonly="true" />
        <br>
        <form:errors path="location" cssClass="error" />
    </div>
    <br />
    <br>

    <!-- Make latitude and longitude hidden -->
    <form:hidden path="latitude" id="latitude" />
    <form:hidden path="longitude" id="longitude" />
    <br />

     <button type="submit" 
        style="background-color: mediumseagreen; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; border: none; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease;margin-bottom: 8px;"
        onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
        onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
        Add
    </button>
    <a href="/home"  style="display: inline-block; background-color: lightcoral; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease; margin-bottom: 8px;"
   		onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
  		onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
   		Cancel
	</a>
</form:form>
    </div>
    

    <div id="map"></div>
	</div>
	</div>
<script>
    const defaultLat = 37.2761; 
    const defaultLng = 9.8737; 
    const map = L.map('map').setView([defaultLat, defaultLng], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
    }).addTo(map);

    const marker = L.marker([defaultLat, defaultLng], { draggable: true }).addTo(map);

    marker.on('dragend', function (event) {
        const position = marker.getLatLng();
        const lat = position.lat;
        const lon = position.lng;

        console.log('Marker Position:', position);
        console.log('Latitude:', lat);
        console.log('Longitude:', lon);

        // Update hidden latitude and longitude 
        document.getElementById('latitude').value = lat;
        document.getElementById('longitude').value = lon;

        const apiUrl = 'https://nominatim.openstreetmap.org/reverse?lat=' + lat + '&lon=' + lon + '&format=json&addressdetails=1';
        console.log('API URL:', apiUrl);

        fetch(apiUrl)
            .then(response => response.json())
            .then(data => {
                if (data && data.address) {
                    console.log('Full Address Data:', data.address); 

                    const street = data.address.road || 'Street not found';
                    const city = data.address.city || data.address.town || data.address.village || 'City not found';
                    const state = data.address.state || 'State not found';
                    const country = data.address.country || 'Country not found';
                    const postalCode = data.address.postcode || 'Postal code not found';

                    const fullAddress = street + ', ' + city + ', ' + state + ', ' + country + ', ' + postalCode;
                    document.getElementById('location').value = fullAddress;

                    console.log('Full Address:', fullAddress);
                } else {
                    document.getElementById('location').value = 'No detailed address found for this location.';
                    console.log('No address data found for these coordinates.');
                }
            })
            .catch(error => {
                console.error('Error fetching address:', error);
                document.getElementById('location').value = 'Error fetching address';
            });
    });
</script>

</body>
</html>



