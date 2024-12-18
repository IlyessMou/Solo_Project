<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Protest+Revolution&family=Sevillana&display=swap" rel="stylesheet">
    <title>Completed Jobs</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <link rel="stylesheet" type="text/css" href="/css/button.css">
    
</head>
<body>

    <div style="border: 5px solid lightblue; background-image:url('https://media.istockphoto.com/id/1397400329/vector/millimeter-graph-paper-grid-geometric-pattern.jpg?s=612x612&w=0&k=20&c=IivJpxAiY-k6jBffYzAnt7m2B4PNuqKj-W4Z3hA-bJ8='); border-radius: 5%; padding: 60px;">
        <div class="navigation">
            <a class="button" href="/logout">
            	 <img src="data:image/png;base64,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">
                <div class="logout">LOGOUT</div>
            </a>
            <a class="button" href="/home">
				<img src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK1psOkODBnkoUvnK9VVMy7FfJLBYitjDy1Q&s'>
    			<div class="logout">${user.balance}</div>
			</a>
			<a class="button" href="/home">
				<img src='data:image/png;base64,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'>
    			<div class="logout">Home</div>
			</a>
        </div>
        
        <h2 class="sevillana-regular" style="place-self: center; font-family: Sevillana, cursive; font-weight: 400; font-style: normal;font-size: xxx-large; color: lightseagreen;margin-top: 85px;">Completed Jobs</h2>
        
        <table style="width: 100%; border: 1px solid lightblue;">
            <thead>
                <tr>
	                <th>Title</th>
	                <th>Description</th>
	                <th>Location</th>
	                <th>Reward</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="job" items="${completedJobs}">
                    <tr>
	                    <td>${job.title}</td>
	                    <td>${job.description}</td>
	                    <td>${job.location}</td>
	                    <td>${job.reward}$</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

    </div>

</body>
</html>
