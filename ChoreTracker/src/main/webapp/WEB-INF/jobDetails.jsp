<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" style="
    padding: 0px;
    justify-items: center;">
<head>
    <meta charset="UTF-8">
    <title>Job Details</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fc;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .job-container {
        	margin-top: 105px;
            background: url('https://media.istockphoto.com/id/1397400329/vector/millimeter-graph-paper-grid-geometric-pattern.jpg?s=612x612&w=0&k=20&c=IivJpxAiY-k6jBffYzAnt7m2B4PNuqKj-W4Z3hA-bJ8=') no-repeat center center;
            background-size: cover;
            border-radius: 10px;
            padding: 40px;
            width: 80%;
            max-width: 900px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .job-details {
            margin-top: 20px;
            text-align: left;
            font-size: 1.1em;
        }

        .job-details p {
            margin-bottom: 10px;
            font-weight: bold;
        }

        .job-details span {
            color: #555;
            font-weight: normal;
        }

        .job-actions {
            text-align: center;
            margin-top: 30px;
        }

        .job-actions a {
            margin: 0 15px;
            text-decoration: none;
            color: #fff;
            padding: 10px 20px;
            border-radius: 5px;
            background-color: #6c757d;
            transition: background-color 0.3s ease;
        }

        .job-actions a:hover {
            background-color: #5a6268;
        }

        #map {
            margin-top: 30px;
            width: 100%;
            height: 400px;
            border-radius: 10px;
            border: 3px solid #ddd;
        }

        @media screen and (max-width: 768px) {
            .job-container {
                width: 80%;
            }
        }
    </style>
</head>
<body>
    <div class="job-container">
        <h1>Job Details</h1>
        <div class="job-details">
            <p><strong>Title: </strong> <span>${job.title}</span></p>
            <p><strong>Description: </strong> <span>${job.description}</span></p>
            <p><strong>Location: </strong> <span>${job.location}</span></p>
            <p><strong>Reward:</strong> <span>${job.reward}</span></p>
            <p><strong>Posted By: </strong> <span>${job.createdBy.username}</span></p>
            <p><strong>Posted On: </strong> <span><fmt:formatDate value="${job.createdAt}" pattern="dd/MM/yyyy , HH:mm:ss" /></span></p>
            
            
        </div>
        <div  style="justify-self: center; margin-top: 20px;">
	        	<form action="/jobs/${job.id}/addToMyJobs" method="post" style="display: inline;">
	   				<button type="submit" style="background-color: darkturquoise; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; border: none; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease;margin-bottom: 8px;"
	        			onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
	       				onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
	        			Claim
	    			</button>
				</form>
	        	<c:if test="${job.createdBy.id == sessionScope.userId}"> 
	                <a href="/jobs/${job.id}/edit" style="display: inline-block; background-color: lightseagreen; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease; width: 37px; margin-bottom: 8px;"
	   					onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
	   					onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
	   					Edit
					</a>
					<a href="/jobs/delete/${job.id}" onclick="return confirm('Are you sure?')" style="display: inline-block;background-color: lightcoral;color: white;border-radius: 10px;padding: 10px 20px;margin-right: 10px;font-family: Arial, sans-serif;font-weight: bold;text-decoration: none;cursor: pointer;transition: transform 0.3s, box-shadow 0.3s;width: 40px;transform: translateY(0px);box-shadow: none;padding-right: 22px;" onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
	   				Delete
					</a>
	        	</c:if>
	        <a href="/home" style="display: inline-block; background-color:coral; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease; margin-bottom: 8px;"
	   			onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
	   			onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
	   			Back
			</a>
		</div>

        <div id="map"></div>
    </div>

    <script>
        const job = {
            title: '${job.title}',
            lat: parseFloat('${job.latitude}'),
            lng: parseFloat('${job.longitude}')
        };

        const map = L.map('map').setView([job.lat, job.lng], 12);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
        }).addTo(map);

        L.marker([job.lat, job.lng])
            .addTo(map)
            .bindPopup(`<b>${job.title}</b>`);
    </script>
</body>
</html>


    