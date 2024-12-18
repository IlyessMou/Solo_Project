<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Protest+Revolution&family=Sevillana&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Sevillana&display=swap" rel="stylesheet">
    <title>Home</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
        <link rel="stylesheet" type="text/css" href="/css/button.css">
    
    <style>
        #map {
            height: 400px;
            width: 70%;
            margin: auto;     
            border: 3px dashed skyblue;
            border-radius: inherit;       
}
        }
    </style>
</head>
<body>
    <h1 class='protest-revolution-regula' style='font-family: "Protest Revolution", sans-serif;
  font-weight: 400;
  font-style: normal;font-size: xxx-large;
    color: azure;'>Welcome, ${user.username}</h1>
	<div style="border: 5px solid lightblue;background-image:url('https://media.istockphoto.com/id/1397400329/vector/millimeter-graph-paper-grid-geometric-pattern.jpg?s=612x612&w=0&k=20&c=IivJpxAiY-k6jBffYzAnt7m2B4PNuqKj-W4Z3hA-bJ8=');border-radius: 5%; padding: 60px;">
	<div class="navigation">
	<a class="button" href="/logout">
  	<img src="data:image/png;base64,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">
    <div class="logout">LOGOUT</div>
	</a>
  
	<a class="button" href="/jobs/new">
	<img src='data:image/png;base64,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'>
    <div class="logout">AddJob</div>
	</a>
	<a class="button" href="/jobs/completed">
	<img src='data:image/png;base64,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'>
    <div class="logout">Archive</div>
	</a>
	<a class="button" href="/home">
	<img src='https://t4.ftcdn.net/jpg/04/53/70/41/360_F_453704176_fRLaZTHGmRZmM6BpZZe2PT17DBsjb4md.jpg'>
    <div class="logout">${user.balance}</div>
	</a>
	
   </div>

	
    <h2 class="sevillana-regular" style="place-self: center; font-family: Sevillana, cursive; font-weight: 400; font-style: normal;font-size: xxx-large;
    color: lightseagreen;margin-top: 85px;">Available Jobs</h2>
    <table border="1">
        <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Location</th>
                <th>Reward</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="job" items="${availableJobs}">
                <tr>
                    <td>${job.title}</td>
                    <td>${job.description}</td>
                    <td>${job.location}</td>
                    <td>${job.reward}$</td>
                    <td>
        		<form action="/jobs/${job.id}/addToMyJobs" method="post" style="display: inline;">
    				<button type="submit" style="background-color: darkturquoise; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; border: none; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease;margin-bottom: 8px;"
        				onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
        				onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
        				Claim
    				</button>
				</form>
				<a href="/jobs/${job.id}" style="display: inline-block; background-color: paleturquoise; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease;width: 37px; margin-bottom: 8px;"
   						onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
  						onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
   						View
				</a>
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
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    

    <h2 class="sevillana-regular" style="place-self: center; font-family: Sevillana, cursive; font-weight: 400; font-style: normal;font-size: xxx-large;
    color: lightseagreen;">Jobs You've Claimed</h2>
    <table border="1">
        <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Location</th>
                <th>Reward</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="job" items="${userJobs}">
                <tr>
                    <td>${job.title}</td>
                    <td>${job.description}</td>
                    <td>${job.location}</td>
                    <td>${job.reward}$</td>
                    <td>
		                <form action="/completeJob/${job.id}/${user.id}" method="POST" onsubmit="return confirm('Are you sure?');">
		                	<button type="submit" style="background-color: mediumseagreen; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; border: none; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease;margin-bottom: 8px;"
	        					onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
	        					onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
	        					Complete
	    					</button>
		          		</form>
		                <form action="/jobs/${job.id}/unclaim" method="POST" onsubmit="return confirm('Are you sure?');">
		                	<button type="submit" style="background-color: indianred; color: white; border-radius: 10px; padding: 10px 20px; margin-right: 10px; border: none; font-family: Arial, sans-serif; font-weight: bold; text-decoration: none; cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease;margin-bottom: 8px;width: 100px;"
	        					onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 15px rgba(0, 0, 0, 0.2)';"
	        					onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none';">
	        					Unclaim
	    					</button>
		                </form>
                    </td>                   
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <h2 class="sevillana-regular" style="place-self: center; font-family: Sevillana, cursive; font-weight: 400; font-style: normal;font-size: xxx-large;
    color: lightseagreen;">Map Of Jobs</h2>
    <div id="map"></div>
    </div>

    <script>
    const jobs = [
        <c:forEach var="job" items="${availableJobs}">
            { title: '${job.title}', lat: '${job.latitude}', lng: '${job.longitude}' },
        </c:forEach>
    ];

    console.log(jobs);  

    const map = L.map('map').setView([0, 0], 2);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
    }).addTo(map);

    jobs.forEach(job => {
        console.log(`Adding marker for: ${job.title}`);
        
        if (job.lat && job.lng) {
            const marker = L.marker([job.lat, job.lng]).addTo(map);

            const popupContent = document.createElement('div');
            const titleElement = document.createElement('b');
            titleElement.textContent = job.title;

            popupContent.appendChild(titleElement);

            marker.bindPopup(popupContent);
        }
    });

    if (jobs.length > 0) {
        map.setView([jobs[0].lat, jobs[0].lng], 12);
    }
</script>
    
</body>
</html>
    